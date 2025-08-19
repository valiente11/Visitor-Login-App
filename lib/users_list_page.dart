import 'package:flutter/material.dart';
import 'user_model.dart';
//dinamik değil admin profilinde kullanıcı listelemek içni stateless  
class UsersListPage extends StatelessWidget {
  final List<User> users; //dışarıdan list user nesnesi alınır 
  const UsersListPage({Key? key, required this.users}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('User List')), //başlık 
      body: ListView.separated( //body kullancılar sıralı olsun diye seperated 
        itemCount: users.length, //kullanıcı listesinin uzunluğu kadar öge oluştur 
        separatorBuilder: (_, __) => const Divider(), // aralarında divider 
        itemBuilder: (_, index) {
          final user = users[index];
          return ListTile( //kullanıcıları listile formatında göster 
            leading: CircleAvatar(child: Text(user.id.toString())), //kullanıcı idsi
            title: Text(user.name), 
            subtitle: Text('TC: ${user.tc} • Role: ${user.role}'), 
          );
        },
      ),
    );
  }
}
