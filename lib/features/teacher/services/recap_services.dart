import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:absensi/features/teacher/models/recap_model.dart';
import 'package:absensi/features/auth/data/simple_token_service.dart';

class RecapService {
  static const String baseUrl = 'http://192.168.1.14:3000/api';
  
  static Future<List<RecapModel>> fetchRecaps() async {
    try {
      final token = SimpleTokenService.getToken();
      
      if (token == null) {
        throw Exception('Token tidak ditemukan');
      }
      
      final response = await http.get(
        Uri.parse('$baseUrl/laporan'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((json) => RecapModel.fromJson(json)).toList();
      } else if (response.statusCode == 401) {
        throw Exception('Token tidak valid atau expired');
      } else {
        throw Exception('Gagal mengambil data laporan: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}