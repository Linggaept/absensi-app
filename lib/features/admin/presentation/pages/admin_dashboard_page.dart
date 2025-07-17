import 'package:flutter/material.dart';
import 'package:absensi/common/constants/app_colors.dart';
import 'package:absensi/features/admin/presentation/widgets/dashboard_card.dart';
import 'package:absensi/features/admin/presentation/pages/manage_teachers_page.dart';
import 'package:absensi/features/admin/presentation/pages/manage_students_page.dart';
import 'package:absensi/features/admin/presentation/pages/manage_class_page.dart';
import 'package:absensi/features/admin/presentation/pages/manage_subject_page.dart';
import 'package:absensi/features/auth/presentation/pages/login_page.dart';
import 'package:absensi/features/admin/presentation/pages/attendance_report_page.dart';
import 'package:absensi/features/auth/data/simple_token_service.dart';


class AdminDashboardPage extends StatelessWidget {
  const AdminDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Admin Dashboard',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        elevation: 1,
        shadowColor: Colors.black.withOpacity(0.1),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            tooltip: 'Logout',
            onPressed: () {
              SimpleTokenService.clearToken();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const LoginPage()),
                (route) => false,
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            DashboardCard(
              title: 'Kelola Guru',
              icon: Icons.person_search_outlined,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const ManageTeachersPage(),
                  ),
                );
              },
            ),
            DashboardCard(
              title: 'Kelola Siswa',
              icon: Icons.groups_outlined,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const ManageStudentsPage(),
                  ),
                );
              },
            ),
            DashboardCard(
              title: 'Kelola Kelas',
              icon: Icons.class_outlined,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const ManageClassPage(),
                  ),
                );
              },
            ),
            DashboardCard(
              title: 'Kelola Matkul',
              icon: Icons.book_outlined,
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const ManageSubjectPage(),
                ));
              },
            ),
            DashboardCard(
              title: 'Laporan Absensi',
              icon: Icons.bar_chart_outlined,
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => const AttendanceReportPage(),
                ));
              },
            ),
          ],
        ),
      ),
    );
  }
}
