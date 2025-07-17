import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:absensi/common/constants/api_constants.dart';
import 'package:absensi/common/models/teacher_model.dart'; // Import model Teacher
import 'package:absensi/features/auth/data/simple_token_service.dart'; // Import SimpleTokenService

class TeacherService {
  Future<List<Teacher>> getTeachers() async {
    final token = SimpleTokenService.getToken();
    if (token == null) {
      throw Exception('Token tidak ditemukan, silakan login kembali.');
    }

    final response = await http.get(
      Uri.parse('${ApiConstants.baseUrl}/guru'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> teachersJson = jsonDecode(response.body);
      return teachersJson.map((json) => Teacher.fromJson(json)).toList();
    } else {
      throw Exception(
          'Gagal memuat data guru: ${response.statusCode} ${response.body}');
    }
  }

  // Metode untuk menambahkan guru baru
    Future<void> addTeacher(Teacher teacher) async {
      final token = SimpleTokenService.getToken();
      if (token == null) {
       throw Exception('Token tidak ditemukan, silakan login kembali.');
      }
      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}/guru'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
       },
       body: jsonEncode(teacher.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Berhasil menambahkan guru, tidak perlu mengembalikan apa pun
        return;
      } else {
        // Gagal menambahkan guru, lempar exception dengan pesan error
        throw Exception(
            'Gagal menambahkan guru: ${response.statusCode} - ${response.body}');
      }
    }

    // Tambahkan metode updateTeacher
    Future<void> updateTeacher(Teacher teacher) async {
      final token = SimpleTokenService.getToken();
      if (token == null) {
        throw Exception('Token tidak ditemukan, silakan login kembali.');
      }
      final response = await http.put(
        Uri.parse('${ApiConstants.baseUrl}/guru/${teacher.id}'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(teacher.toJson()),
      );
      // Cek apakah response berhasil
      if (response.statusCode == 200) {
        // Berhasil memperbarui guru, tidak perlu mengembalikan apa pun
        return;
      } else {
        throw Exception(
           'Gagal memperbarui guru: ${response.statusCode} ${response.body}');
      }
    }

    // Metode untuk menghapus guru
    Future<void> deleteTeacher(String id) async {
      final token = SimpleTokenService.getToken();
      if (token == null) {
       throw Exception('Token tidak ditemukan, silakan login kembali.');
      }
      final response = await http.delete(
        Uri.parse('${ApiConstants.baseUrl}/guru/$id'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode != 200) {
       throw Exception(
            'Gagal menghapus guru: ${response.statusCode} ${response.body}');
      }
    }
}