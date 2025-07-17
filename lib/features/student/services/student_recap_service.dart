import 'dart:convert';
import 'package:absensi/features/auth/data/simple_token_service.dart';
import 'package:absensi/features/student/models/student_recap_model.dart';
import 'package:http/http.dart' as http;

class StudentRecapService {
  static const String baseUrl = 'http://10.5.48.67:3000';

  static Map<String, String> _getHeaders() {
    final token = SimpleTokenService.getToken();
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  static Future<List<StudentRecapModel>> getRecap() async {
    final siswaId = SimpleTokenService.getUserId();
    if (siswaId == null) {
      throw Exception('User tidak terautentikasi. Silakan login kembali.');
    }

    final url = Uri.parse('$baseUrl/api/laporan/siswa/$siswaId/rekap');

    try {
      final response = await http.get(
        url,
        headers: _getHeaders(),
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = json.decode(response.body);
        
        List<StudentRecapModel> recapList = jsonResponse
            .map((item) => StudentRecapModel.fromJson(item))
            .toList();

        return recapList;
      } else {
        throw Exception('Gagal memuat rekap: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Terjadi kesalahan: $e');
    }
  }
}