import 'package:flutter/material.dart';
import 'visit_form_model.dart';

class VisitFormsListPage extends StatelessWidget { //dinamik değil stateless  
  final List<VisitForm> forms; //apiden gelen visit form nesnelerini içerir 
  const VisitFormsListPage({Key? key, required this.forms}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Visit Forms')), //başlık
      body: ListView.separated( //kaydırılabilir liste 
        itemCount: forms.length,  //kaç tane form varsa o kadar liste elemanı oluşturulur 
        separatorBuilder: (_, __) => const Divider(), //ögeler arasında divider bulunur 
        itemBuilder: (_, i) { 
          final f = forms[i];
          return ListTile(
            leading: CircleAvatar(child: Text(f.id.toString())), //solda form id 
            title: Text('${f.reason} (${f.role})'), //form nedeni ve rol 
            subtitle: Text('Entry: ${f.entryTime}'), //giriş zamanı 
          );
        },
      ),
    );
  }
}
