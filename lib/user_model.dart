//tüm değişkenler final oluşturulduktan sonra değiştirilemez
class User {
  final int id; 
  final String name;
  final String tc;
  final String role;
//tüm bilgiler gerekli constructor
  User({
    required this.id,  
    required this.name,
    required this.tc,
    required this.role,
  });
// jsondan nesne user nesnesi oluşturma userları mysqlden alıp api ile admin profilinde listelemek için farklı bir sayfada listelemek için gerekli kodlar var
  factory User.fromJson(Map<String, dynamic> json) => User(
        id:   json['id']   as int,
        name: json['name'] as String,
        tc:   json['tc']   as String,
        role: json['role'] as String,
      );
//nesneyi tekrar jsona dönüştürme 
  Map<String, dynamic> toJson() => {
        'id':   id,
        'name': name,
        'tc':   tc,
        'role': role,
      };
}
