import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/report_model.dart';
import '../providers/report_provider.dart';
import '../screens/edit_report_screen.dart';

class DetailReportScreen extends ConsumerWidget {
  final ReportModel report;

  const DetailReportScreen({super.key, required this.report});

  // Fungsi untuk membuka tampilan full screen
  void _openFullScreenImage(BuildContext context, String imagePath) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => _FullScreenImageViewer(imagePath: imagePath),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reports = ref.watch(reportProvider);
    final currentReport = reports.firstWhere(
      (r) => r.id == report.id,
      orElse: () => report,
    );

    Color getStatusColor(String status) {
      switch (status) {
        case 'Pending':
          return Colors.red.shade700;
        case 'Selesai':
          return Colors.green.shade700;
        default:
          return Colors.grey.shade700;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(currentReport.title),
        elevation: 1,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Status Card
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    Icon(
                      currentReport.status == 'Selesai' ? Icons.check_circle : Icons.watch_later,
                      color: getStatusColor(currentReport.status),
                      size: 30,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Status: ${currentReport.status}',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: getStatusColor(currentReport.status),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Bukti Laporan (Awal)
            _buildSectionTitle(context, 'Bukti Laporan Awal', Icons.image),
            GestureDetector(
              onTap: () => _openFullScreenImage(context, currentReport.imagePath),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.file(
                  File(currentReport.imagePath),
                  height: 250,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Detail Laporan
            _buildSectionTitle(context, 'Detail Informasi', Icons.info),
            Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.description, color: Colors.blueGrey),
                      title: Text(currentReport.description),
                      subtitle: const Text('Deskripsi'),
                      isThreeLine: true,
                    ),
                    ListTile(
                      leading: const Icon(Icons.location_on, color: Colors.teal),
                      title: Text('Lat ${currentReport.latitude.toStringAsFixed(6)}, Long ${currentReport.longitude.toStringAsFixed(6)}'),
                      subtitle: const Text('Lokasi'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Hasil Pekerjaan (Jika Selesai)
            if (currentReport.status == 'Selesai') ...[
              _buildSectionTitle(context, 'Hasil Pekerjaan Petugas', Icons.work),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Deskripsi Pekerjaan:',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(currentReport.officerDescription ?? 'Tidak ada deskripsi tambahan.'),
                      if (currentReport.resultImagePath != null) ...[
                        const SizedBox(height: 16),
                        Text(
                          'Bukti Hasil:',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: () => _openFullScreenImage(context, currentReport.resultImagePath!),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.file(
                              File(currentReport.resultImagePath!),
                              height: 200,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],

            // Tombol Aksi
            if (currentReport.status == 'Pending')
              Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => EditReportScreen(report: currentReport),
                      ),
                    );
                  },
                  icon: const Icon(Icons.done_all),
                  label: const Text('Tandai Selesai & Tambah Bukti'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade600,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ),

            OutlinedButton.icon(
              onPressed: () => _confirmDelete(context, ref, currentReport),
              icon: const Icon(Icons.delete),
              label: const Text('Hapus Laporan'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red.shade600,
                side: BorderSide(color: Colors.red.shade600),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 8),
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
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

// Widget Pribadi untuk Tampilan Gambar Full Screen dengan Zoom
class _FullScreenImageViewer extends StatelessWidget {
  final String imagePath;

  const _FullScreenImageViewer({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: Center(
        child: InteractiveViewer(
          panEnabled: true,
          minScale: 0.5,
          maxScale: 4.0,
          scaleEnabled: true,
          child: Image.file(
            File(imagePath),
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}