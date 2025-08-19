
class ContactMessage {
  final int id;
  final String tc;
  final String message;
  final String createdAt;

  //constructor tüm alanların girilmesi gerekli olması için
  ContactMessage({
    required this.id,
    required this.tc,
    required this.message,
    required this.createdAt,
  });
  //json formatında veriden contact message nesnesi oluşturmak için amaç apiden gelen verileri alıp 
  //nesneye dönüştürmek ve admin panelinde kullanıcı mesajlarını listelemek

  factory ContactMessage.fromJson(Map<String, dynamic> json) {
    return ContactMessage(
      id: json['id'] as int,
      tc: json['tc'] as String,
      message: json['message'] as String,
      createdAt: json['created_at'] as String,
    );
  }
}
