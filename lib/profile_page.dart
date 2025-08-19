import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'api_service.dart';
import 'users_list_page.dart';
import 'visit_forms_list_page.dart';
import 'contact_messages_page.dart';
import 'notifications_page.dart';

class ProfilePage extends StatefulWidget { //dinamik sayfa state var
  const ProfilePage({Key? key}) : super(key: key); //const

  @override
  State<ProfilePage> createState() => _ProfilePageState(); //widget hangi state sınıfına çalışacağı
}
//mood 
class _ProfilePageState extends State<ProfilePage> {
  bool _isAdmin = false;
  File? _profileImage;
  String _tc = '';
  String _mood = '😊';
  final List<String> _moodOptions = ['😊', '😐', '😢', '😎', '😴'];


  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

//admin için kullanıcı kontrolü
  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final tc = prefs.getString('current_user') ?? '';
    setState(() {
      _tc = tc;
      _isAdmin = (tc == '00000000000');
    });

  //profil fotoğrafı seçilen foto 
    final imagePath = prefs.getString('profile_image_path_$tc');
    if (imagePath != null && await File(imagePath).exists()) {
      setState(() => _profileImage = File(imagePath));
    }

//kullanıcının seçtiği mood görünsün
    final mood = prefs.getString('user_mood_$tc') ?? '😊';
    setState(() => _mood = mood);
  }

//profil foto seçme fonk 
  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('profile_image_path_$_tc', picked.path);
      setState(() => _profileImage = File(picked.path));
    }
  }
  //contact us için fonk
  void _showContactDialog() {
    final controller = TextEditingController();
    bool isSending = false;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) {
          //alert dialog içinde texfield açılır 
          return AlertDialog(
            title: const Text('Contact Us'),
            content: TextField(
              controller: controller,
              maxLines: 4,
              decoration: const InputDecoration(
                //kullanıcı mesajını yazar
                hintText: 'Type your message here...',
                border: OutlineInputBorder(),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: isSending
                    ? null
                    : () async {
                        final msg = controller.text.trim();
                        if (msg.isEmpty) return;
                        setState(() => isSending = true);

                        //contact us verileri mysqle post edilir 
                        final uri = Uri.parse('http://10.0.2.2:3000/contact_us');
                        try {
                          final res = await http
                              .post(
                                uri,
                                headers: {'Content-Type': 'application/json'},
                                body: jsonEncode({'tc': _tc, 'message': msg}),
                              )
                              .timeout(const Duration(seconds: 10));
                            //başarılıysa gönderim 
                          if (res.statusCode == 200) {
                            Navigator.pop(ctx);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Message sent!')),
                            );
                          } else {
                            throw Exception('Server error: ${res.statusCode}');
                          }
                        } on TimeoutException {
                          setState(() => isSending = false);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Request timed out.')),
                          );
                        } catch (e) {
                          setState(() => isSending = false);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Error: ${e.toString()}')),
                          );
                        }
                      },
                child: isSending
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : const Text('Send'),
              ),
            ],
          );
        },
      ),
    );
  }
  //puanlama fonk 
  void _showRatingDialog() {
  double rating = 3.0;

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Welcome'),
        content: StatefulBuilder(
          builder: (context, setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("Rate The Application"),
                Slider(
                  value: rating,
                  min: 1,
                  max: 5,
                  divisions: 4,
                  label: rating.round().toString(),
                  onChanged: (val) => setState(() => rating = val),
                ),
              ],
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                //puanlama gönderşldi
                await ApiService.submitAppRating(rating.round());
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Saved.")),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("error: $e")),
                );
              }
            },
            child: const Text('Send'),
          ),
        ],
      );
    },
  );
}

  
//adminin herhangi bir kullanıcıya bildirim göndermesi için fonk
  void _showSendNotificationDialog() {
    final tcController = TextEditingController();
    final messageController = TextEditingController();
    bool isSending = false;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) {
          return AlertDialog(
            title: const Text("Send Notification"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: tcController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Target TC Number",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: messageController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: "Message",
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: isSending
                    ? null
                    : () async {
                        final tc = tcController.text.trim();
                        final msg = messageController.text.trim();
                        if (tc.length != 11 || msg.isEmpty) return;

                        setState(() => isSending = true);
                        //adminden alınan bilgiler post edilir 
                        try {
                          final res = await http.post(
                            Uri.parse("http://10.0.2.2:3000/admin_notify"),
                            headers: {"Content-Type": "application/json"},
                            body: jsonEncode({"tc": tc, "message": msg}),
                          );
                          //tc mysql tablsounda kayıtlıysa gönder
                          if (res.statusCode == 200) {
                            Navigator.pop(ctx);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Notification sent!")),
                            );
                          } else {
                            throw Exception("Status: ${res.statusCode}");
                          }
                        } catch (e) {
                          setState(() => isSending = false);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Error: $e")),
                          );
                        }
                      },
                child: isSending
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text("Send"),
              )
            ],
          );
        },
      ),
    );
  }
  //admin paneline yönlendirme
  void _entryAndExit() => Navigator.pushNamed(context, '/admin_panel');
  //kullanıcı için visit form sayfasına yönlendirme 
  void _goVisitForm() => Navigator.pushNamed(context, '/visit_form');
//oturumu kapatma için fonk  
  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('current_user');
    Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
  }

//kullanıcı listeleme fonk
  Future<void> _listUsers() async {
    try {
      final users = await ApiService.getUsers();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => UsersListPage(users: users)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching users: $e')),
      );
    }
  }
//visit formları lsiteleme fonk
  Future<void> _listVisitForms() async {
    try {
      final forms = await ApiService.getVisitForms();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => VisitFormsListPage(forms: forms)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching visit forms: $e')),
      );
    }
  }
//contact message lsiteleme fonk
  Future<void> _listContactMessages() async {
    try {
      final messages = await ApiService.getContactMessages();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => ContactMessagesPage(messages: messages)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching messages: $e')),
      );
    }
  }
//arayüz
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 48,
                backgroundColor: cs.primaryContainer,
                backgroundImage: _profileImage != null ? FileImage(_profileImage!) : null,
                child: _profileImage == null
                    ? Icon(Icons.person, size: 48, color: cs.onPrimaryContainer)
                    : null,
              ),
            ),
            //profil fotoğrafı ekleme sonrası ekran görünümü
            const SizedBox(height: 8),
            Text(
              _profileImage == null ? 'Tap to add profile photo' : 'Photo uploaded',
              style: GoogleFonts.openSans(
                fontSize: 12,
                color: cs.onBackground.withOpacity(0.6),
              ),
            ),

            //mood butonu
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Your mood today: "),
                DropdownButton<String>(
                  value: _mood,
                  items: _moodOptions
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (val) async {
                    if (val == null) return;
                    setState(() => _mood = val);
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.setString('user_mood_$_tc', val);
                  },
                ),
              ],
            ),
            const Spacer(),
          //admin değilse bildirimler butonu  
            if (!_isAdmin)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.notifications),
                  label: const Text('Notifications'),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const NotificationsPage()),
                  ),
                ),
              ),
            //admin sayfası için özel butonlar 
            if (_isAdmin)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.message),
                  label: const Text("Send Notification"),
                  onPressed: _showSendNotificationDialog,
                ),
              ),
            const SizedBox(height: 12),
          //contact us butonu 
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.contact_mail),
                label: const Text('Contact Us'),
                onPressed: _showContactDialog,
              ),
            ),
            //Rate Of Us butonu
            const SizedBox(height: 12),
            SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
            icon: const Icon(Icons.star),
          label: const Text('Rate Of Us'),
            onPressed: _showRatingDialog,
  ),
),


            const SizedBox(height: 16),
              // list user butonu 
            if (_isAdmin) ...[
              ElevatedButton.icon(
                icon: const Icon(Icons.list),
                label: const Text("List Users"),
                onPressed: _listUsers,
              ),
              //list visit form butonu 
              const SizedBox(height: 12),
              ElevatedButton.icon(
                icon: const Icon(Icons.list_alt),
                label: const Text("List Visit Forms"),
                onPressed: _listVisitForms,
              ),
              //list messages butonu 
              const SizedBox(height: 12),
              ElevatedButton.icon(
                icon: const Icon(Icons.message),
                label: const Text("List Messages"),
                onPressed: _listContactMessages,
              ),
              //entry and exit butonu 
              const SizedBox(height: 12),
              ElevatedButton.icon(
                icon: const Icon(Icons.admin_panel_settings),
                label: const Text("Entry and Exit"),
                onPressed: _entryAndExit,
              ),
              const SizedBox(height: 24),
            ],
            //visit form butonu 
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.note_alt),
                    label: const Text('Visit Form'),
                    onPressed: _goVisitForm,
                  ),
                ),
                const SizedBox(width: 16),
                //logout butonu
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.logout),
                    label: const Text('Logout'),
                    onPressed: _logout,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: cs.error,
                      foregroundColor: cs.onError,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
