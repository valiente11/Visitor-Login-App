class VisitForm {
  final int id;
  final String role;
  final String reason;
  final String entryTime;
 //Constructor  tüm alanlar gerekli visit form verilerini admin profilinde listelemek için 
  VisitForm({
    required this.id,
    required this.role,
    required this.reason,
    required this.entryTime,
  });
  // factory constructor apiden gelen json verisini visit form nesnesine çevir listelemek için 
  //mysql jsondan anlar flutter oop old için nesneden anlar
  factory VisitForm.fromJson(Map<String, dynamic> json) => VisitForm( 
        id:        json['id'] as int,
        role:      json['role'] as String,
        reason:    json['reason'] as String,
        entryTime: json['entry_time'] as String,
      );
}
