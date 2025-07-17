import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  static const String baseUrl = 'http://192.168.1.14:3000/api';
  
  Future<AuthResponse> login(String nipNis, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'nip_nis': nipNis,
          'password': password,
        }),
      );

      final responseBody = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return AuthResponse.fromJson(responseBody);
      } else {
        throw Exception(responseBody['message'] ?? 'Gagal untuk login.');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }
}

class AuthResponse {
  final String message;
  final String token;
  final String role;
  final int id;

  AuthResponse({
    required this.message,
    required this.token,
    required this.role,
    required this.id,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      message: json['message'],
      token: json['token'],
      role: json['role'],
      id: json['id'] ?? 0,
    );
  }
}