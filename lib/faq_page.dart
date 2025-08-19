import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FAQPage extends StatelessWidget { //dinamik değil sabit metin 
  const FAQPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Frequently Asked Questions')), //başlık scaffold
      body: ListView( //gövde kaydırılabilir liste
        padding: const EdgeInsets.all(16),
        children: [
          ExpansionTile( //tıklanınca açılıp kapanabilen bir kutud
            title: Text(
              '1. How do I register in the app?',
              style: GoogleFonts.openSans(fontWeight: FontWeight.w600),
            ),
            children: [ //Her soru bir title , cevabı  children  

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'On the main screen, tap “Register” and enter your name, ID number, and password to sign up.',
                  style: GoogleFonts.openSans(),
                ),
              ),
            ],
          ),
          ExpansionTile(
            title: Text(
              '2. What information do I need to log in?',
              style: GoogleFonts.openSans(fontWeight: FontWeight.w600),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Use your registered ID number and password on the “Login” screen to access your account.',
                  style: GoogleFonts.openSans(), //yazı tipi okunabilir olsun diye 
                ),
              ),
            ],
          ),
          ExpansionTile(
            title: Text(
              '3. Why do I need to fill out the visit form?',
              style: GoogleFonts.openSans(fontWeight: FontWeight.w600),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'For security reasons, each visitor’s purpose and visit time must be recorded.',
                  style: GoogleFonts.openSans(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
