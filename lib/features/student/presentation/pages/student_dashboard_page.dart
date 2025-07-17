import 'package:absensi/common/constants/app_colors.dart';
import 'package:absensi/features/auth/data/simple_token_service.dart';
import 'package:absensi/features/auth/presentation/pages/login_page.dart';
import 'package:absensi/features/student/presentation/tabs/student_class_tab.dart';
import 'package:absensi/features/student/presentation/tabs/student_recap_tab.dart';
import 'package:flutter/material.dart';

class StudentDashboardPage extends StatefulWidget {
  const StudentDashboardPage({super.key});

  @override
  State<StudentDashboardPage> createState() => _StudentDashboardPageState();
}

class _StudentDashboardPageState extends State<StudentDashboardPage> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    StudentClassTab(),
    const StudentRecapTab(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Cek apakah token sudah ada
    if (!SimpleTokenService.isLoggedIn()) {
      // Jika tidak ada token, arahkan ke halaman login
      return const LoginPage();
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text('Dashboard Siswa', style: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: AppColors.white),
            onPressed: () {
              // Hapus token dan role saat logout
              SimpleTokenService.clearToken();
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const LoginPage()));
            },
          ),
        ],
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: AppColors.primary,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.class_), label: 'Kelas'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Rekapitulasi'),
        ],
      ),
    );
  }
}