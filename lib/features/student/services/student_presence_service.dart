import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:absensi/features/auth/data/simple_token_service.dart';
import 'package:absensi/features/student/models/student_presence_model.dart';

class StudentPresenceService {
  static const String baseUrl = 'http://10.5.48.67:3000';

  static Map<String, String> _getHeaders() {
    final token = SimpleTokenService.getToken();
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  /// Melakukan presensi dengan mengirimkan kode presensi.
  static Future<StudentSubmitPresenceModel> submitPresence({
    required int kelasId,
    required String kodePresensi,
  }) async {
    final siswaId = SimpleTokenService.getUserId();
    if (siswaId == null) {
      throw Exception('User tidak terautentikasi. Silakan login kembali.');
    }

    final url = Uri.parse('$baseUrl/api/presensi-siswa/presensi/$siswaId');

    try {
      final response = await http.post(
        url,
        headers: _getHeaders(),
        body: json.encode({
          'kelas_id': kelasId,
          'kode_presensi': kodePresensi,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonData = json.decode(response.body);
        return StudentSubmitPresenceModel.fromJson(jsonData);
      } else {
        final errorData = json.decode(response.body);
        final errorMessage =
            errorData['message'] as String? ?? 'Gagal melakukan presensi';
        throw Exception(errorMessage);
      }
    } catch (e) {
      rethrow;
    }
  }
}