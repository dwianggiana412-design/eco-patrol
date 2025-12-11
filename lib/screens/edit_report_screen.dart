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
    final pickedFile = await picker.pickImage(source: ImageSource.camera); 

    if (pickedFile != null) {
      setState(() {
        _pickedImagePath = pickedFile.path;
      });
    }
  }

  void _submitUpdate() {
    if (_descController.text.isEmpty || _pickedImagePath == null) {
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
    return Scaffold(
      appBar: AppBar(title: const Text('Tandai Selesai')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _descController,
              decoration: const InputDecoration(
                labelText: 'Deskripsi Pekerjaan',
                border: OutlineInputBorder(),
              ),
              maxLines: 4,
            ),
            const SizedBox(height: 24),

            ElevatedButton.icon(
              onPressed: _pickImage,
              icon: const Icon(Icons.camera_alt),
              label: const Text('Ambil Foto Hasil Pengerjaan'),
            ),
            
            const SizedBox(height: 16),
            
            // Logika Preview Gambar (Menggunakan Image.file)
            if (_pickedImagePath != null && File(_pickedImagePath!).existsSync()) 
              Column(
                children: [
                  Image.file(
                    File(_pickedImagePath!), 
                    height: 200, 
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(height: 8),
                  const Text('Foto Hasil Tersedia')
                ],
              )
            else if (_pickedImagePath != null) 
              const Text('Foto tidak ditemukan di path yang tersimpan.')
            else 
              const Text('Foto hasil pengerjaan belum diambil.'),

            const SizedBox(height: 40),
            
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submitUpdate,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.green
                ),
                child: const Text(
                  'SIMPAN & TANDAI SELESAI',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}