import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import 'api_service.dart';

class LoginPage extends StatefulWidget { //statefull widget tanımla dinamik
  const LoginPage({Key? key}) : super(key: key); //Bu, Flutter’daki standart constructor yapısı
  @override
  State<LoginPage> createState() => _LoginPageState(); //Fluttera bu widgetın hangi State  ile çalışacağını söyler.

}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>(); //form doğrulama için 
  String _tc = '';
  String _password = '';

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    //backende post gönderilir giriş bilgileri kontrol edilir
    final result = await ApiService.login(
      tc: _tc,
      password: _password,
    );

    //shared preferences ile tc ve rol sakla 
    if (result['name'] != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('current_user', _tc);
      await prefs.setString('current_role', result['role'] ?? 'user');

      final message = result['message'] as String?;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            message ?? 'Welcome, ${result['name']}!',
          ),
        ),
      );

      // Profil sayfasına geç
      Navigator.pushReplacementNamed(context, '/profile');
    } else {

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['error'] ?? 'Login failed')),
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
                    borderRadius: BorderRadius.circular(16)),
                elevation: 8,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    Text('Welcome Back',
                        style: GoogleFonts.poppins(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: cs.primary)),

                    const SizedBox(height: 16),
    Text(
  'veya',
  style: GoogleFonts.openSans(fontSize: 14, color: Colors.grey),
),
const SizedBox(height: 8),




//face id girişi
TextButton.icon(
  icon: const Icon(Icons.face),
  label: const Text("Face ID"),
  style: TextButton.styleFrom(
    textStyle: GoogleFonts.openSans(fontSize: 16),
  ),
  onPressed: () {
    Navigator.pushNamed(context, '/face-login');
  },
),
  
                    const SizedBox(height: 8),
                    Text('Please sign in to continue',
                        style: GoogleFonts.openSans(
                            fontSize: 16,
                            color: cs.onSurface.withOpacity(0.6))),
                    const SizedBox(height: 24),

                    //giriş ayarları TC
                    Form(
                      key: _formKey,
                      child: Column(children: [
                        TextFormField(
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.person),
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

                        //password
                        const SizedBox(height: 16),
                        TextFormField(
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.lock),
                            labelText: 'Password',
                            border: OutlineInputBorder(),
                          ),
                          obscureText: true,
                          style: GoogleFonts.openSans(),
                          onSaved: (v) => _password = v!.trim(),
                          validator: (v) =>
                              v == null || v.trim().isEmpty ? 'Required' : null,
                        ),
                      
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,

                          //button
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              textStyle: GoogleFonts.openSans(
                                  fontSize: 18, fontWeight: FontWeight.w600),
                            ),
                            onPressed: _login,
                            child: const Text('Login'),
                          ),
                        ),
                      ]),
                    ),
                  ]),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
