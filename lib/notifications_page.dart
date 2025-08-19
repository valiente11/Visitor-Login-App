import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({Key? key}) : super(key: key);

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  List<dynamic> _notifications = []; //sunucudan alınan bildirim listesi
  bool _loading = true; //bildirimlerin yüklenmesi

//Sayfa ilk açıldığında bildirimleri otomatik olarak çekmek için çalışır 
  @override
  void initState() {
    super.initState();
    _fetchNotifications();
  }
//kullanıcı tcsi alınır 
  Future<void> _fetchNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    final tc = prefs.getString('current_user') ?? '';
    if (tc.isEmpty) return;
  //serverdan tcye ait bildirimler almak için api çağırılır 
    final url = Uri.parse('http://10.0.2.2:3000/notifications/$tc');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body); //Gelen JSON verisi listeye atanır ve yükleme biter.

        setState(() {
          _notifications = data;
          _loading = false;
        });
      } else {
        throw Exception("Sunucu hatası: ${response.statusCode}");
      }
    } catch (e) {
      setState(() {
        _notifications = [];
        _loading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Hata: $e")), //hata mesajı snackbar ile kullanıcıya gösterilir
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),   //sayfa başlığı 
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _notifications.isEmpty
              ? const Center(child: Text('No notifications'))
              : ListView.builder(
                  itemCount: _notifications.length,
                  itemBuilder: (context, index) {
                    final item = _notifications[index];
                  //bildirim varsa card widget oluştur
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: ListTile(
                        leading: const Icon(Icons.notifications),
                        title: Text(item['message']),
                        subtitle: Text(item['created_at']),
                      ),
                    );
                  },
                ),
    );
  }
}
