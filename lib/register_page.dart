import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'api_service.dart';


class RegisterPage extends StatefulWidget { //state bağlı
  const RegisterPage({Key? key}) : super(key: key);//constructor
  @override
  State<RegisterPage> createState() => _RegisterPageState(); //widgetin hangi state sınıfı ile çalışacağı
}

//widgetin çalışacağı sınıf 
class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();//form alanlarını kontrol etmek için 
  String _name = '';
  String _tc = '';
  String _password = '';

  File? _selfieFile;
  bool _selfieUploaded = false; //selfie sunucuya başarıyla gönderilince true olur 


  Future<void> _takeSelfie() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);//kullanıcı kamerayı açıp selfie çeker
    if (pickedFile != null) {
      setState(() {
        _selfieFile = File(pickedFile.path);//foto varsa _selfieFile eklenir
      });
    }
  }
//selfie gönderme 
    Future<void> _uploadSelfie(String tc) async {
  if (_selfieFile == null) return;

  final bytes = await _selfieFile!.readAsBytes();
  final base64Image = base64Encode(bytes); //çekilen selfie base64 formatına çevrilir

//python sunucusuna gönderilir post 
  final response = await http.post(
    Uri.parse('http://10.0.2.2:5000/register'), 
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({
      "tc": tc,
      "image": base64Image,
    }),
  );

  if (response.statusCode == 200) {
    final result = jsonDecode(response.body);
    if (result["status"] == "success") { 
      setState(() {
        _selfieUploaded = true; //gönderme başarılıysa _selfieFile true yapılır
      });
      print("✅ Selfie başarıyla yüklendi.");
    } else {
      print("❌ Sunucu hatası: ${result["message"]}");
    }
  } else {
    print("❌ HTTP hatası: ${response.statusCode}");
  }
}


   
//index.jsdeki register endpointine istek 
  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
//başarılıysa
    final result = await ApiService.register(
      name: _name,
      tc: _tc,
      password: _password,
    );

    if (result['id'] != null) {
      await _uploadSelfie(_tc); 

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registration successful!')),
      );
      Navigator.pushReplacementNamed(context, '/login');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['error'] ?? 'Registration failed')),
      );
    }
  }
//arayüz
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF2575FC), Color(0xFF6A11CB)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 8,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Create Account',
                        style: GoogleFonts.poppins(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: cs.primary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Please fill in the details below',
                        style: GoogleFonts.openSans(
                          fontSize: 16,
                          color: cs.onSurface.withOpacity(0.6),
                        ),
                      ),
                      //isim 
                      const SizedBox(height: 24),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              decoration: const InputDecoration(
                                prefixIcon: Icon(Icons.person_outline),
                                labelText: 'Full Name',
                                border: OutlineInputBorder(),
                              ),
                              style: GoogleFonts.openSans(),
                              onSaved: (v) => _name = v!.trim(),
                              validator: (v) =>
                                  v == null || v.trim().isEmpty ? 'Required' : null,
                            ),
                            //tc kontrolü
                            const SizedBox(height: 16),
                            TextFormField(
                              decoration: const InputDecoration(
                                prefixIcon: Icon(Icons.badge_outlined),
                                labelText: 'TC Number',
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                              maxLength: 11,
                              style: GoogleFonts.openSans(),
                              onSaved: (v) => _tc = v!.trim(),
                              validator: (v) =>
                                  v == null || v.trim().length != 11
                                      ? 'Must be 11 digits'
                                      : null,
                            ),
                            //şifre kontrolü
                            const SizedBox(height: 16),
                            TextFormField(
                              decoration: const InputDecoration(
                                prefixIcon: Icon(Icons.lock_outline),
                                labelText: 'Password',
                                border: OutlineInputBorder(),
                              ),
                              obscureText: true,
                              style: GoogleFonts.openSans(),
                              onSaved: (v) => _password = v!.trim(),
                              validator: (v) =>
                                  v == null || v.trim().length < 4
                                      ? 'Min 4 characters'
                                      : null,
                            ),
                            const SizedBox(height: 24),

                            if (_selfieFile != null)
                              Column(
                                children: [
                                  Image.file(_selfieFile!, height: 120),
                                  const SizedBox(height: 8),
                                ],
                              ),
                              //selfie butonu
                            ElevatedButton(
                              onPressed: _takeSelfie,
                              child: const Text("Face ID"),
                            ),
                            if (_selfieUploaded)
                              const Padding(
                                padding: EdgeInsets.only(top: 8),
                                child: Text(
                                  "Selfie download ✅",
                                  style: TextStyle(color: Colors.green),
                                ),
                              ),

                            const SizedBox(height: 24),
                            SizedBox(
                              width: double.infinity,
                              //register butonu
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  textStyle: GoogleFonts.openSans(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                onPressed: _submit,
                                child: const Text('Register'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
