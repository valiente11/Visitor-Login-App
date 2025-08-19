import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';  //saat biçimlendirmesi için 
import 'package:url_launcher/url_launcher.dart'; //videoyu youtubede açmak için 
import 'api_service.dart';

class VisitFormPage extends StatefulWidget { //state var 
  const VisitFormPage({Key? key}) : super(key: key); //constructor

  @override
  State<VisitFormPage> createState() => _VisitFormPageState(); //widgetın hangi state ile çalıaşacğı
}

class _VisitFormPageState extends State<VisitFormPage> {
  final _formKey = GlobalKey<FormState>(); //form doğrulaması için
  String? _role; //kullanıcı rolü
  final _reasonController = TextEditingController(); //ziyaret sebebi
  TimeOfDay? _entryTime; 
  bool _isProcessing = false; //butona üst üste basılmasını engelle

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }
//flutterın hazır saat seçici penceresi
  Future<void> _pickTime() async {
    final t = await showTimePicker(
      context: context,
      initialTime: _entryTime ?? TimeOfDay.now(),
    );
    if (t != null) setState(() => _entryTime = t);
  }
//youtubede videoyu açma 
  Future<void> _launchYouTube(String id) async {
    final uri = Uri.parse('https://www.youtube.com/watch?v=$id');
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not launch YouTube')),
      );
    }
  }
//boş alan var mı kontrolü
  Future<void> _submit() async {
    if (!_formKey.currentState!.validate() || _entryTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete all fields')),
      );
      return;
    }

    setState(() => _isProcessing = true);

    // Time format  HH:mm:ss
    final now = DateTime.now();
    final dt = DateTime(
      now.year, now.month, now.day, 
      _entryTime!.hour, _entryTime!.minute,
    );
    final entryTime = DateFormat('HH:mm:ss').format(dt);

    // API'ye gönder
    final result = await ApiService.submitVisitForm(
      role: _role!,
      reason: _reasonController.text.trim(),
      entryTime: entryTime,
    );

    setState(() => _isProcessing = false);

    if (result['error'] != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${result['error']}')),
      );
      return;
    }

    // sorun yoksa YouTube açılsın
    const videoMap = {
      'Visitor':       'UroYwlRUMjg',
      'Developer':     'vJYqY18CpNs',
      'Factory Worker':'PIMYHXuFNS0',
    };
    final vid = videoMap[_role!]!;
    await _launchYouTube(vid);

    
    Navigator.pushReplacementNamed(context, '/'); //video açıldıktan sonra ana ekraana yönlendir
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final timeLabel = _entryTime == null
        ? 'Select Entry Time'
        : 'Entry Time: ${_entryTime!.format(context)}';

    return Scaffold(
      appBar: AppBar(title: Text('Visit Form', style: GoogleFonts.openSans())),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Rol seçimi
              Text('Role', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),

                  //arayüz
                  child: DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Select your role',
                    ),
                    items: const [
                      DropdownMenuItem(value: 'Visitor', child: Text('Visitor')),
                      DropdownMenuItem(value: 'Developer', child: Text('Developer')),
                      DropdownMenuItem(value: 'Factory Worker', child: Text('Factory Worker')),
                    ],
                    value: _role,
                    onChanged: (v) => setState(() => _role = v),
                    validator: (v) => v == null ? 'Please select a role' : null,
                  ),
                ),
              ),

              const SizedBox(height: 24),
              
              // Reason          
              Text('Reason for Visit', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),

              //ziyaret sebebi
              TextFormField(
                controller: _reasonController,
                decoration: InputDecoration(
                  hintText: 'Enter your reason...',
                  filled: true,
                  fillColor: cs.surfaceVariant,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                maxLines: 3,
                validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
              ),

              const SizedBox(height: 24),

              // Time picker
              Text('Entry Time', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),

              //saat seçme 
              ElevatedButton.icon(
                icon: const Icon(Icons.access_time),
                label: Text(timeLabel, style: GoogleFonts.openSans()),
                style: ElevatedButton.styleFrom(
                  backgroundColor: cs.surfaceVariant,
                  foregroundColor: cs.onSurfaceVariant,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: _pickTime,
              ),

              const SizedBox(height: 32),

              // submit butonu 
              ElevatedButton(
                onPressed: _isProcessing ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: cs.primary,
                  foregroundColor: cs.onPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(
                  _isProcessing ? 'Submitting...' : 'Submit',
                  style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}