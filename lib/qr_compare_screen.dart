import 'dart:io';
import 'package:flutter/material.dart';
import 'package:barcode_widget/barcode_widget.dart' as bw; //QR kodu ekranda göstermek için
import 'package:image_picker/image_picker.dart'; //Kamera ile fotoğraf çekmek için
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart'; //Google ML Kit ile QR kod taramak için
import 'package:uuid/uuid.dart'; //Benzersiz bir QR veri kodu üretmek için


class QRCompareScreen extends StatefulWidget { //statefull widget oluşturuldu
  const QRCompareScreen({Key? key}) : super(key: key); //constructor

  @override
  State<QRCompareScreen> createState() => _QRCompareScreenState(); //widget hangi state class ile çalıaşcak 
}

//widgetın çalışcağı class
class _QRCompareScreenState extends State<QRCompareScreen> {
  late final String _expectedCode; //ekrandki qr kod verisi 
  final ImagePicker _picker = ImagePicker(); //kamerayı başlatmak için 
  final BarcodeScanner _scanner = BarcodeScanner(); //qr kodu tespit etmek içni 
  bool _isProcessing = false; //kullanıcının üst üste işlem yapmasını engelle

//rastgele qr kod verisi oluşturmak için 
  @override
  void initState() {
    super.initState();
    _expectedCode = const Uuid().v4(); 
  }
//sayfa kapanırken çalışır
  @override
  void dispose() {
    _scanner.close();
    super.dispose();
  }
  //işlem devam ederken kullanıcı tekrar butona basamaz
  Future<void> _captureAndCompare() async {
    if (_isProcessing) return;
    setState(() => _isProcessing = true);

    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    if (photo == null) {
      setState(() => _isProcessing = false);
      return;
    }
  //Google ML Kit ile resimden QR kod verisi çıkarılır
    final input = InputImage.fromFilePath(photo.path);
    final barcodes = await _scanner.processImage(input);

    if (barcodes.isNotEmpty) {
      final scanned = barcodes.first.rawValue ?? '';
      //qr karşılaştırılır
      if (scanned == _expectedCode) {
        Navigator.of(context).pushReplacementNamed('/');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
      
          SnackBar(content: Text('Code does not match: $scanned')), //snackbar ile kullanıcıya bilgi verilir
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No QR code detected.')),
      );
    }

    setState(() => _isProcessing = false);
  }
//arayüz
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('QR Code Verification')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //_expectedCode QR formatinde gösterilir
            bw.BarcodeWidget(
              barcode: bw.Barcode.qrCode(),
              data: _expectedCode,
              width: 200,
              height: 200,
            ),
            const SizedBox(height: 32),
            //kamera butonu 
            ElevatedButton.icon(
              icon: const Icon(Icons.camera_alt),
              label: Text(
                _isProcessing ? 'Please wait…' : 'Capture and Upload QR Photo', //üst üste işlem yapmamak için 
              ),
              onPressed: _isProcessing ? null : _captureAndCompare,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
