import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:absensi/features/auth/data/simple_token_service.dart';
import 'package:absensi/features/teacher/models/class_teacher_model.dart';

class ClassTeacherService {
  static const String baseUrl = 'http://10.5.48.67:3000/api';
  
  // Method untuk mendapatkan daftar kelas berdasarkan guru_id
  static Future<List<ClassTeacherModel>> getClassesByTeacherId(int guruId) async {
    try {
      // Cek apakah token tersedia
      final token = SimpleTokenService.getToken();
      if (token == null || token.isEmpty) {
        throw Exception('Token tidak tersedia. Silakan login terlebih dahulu.');
      }

      // Buat request ke API
      final url = Uri.parse('$baseUrl/kelas/guru/$guruId');
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      // Handle response berdasarkan status code
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        
        // Convert JSON array ke List<ClassTeacherModel>
        final List<ClassTeacherModel> classes = jsonData
            .map((item) => ClassTeacherModel.fromJson(item))
            .toList();
        
        return classes;
      } else if (response.statusCode == 401) {
        // Token expired atau tidak valid
        SimpleTokenService.clearToken();
        throw Exception('Token tidak valid atau telah kedaluwarsa. Silakan login kembali.');
      } else if (response.statusCode == 404) {
        // Tidak ada kelas yang ditemukan untuk guru ini
        return [];
      } else {
        // Error lainnya
        throw Exception('Gagal mengambil data kelas. Status: ${response.statusCode}');
      }
    } on SocketException {
      throw Exception('Tidak dapat terhubung ke server. Periksa koneksi internet Anda.');
    } on FormatException {
      throw Exception('Format data dari server tidak valid.');
    } catch (e) {
      throw Exception('Terjadi kesalahan: ${e.toString()}');
    }
  }

  // Method untuk mendapatkan detail kelas berdasarkan ID
  static Future<ClassTeacherModel?> getClassById(int classId) async {
    try {
      final token = SimpleTokenService.getToken();
      if (token == null || token.isEmpty) {
        throw Exception('Token tidak tersedia. Silakan login terlebih dahulu.');
      }

      final url = Uri.parse('$baseUrl/kelas/$classId');
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        return ClassTeacherModel.fromJson(jsonData);
      } else if (response.statusCode == 401) {
        SimpleTokenService.clearToken();
        throw Exception('Token tidak valid atau telah kedaluwarsa. Silakan login kembali.');
      } else if (response.statusCode == 404) {
        return null;
      } else {
        throw Exception('Gagal mengambil detail kelas. Status: ${response.statusCode}');
      }
    } on SocketException {
      throw Exception('Tidak dapat terhubung ke server. Periksa koneksi internet Anda.');
    } on FormatException {
      throw Exception('Format data dari server tidak valid.');
    } catch (e) {
      throw Exception('Terjadi kesalahan: ${e.toString()}');
    }
  }

  // Method untuk refresh data kelas
  static Future<List<ClassTeacherModel>> refreshClasses(int guruId) async {
    return await getClassesByTeacherId(guruId);
  }

  // Method untuk validasi koneksi ke server
  static Future<bool> checkConnection() async {
    try {
      final url = Uri.parse('$baseUrl/health'); // Endpoint health check
      final response = await http.get(url).timeout(
        const Duration(seconds: 5),
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}