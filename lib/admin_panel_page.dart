import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'api_service.dart';

class AdminPanelPage extends StatefulWidget { //state bağlı 
  const AdminPanelPage({Key? key}) : super(key: key); //constructor

  @override
  State<AdminPanelPage> createState() => _AdminPanelPageState(); //widgetin hangi state class işle çalışacağı
}

class _AdminPanelPageState extends State<AdminPanelPage> { //class tanımladım stateini verdim
  final _formKey = GlobalKey<FormState>();
  String? _name; //kullanıcıdan alınacak veriler
  TimeOfDay? _inTime;
  TimeOfDay? _outTime;

  final List<Map<String, dynamic>> _records = []; //geçiçi olarak listede sakla sonra mysqle gitcek

  Future<void> _pickTime({required bool isIn}) async { //giriş çıkış saatini al
    final t = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (t == null) return;
    setState(() {
      if (isIn) _inTime = t;
      else      _outTime = t;
    });
  }

  String formatTimeOfDay(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
 //kayıt gönderme fonk.
  void _submit() async {
    if (!_formKey.currentState!.validate() || _inTime == null || _outTime == null) { //tüm alanlar dolu mu
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields and select the times.')),
      );
      return;
    }
    //verileri kaydetme
    _formKey.currentState!.save();

    final name = _name!;
    final entryFormatted = formatTimeOfDay(_inTime!);
    final exitFormatted = formatTimeOfDay(_outTime!);

    //api_service fonk kayıtları mysqle göndermek için 
    try {
      await ApiService.saveAttendanceRecord(
        name: name,
        entryTime: entryFormatted,
        exitTime: exitFormatted,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Record saved to database.')),
      );

    //yeni kayıt mysqlede tabloya eklenir
      setState(() {
        _records.add({
          'name': name,
          'in': _inTime!,
          'out': _outTime!,
        });
        _name = null;
        _inTime = null;
        _outTime = null;
        _formKey.currentState!.reset();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving to database: $e')),
      );
    }
  }
 
 //arayüz
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Panel')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            //admin panelindeki giriş çıkış ve isim için
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: const InputDecoration(labelText: 'Name'),
                        validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
                        onSaved: (v) => _name = v!.trim(),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              _inTime == null
                                  ? 'Select entry time'
                                  : 'Entry: ${_inTime!.format(context)}',
                            ),
                          ),
                          TextButton(
                            onPressed: () => _pickTime(isIn: true),
                            child: const Text('Pick'),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              _outTime == null
                                  ? 'Select exit time'
                                  : 'Exit: ${_outTime!.format(context)}',
                            ),
                          ),
                          TextButton(
                            onPressed: () => _pickTime(isIn: false),
                            child: const Text('Pick'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: _submit,
                        child: const Text('Save'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            //kayıt varsa göster 
            Expanded(
              child: _records.isEmpty
                  ? const Center(child: Text('No records yet.'))
                  : ListView.separated(
                      itemCount: _records.length,
                      separatorBuilder: (_, __) => const Divider(),
                      itemBuilder: (ctx, i) {
                        final r = _records[i];
                        return ListTile(
                          leading: const Icon(Icons.person),
                          title: Text(r['name'], style: GoogleFonts.openSans()),
                          subtitle: Text(
                            'Entry: ${r['in'].format(context)}, Exit: ${r['out'].format(context)}',
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
