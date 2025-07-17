// services/student_class_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/student_class_model.dart';
import 'package:absensi/features/auth/data/simple_token_service.dart';


class StudentClassService {
  static const String baseUrl = 'http://10.5.48.67:3000/api';

  // Fungsi untuk mendapatkan kelas siswa berdasarkan ID
  static Future<List<StudentClassModel>> getStudentClasses() async {
    try {
      final token = SimpleTokenService.getToken();
      final userId = SimpleTokenService.getUserId();

      if (token == null || userId == null) {
        throw Exception('Token atau User ID tidak ditemukan');
      }

      final response = await http.get(
        Uri.parse('$baseUrl/kelas/siswa/$userId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final decodedResponse = json.decode(response.body);
        
        // Jika response berupa array
        if (decodedResponse is List) {
          return decodedResponse
              .map((json) => StudentClassModel.fromJson(json))
              .toList();
        }
        // Jika response berupa single object
        else if (decodedResponse is Map<String, dynamic>) {
          return [StudentClassModel.fromJson(decodedResponse)];
        }
        else {
          throw Exception('Format response tidak valid');
        }
      } else if (response.statusCode == 401) {
        throw Exception('Token tidak valid atau expired');
      } else {
        throw Exception('Gagal mengambil data kelas: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Fungsi untuk mendapatkan detail kelas berdasarkan ID kelas
  static Future<StudentClassModel> getClassDetail(int classId) async {
    try {
      final token = SimpleTokenService.getToken();
      final userId = SimpleTokenService.getUserId();

      if (token == null || userId == null) {
        throw Exception('Token atau User ID tidak ditemukan');
      }

      final response = await http.get(
        Uri.parse('$baseUrl/kelas/siswa/$userId/$classId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final decodedResponse = json.decode(response.body);
        return StudentClassModel.fromJson(decodedResponse);
      } else if (response.statusCode == 401) {
        throw Exception('Token tidak valid atau expired');
      } else {
        throw Exception('Gagal mengambil detail kelas: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}