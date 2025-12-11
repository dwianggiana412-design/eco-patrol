import 'dart:io'; 
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/report_model.dart';
import '../providers/report_provider.dart';
import '../screens/edit_report_screen.dart';

class DetailReportScreen extends ConsumerWidget {
  final ReportModel report;

  const DetailReportScreen({super.key, required this.report});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. PERBAIKAN: Menggunakan reportProvider
    final reports = ref.watch(reportProvider); 
    final currentReport = reports.firstWhere(
      (r) => r.id == report.id,
      orElse: () => report,
    );

    return Scaffold(
      appBar: AppBar(title: Text(currentReport.title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Bukti Laporan (Awal)', style: Theme.of(context).textTheme.headlineSmall),
            // 2. PERBAIKAN: Menggunakan imagePath
            Image.file(File(currentReport.imagePath), height: 200),
            const SizedBox(height: 16),

            Text('Status: ${currentReport.status}', style: TextStyle(
              fontWeight: FontWeight.bold,
              color: currentReport.status == 'Pending' ? Colors.red : Colors.green,
            )),
            Text('Deskripsi: ${currentReport.description}'),
            Text('Lokasi: Lat ${currentReport.latitude}, Long ${currentReport.longitude}'),
            const SizedBox(height: 24),

            if (currentReport.status == 'Selesai') ...[
              const Divider(),
              Text('Hasil Pekerjaan Petugas', style: Theme.of(context).textTheme.headlineSmall),
              // 3. PERBAIKAN: Menggunakan officerDescription
              Text('Deskripsi Pekerjaan: ${currentReport.officerDescription ?? '-'}'), 
              // 4. PERBAIKAN: Menggunakan resultImagePath
              if (currentReport.resultImagePath != null) ...[
                const SizedBox(height: 8),
                // 5. PERBAIKAN: Menggunakan resultImagePath
                Image.file(File(currentReport.resultImagePath!), height: 200),
              ],
              const SizedBox(height: 24),
            ],

            if (currentReport.status == 'Pending')
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => EditReportScreen(report: currentReport),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                child: const Text('Tandai Selesai & Tambah Bukti'),
              ),

            const SizedBox(height: 16),

            OutlinedButton(
              onPressed: () => _confirmDelete(context, ref, currentReport),
              style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Hapus Laporan'),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, ReportModel report) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Konfirmasi Hapus'),
        content: const Text('Anda yakin ingin menghapus laporan ini? Tindakan ini tidak dapat dibatalkan.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              // 6. PERBAIKAN: Menggunakan reportProvider
              ref.read(reportProvider.notifier).deleteReport(report.id!); 
              Navigator.of(ctx).pop();
              Navigator.of(context).pop();
            },
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }
}