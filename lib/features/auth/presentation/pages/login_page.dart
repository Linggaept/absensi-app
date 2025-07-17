import 'package:flutter/material.dart';
import 'package:absensi/common/constants/app_colors.dart';
import 'package:absensi/common/constants/app_text_styles.dart';
import 'package:absensi/features/auth/data/auth_service.dart';
import 'package:absensi/features/auth/data/simple_token_service.dart';
import 'package:absensi/features/admin/presentation/pages/admin_dashboard_page.dart';
import 'package:absensi/features/teacher/presentation/pages/teacher_dashboard_page.dart';
import 'package:absensi/features/student/presentation/pages/student_dashboard_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _nipNisController = TextEditingController();
  final _passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  bool _isLoading = false;

  @override
  void dispose() {
    _nipNisController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final authResponse = await _authService.login(
        _nipNisController.text,
        _passwordController.text,
      );

      if (mounted) {
        // Simpan token dan role untuk session management
        SimpleTokenService.saveToken(authResponse.token, authResponse.role, authResponse.id);
        
        // Redirect berdasarkan role
        Widget targetPage;
        switch (authResponse.role) {
          case 'admin':
            targetPage = const AdminDashboardPage();
            break;
          case 'guru':
            targetPage = const TeacherDashboardPage();
            break;
          case 'siswa':
            targetPage = const StudentDashboardPage();
            break;
          default:
            throw Exception('Role tidak dikenal: ${authResponse.role}');
        }

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => targetPage),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceAll('Exception: ', '')),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 32.0,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      const Icon(
                        Icons.school_outlined,
                        size: 80,
                        color: AppColors.primary,
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Selamat Datang!',
                        style: AppTextStyles.heading,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Silakan masuk untuk melanjutkan',
                        style: AppTextStyles.subheading,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 48),
                      TextFormField(
                        key: const ValueKey('nip_nis_field'),
                        controller: _nipNisController,
                        decoration: const InputDecoration(
                          hintText: 'NIP/NIS',
                        ),
                        validator: (value) => (value?.isEmpty ?? true)
                            ? 'NIP/NIS tidak boleh kosong'
                            : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        key: const ValueKey('password_field'),
                        controller: _passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(hintText: 'Password'),
                        validator: (value) => (value?.isEmpty ?? true)
                            ? 'Password tidak boleh kosong'
                            : null,
                      ),
                      const SizedBox(height: 32),
                      ElevatedButton(
                        onPressed: _isLoading ? null : _login,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                            : const Text('Login'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              ),
            ),
        ],
      ),
    );
  }
}