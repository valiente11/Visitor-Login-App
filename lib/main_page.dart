import 'package:flutter/material.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});
//eğer face id başarılıysa bu ekran çıkar
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Ana Sayfa")),
      body: const Center(
        child: Text("Yüz tanıma başarılı!"),
      ),
    );
  }
}
