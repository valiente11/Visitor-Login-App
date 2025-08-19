import 'dart:convert';  //base64 ve json dönüşümü
import 'dart:io';       //fotoğraf dosyasını okuma 
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';  //foto çekmek 
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart'; 

class FaceLoginPage extends StatefulWidget {
  const FaceLoginPage({Key? key}) : super(key: key);

  @override
  State<FaceLoginPage> createState() => _FaceLoginPageState();
}

class _FaceLoginPageState extends State<FaceLoginPage> {
  File? _imageFile;  //kullanıcının çektiği yüz
  bool _loading = false; //durum
  String _message = ''; //kullanıcıya mesaj göndermek içni 

  Future<void> _pickAndRecognize() async {
    setState(() {
      _loading = true;
      _message = '';
    });

  //kamera açılır ve kullanıcıdan foto çekmesi istenir  
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile == null) {
      setState(() {
        _loading = false;
        _message = 'Fotoğraf seçilmedi.';
      });
      return;
    }
    //python sunucusuna göndermek için önce base64 formatıan çevirilir
    _imageFile = File(pickedFile.path);
    final imageBytes = await pickedFile.readAsBytes();
    final base64Image = base64Encode(imageBytes);

  //python sunucusundaki recognize endpointine post gönderme
    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:5000/recognize'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'image': base64Image}),
      );

      //başarılı giriş
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        if (json['status'] == 'success') {
          String tc = json['tc'];

          // tanınan tcyi shared preferencele kaydet
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('current_user', tc);

          setState(() {
            _message = 'Hoş geldiniz, TC: $tc';
          });

          Navigator.pushReplacementNamed(context, '/profile');
        } else {
          setState(() {
            _message = 'Yüz tanınamadı.';
          });
        }
      } else {
        setState(() {
          _message = 'Sunucu hatası: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _message = 'Hata: $e';
      });
    }

    setState(() {
      _loading = false;
    });
  }
 //arayüz
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Log in With Face ID')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_imageFile != null)
                Image.file(_imageFile!, height: 150),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _loading ? null : _pickAndRecognize,
                icon: const Icon(Icons.face),
                label: const Text("Log in With Face ID"),
              ),
              const SizedBox(height: 16),
              if (_loading) const CircularProgressIndicator(),
              if (_message.isNotEmpty) Text(_message),
            ],
          ),
        ),
      ),
    );
  }
}
