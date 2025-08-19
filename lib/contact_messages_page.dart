import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'contact_message_model.dart'; 

//state gerekmediğinden stateless widget olarak tanımlanmıştır tek amaç contact messageleri listelemek 

class ContactMessagesPage extends StatelessWidget {
  final List<ContactMessage> messages; // bu parametere sayesinde contact_message sayfasındaki nesneler liste olarak gönderilebilmektedir listenenin her elemanı bir nesnedir
  const ContactMessagesPage({Key? key, required this.messages}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    //scaffold görünüm sınıfı 
    return Scaffold(
      appBar: AppBar(title: const Text('Contact Messages')),
      body: ListView.separated( //mesajlar ayrı görüntülensin hepsinin arasında divider olsun 
        itemCount: messages.length, //kullanıcı listesinin uzunluğu kadar öge oluştur 
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (_, i) { //mesajları ekrana yansıtır itembuilder

          final m = messages[i];
          return ListTile(
            leading: const Icon(Icons.message), //Solda bir mesaj simgesi
            title: Text(m.message, style: GoogleFonts.openSans()),
            subtitle: Text(//Gönderilen mesaj
              '${m.tc} • ${m.createdAt}', //TC numarası ve oluşturulma zamanı
              style: GoogleFonts.openSans(fontSize: 12, color: cs.onBackground.withOpacity(0.7)), 
            ),
          );
        },
      ),
    );
  }
}
