import 'dart:convert';  //json dönüşümleri
import 'package:http/http.dart' as http; //http istekleri

import 'user_model.dart';
import 'visit_form_model.dart';
import 'contact_message_model.dart'; 

class ApiService {
  static const String _baseUrl = 'http://10.0.2.2:3000'; //android emülatörde request bu url ile 

//registere endpointine post gönderme 
  static Future<Map<String, dynamic>> register({
    required String name,
    required String tc,
    required String password,
  }) async {
    final uri = Uri.parse('$_baseUrl/register');
    try {
      final res = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'name': name, 'tc': tc, 'password': password}),
      );
      return jsonDecode(res.body) as Map<String, dynamic>;
    } catch (e) {
      return {'error': e.toString()};
    }
  }

//login endpointine tc ve şifre gönderme post
  static Future<Map<String, dynamic>> login({
    required String tc,
    required String password,
  }) async {
    final uri = Uri.parse('$_baseUrl/login');
    try {
      final res = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'}, //json formatında verileri ver
        body: jsonEncode({'tc': tc, 'password': password}), 
      );
      return jsonDecode(res.body) as Map<String, dynamic>; //flutter için map olarak döndür
    } catch (e) {
      return {'error': e.toString()};
    }
  }

//flutterdan mysqle form göndrme post
  static Future<Map<String, dynamic>> submitVisitForm({
    required String role,
    required String reason,
    required String entryTime,
  }) async {
    final uri = Uri.parse('$_baseUrl/visit_form');
    try {
      final res = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'role': role,
          'reason': reason,
          'entryTime': entryTime,
        }),
      );
      return jsonDecode(res.body) as Map<String, dynamic>;
    } catch (e) {
      return {'error': e.toString()};
    }
  }

//kullanıcıları mysqlden çekme admin profilinde listelemek için get
  static Future<List<User>> getUsers() async {
    final uri = Uri.parse('$_baseUrl/admin/users');
    final res = await http.get(uri, headers: {'Content-Type': 'application/json'});
    if (res.statusCode == 200) {
      final List data = jsonDecode(res.body);
      return data.map((e) => User.fromJson(e)).toList();
    }
    throw Exception('Failed to load users (Status code: ${res.statusCode})');
  }

  //form verilerini mysqlden çekme get

  static Future<List<VisitForm>> getVisitForms() async {
    final uri = Uri.parse('$_baseUrl/admin/visit_forms');
    final res = await http.get(uri, headers: {'Content-Type': 'application/json'});
    if (res.statusCode == 200) {
      final List data = jsonDecode(res.body);
      return data.map((e) => VisitForm.fromJson(e)).toList();
    }
    throw Exception('Failed to load visit forms (Status code: ${res.statusCode})');
  }
 
//mysqlden contanct messageleri çekme get
  static Future<List<ContactMessage>> getContactMessages() async {
    final uri = Uri.parse('$_baseUrl/admin/contact_us');
    final res = await http.get(uri, headers: {'Content-Type': 'application/json'});
    if (res.statusCode == 200) {
      final List data = jsonDecode(res.body);
      return data.map((e) => ContactMessage.fromJson(e)).toList();
    }
    throw Exception('Failed to load contact messages (Status code: ${res.statusCode})');
  }
//admin profilindeki giriş çıkış kaydını mysqle gönderme post
  static Future<void> saveAttendanceRecord({
    required String name,
    required String entryTime,
    required String exitTime,
  }) async {
    final uri = Uri.parse('$_baseUrl/admin/records');
    final res = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'entryTime': entryTime,
        'exitTime': exitTime,
      }),
    );

    if (res.statusCode != 200) {
      throw Exception('Attendance kaydedilemedi: ${res.body}');
    }
  }
 //ratingleri mysqle göndrrme post
  static Future<void> submitAppRating(int rating) async {
    final uri = Uri.parse('$_baseUrl/rate_app');
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'rating': rating}),
    );
    if (response.statusCode != 200) {
      throw Exception('Rating gönderilemedi: ${response.body}');
    }
  }
}
