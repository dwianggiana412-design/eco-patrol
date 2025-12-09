import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/report_provider.dart';
import '../models/report_model.dart';
import 'add_report_screen.dart'; 
// Import SettingsScreen
import 'settings_screen.dart'; 

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  // Fungsi navigasi ke SettingsScreen
  void _navigateToSettings(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const SettingsScreen()),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reports = ref.watch(reportProvider);
    final totalReports = reports.length;
    final completedReports =
        reports.where((r) => r.status.toLowerCase() == "selesai").length;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard Laporan"),
        centerTitle: true,
        actions: [
          // TOMBOL NAVIGASI KE SETTINGS
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => _navigateToSettings(context),
            tooltip: 'Pengaturan',
          ),
        ],
      ),
      body: Column(
        children: [
          // RINGKASAN LAPORAN
          _buildSummaryCard(totalReports, completedReports, context),

          // LIST LAPORAN
          Expanded(
            child: reports.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 50), 
                        Text(
                          "Belum ada laporan yang tercatat.",
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: reports.length,
                    itemBuilder: (context, index) {
                      final report = reports[index];
                      return _buildReportItem(context, report);
                    },
                  ),
          ),
        ],
      ),
      // Tombol Tambah navigasi ke AddReportScreen
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const AddReportScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  // WIDGET CARD RINGKASAN
  Widget _buildSummaryCard(int total, int completed, BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(12),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _summaryItem(
              icon: Icons.assignment,
              label: "Total Laporan",
              value: total,
              color: Colors.blue.shade700,
            ),
            Container(width: 1, height: 40, color: Colors.grey.shade300),
            _summaryItem(
              icon: Icons.check_circle_outline,
              label: "Laporan Selesai",
              value: completed,
              color: Colors.green.shade700,
            ),
          ],
        ),
      ),
    );
  }

  Widget _summaryItem({required IconData icon, required String label, required int value, required Color color}) {
    return Column(
      children: [
        Row(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(width: 8),
            Text(
              value.toString(),
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w900,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 14, color: Colors.grey),
        ),
      ],
    );
  }

  // WIDGET ITEM LAPORAN (CARD LISTVIEW)
  Widget _buildReportItem(BuildContext context, ReportModel report) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      elevation: 2,
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: SizedBox(
            width: 52,
            height: 52,
            child: Image.file(
              File(report.imagePath),
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey.shade200,
                  child: const Icon(Icons.image_not_supported, color: Colors.grey),
                );
              },
            ),
          ),
        ),

        title: Text(
          report.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),

        subtitle: Text(
          report.description,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 13, color: Colors.grey),
        ),

        trailing: _buildStatusBadge(report.status),

        onTap: () {
          // Navigate ke Detail Laporan
        },
      ),
    );
  }

  // BADGE STATUS
  Widget _buildStatusBadge(String status) {
    final statusLower = status.toLowerCase();
    
    Color bgColor;
    String text;

    if (statusLower == "selesai") {
      bgColor = Colors.green.shade600;
      text = "Selesai";
    } else if (statusLower == "pending") {
      bgColor = Colors.red.shade600;
      text = "Pending";
    } else {
      bgColor = Colors.amber.shade600;
      text = status;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
      ),
    );
  }
}