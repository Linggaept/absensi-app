import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:absensi/common/constants/api_constants.dart';
import 'package:absensi/common/models/user_model.dart';

class AuthService {
  Future<User> login(String username, String password) async {
    final response = await http.post(
      Uri.parse(ApiConstants.loginUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      // Jika server mengembalikan response 200 OK, parse JSON.
      // Asumsi API Anda mengembalikan: { "status": "success", "data": { ...user... } }
      final responseBody = jsonDecode(response.body);
      return User.fromJson(responseBody['data']);
    } else {
      // Jika gagal, lempar exception dengan pesan dari API.
      throw Exception(jsonDecode(response.body)['message'] ?? 'Gagal untuk login.');
    }
  }
}