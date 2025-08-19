import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingsPage extends StatelessWidget { //dinamik değil stateless
  final bool highContrast; //contrast ayarlama için
  final double textScale; //yazı tipi ayarlama için
  final ValueChanged<bool> onContrastChanged; //kontrast değişince çalışacak fonk
  final ValueChanged<double> onTextScaleChanged; // yazı tipi değişince çalışacak fonk


  const SettingsPage({
    Key? key,
    required this.highContrast,
    required this.textScale,
    required this.onContrastChanged,
    required this.onTextScaleChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')), //başlık
      body: Padding( //tablo kenarlığı olsun diye 
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Accessibility',
                style: GoogleFonts.poppins(
                    fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            SwitchListTile( //yüksek kontrast açılması için 
              title: const Text('High Contrast'),
              subtitle: const Text('Improve text visibility'),
              value: highContrast,
              activeColor: cs.primary,
              onChanged: onContrastChanged, //contrast değiştiği üst widgete bildirilir
            ),
            const SizedBox(height: 16),
            Text('Text Size: ${(textScale * 100).round()}%',
                style: GoogleFonts.openSans(fontSize: 16)),
            Slider(   //max 1.5 min 0.8 metin boyutu olsun 
              min: 0.8,
              max: 1.5,
              divisions: 7,
              label: '${(textScale * 100).round()}%',
              value: textScale,
              activeColor: cs.primary,
              onChanged: onTextScaleChanged, //text size değişince değeri güncelle
            ),
          ],
        ),
      ),
    );
  }
}
