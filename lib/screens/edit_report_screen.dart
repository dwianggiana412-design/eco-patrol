import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../models/report_model.dart';
import '../providers/report_provider.dart';

class EditReportScreen extends ConsumerStatefulWidget {
  final ReportModel report;
  const EditReportScreen({super.key, required this.report});

  @override
  ConsumerState<EditReportScreen> createState() => _EditReportScreenState();
}

class _EditReportScreenState extends ConsumerState<EditReportScreen> {
  final _descController = TextEditingController();
  String? _pickedImagePath;

  @override
  void initState() {
    super.initState();
    _descController.text = widget.report.officerDescription ?? '';
    _pickedImagePath = widget.report.resultImagePath;
  }

  @override
  void dispose() {
    _descController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera, imageQuality: 75);

    if (pickedFile != null) {
      setState(() {
        _pickedImagePath = pickedFile.path;
      });
    }
  }

  void _submitUpdate() {
    if (_descController.text.isEmpty || _pickedImagePath == null) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mohon isi deskripsi dan ambil foto hasil pengerjaan.')),
      );
      return;
    }

    final updatedReport = widget.report.copyWith(
      status: 'Selesai',
      officerDescription: _descController.text,
      resultImagePath: _pickedImagePath,
    );

    ref.read(reportProvider.notifier).updateReport(updatedReport);

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tandai Selesai'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Deskripsi Pekerjaan',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 8),

            // Text Field
            TextField(
              controller: _descController,
              decoration: const InputDecoration(
                hintText: 'Tuliskan hasil pekerjaan petugas...',
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
              maxLines: 5,
              minLines: 4,
            ),
            const SizedBox(height: 32),

            // Tombol Ambil Foto
            ElevatedButton.icon(
              onPressed: _pickImage,
              icon: const Icon(Icons.camera_alt),
              label: const Text('Ambil Foto Hasil Pengerjaan'),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onPrimary,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),

            const SizedBox(height: 24),

            // Preview Gambar
            _buildImagePreview(context),

            const SizedBox(height: 40),

            // Tombol Simpan
            ElevatedButton(
              onPressed: _submitUpdate,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Colors.green.shade600,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text(
                'SIMPAN & TANDAI SELESAI',
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePreview(BuildContext context) {
    if (_pickedImagePath != null && File(_pickedImagePath!).existsSync()) {
      return Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.file(
              File(_pickedImagePath!),
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Foto Hasil Tersedia',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.green),
          )
        ],
      );
    } else if (_pickedImagePath != null) {
      return const Text(
        'Foto tidak ditemukan di path yang tersimpan. Coba ambil ulang.',
        style: TextStyle(color: Colors.red),
        textAlign: TextAlign.center,
      );
    } else {
      return const Center(
        child: Text(
          'Foto hasil pengerjaan belum diambil.',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }
  }
}