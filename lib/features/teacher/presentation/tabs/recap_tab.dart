import 'package:absensi/features/teacher/models/recap_model.dart';
import 'package:absensi/features/teacher/services/recap_services.dart';
import 'package:flutter/material.dart';

class RecapTab extends StatefulWidget {
  const RecapTab({super.key});

  @override
  State<RecapTab> createState() => _RecapTabState();
}

class _RecapTabState extends State<RecapTab> {
  List<RecapModel> recaps = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    loadRecaps();
  }

  Future<void> loadRecaps() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });
      
      final fetchedRecaps = await RecapService.fetchRecaps();
      
      setState(() {
        recaps = fetchedRecaps;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red[300],
            ),
            const SizedBox(height: 16),
            Text(
              'Terjadi kesalahan:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.red[700],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              errorMessage!,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.red[600],
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: loadRecaps,
              child: const Text('Coba Lagi'),
            ),
          ],
        ),
      );
    }

    if (recaps.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 64,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              'Belum ada data rekapitulasi',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: loadRecaps,
      child: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: recaps.length,
        itemBuilder: (context, index) {
          final recap = recaps[index];
          final attendancePercentage = 
              (recap.presentCount / recap.totalMeetings * 100).round();
          
          return Card(
            margin: const EdgeInsets.only(bottom: 12.0),
            child: ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              title: Text(
                recap.studentName,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${recap.className} - ${recap.subjectName}'),
                  Text(
                    'NIS: ${recap.nis}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${recap.presentCount}/${recap.totalMeetings}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    'Kehadiran',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  Text(
                    '$attendancePercentage%',
                    style: TextStyle(
                      fontSize: 12,
                      color: attendancePercentage >= 80 
                          ? Colors.green 
                          : attendancePercentage >= 60 
                              ? Colors.orange 
                              : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}