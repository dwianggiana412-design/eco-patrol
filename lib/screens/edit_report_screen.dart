// edit_report_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/report_model.dart'; 
import '../providers/report_provider.dart';

// import image_picker atau camera package

class EditReportScreen extends ConsumerStatefulWidget {
  final ReportModel report;
  const EditReportScreen({super.key, required this.report});

  @override
  ConsumerState<EditReportScreen> createState() => _EditReportScreenState();
}

class _EditReportScreenState extends ConsumerState<EditReportScreen> {
  final _descController = TextEditingController();
  String? _pickedImagePath; // Path untuk foto hasil pengerjaan

  Future<void> _pickImage() async {
    // Implementasi ambil foto dari Kamera/Galeri (seperti Mhs 2)
    // Asumsi: Path foto disimpan di _pickedImagePath
    setState(() {
      _pickedImagePath = 'assets/result_photo.jpg'; // Path mock
    });
  }

  void _submitUpdate() {
    if (_descController.text.isEmpty || _pickedImagePath == null) {
      // Tampilkan error
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mohon isi deskripsi dan ambil foto hasil pengerjaan.')),
      );
      return;
    }

    // Buat model laporan baru dengan status 'Selesai'
    final updatedReport = widget.report.copyWith(
      status: 'Selesai',
      officerDescription: _descController.text,
      resultImagePath: _pickedImagePath,
    );

    // Panggil logika update di Riverpod
    ref.read(reportProvider.notifier).updateReport(updatedReport);

    // Kembali ke Detail atau Dashboard
    Navigator.of(context).pop(); // Kembali dari Edit
    Navigator.of(context).pop(); // Kembali dari Detail ke Dashboard
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tandai Selesai')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 1. Input Deskripsi Laporan Pekerjaan
            TextField(
              controller: _descController,
              decoration: const InputDecoration(
                labelText: 'Deskripsi Pekerjaan',
                border: OutlineInputBorder(),
              ),
              maxLines: 4,
            ),
            const SizedBox(height: 24),

            // 2. Integrasi Kamera untuk Bukti Hasil
            ElevatedButton.icon(
              onPressed: _pickImage,
              icon: const Icon(Icons.camera_alt),
              label: const Text('Ambil Foto Hasil Pengerjaan'),
            ),
            
            // Preview Foto
            if (_pickedImagePath != null) ...[
              const SizedBox(height: 16),
              Image.asset(_pickedImagePath!, height: 150),
              const Text('Foto Hasil Tersedia')
            ] else if (_pickedImagePath == null) ...[
              const SizedBox(height: 16),
              const Text('Foto hasil pengerjaan belum diambil.')
            ],

            const Spacer(),
            
            // 3. Tombol Simpan
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submitUpdate,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                child: const Text('SIMPAN & TANDAI SELESAI'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}