import 'package:absensi/common/constants/app_colors.dart';
import 'package:absensi/features/student/models/student_recap_model.dart';
import 'package:absensi/features/student/services/student_recap_service.dart';
import 'package:flutter/material.dart';

class StudentRecapTab extends StatefulWidget {
  const StudentRecapTab({super.key});

  @override
  State<StudentRecapTab> createState() => _StudentRecapTabState();
}

class _StudentRecapTabState extends State<StudentRecapTab> {
  List<StudentRecapModel> recaps = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRecaps();
  }

  Future<void> _loadRecaps() async {
    try {
      setState(() {
        isLoading = true;
      });
      
      final loadedRecaps = await StudentRecapService.getRecap();
      
      setState(() {
        recaps = loadedRecaps;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        // Jika error, gunakan data dummy atau kosong
        recaps = [];
      });
      
      // Tampilkan error message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memuat data: ${e.toString()}')),
        );
      }
    }
  }

  Color _getStatusColor(int presenceCount) {
    if (presenceCount > 0) {
      return Colors.green;
    } else {
      return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: recaps.length,
      itemBuilder: (context, index) {
        final recap = recaps[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12.0),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            title: Text('${recap.className} - ${recap.subjectName}', style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4.0),
                Text('Guru: ${recap.teacherName}'),
                Text('Waktu: ${recap.date}, ${recap.startTime} - ${recap.endTime}'),
              ],
            ),
            trailing: Chip(
              label: Text(recap.presenceCount.toString(), style: const TextStyle(color: AppColors.white)), 
              backgroundColor: _getStatusColor(recap.presenceCount)
            ),
          ),
        );
      },
    );
  }
}