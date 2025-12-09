import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import '../models/report_model.dart';
import '../providers/report_provider.dart';

// Halaman untuk menambah laporan baru
// Mahasiswa 2 fokus di: Form input + Kamera + GPS + Insert Database

class AddReportScreen extends ConsumerStatefulWidget {
  const AddReportScreen({super.key});

  @override
  ConsumerState<AddReportScreen> createState() => _AddReportScreenState();
}

class _AddReportScreenState extends ConsumerState<AddReportScreen> {
  // Controller untuk input form
  final titleCtrl = TextEditingController();
  final descCtrl = TextEditingController();

  // Tempat menyimpan file foto
  File? imageFile;

  // Variabel menyimpan koordinat GPS
  double? lat;
  double? long;

  // ----------------------------
  // FUNGSI AMBIL FOTO
  // ----------------------------
  Future<void> pickImage(bool isCamera) async {
    final picker = ImagePicker();

    // Pilih sumber foto: kamera atau galeri
    final XFile? result = await picker.pickImage(
      source: isCamera ? ImageSource.camera : ImageSource.gallery,
    );

    // Jika user mengambil foto
    if (result != null) {
      setState(() {
        imageFile = File(result.path); // Simpan path foto
      });
    }
  }

  // ----------------------------
  // FUNGSI AMBIL LOKASI GPS
  // ----------------------------
  Future<void> getLocation() async {
    // Minta izin akses lokasi
    LocationPermission permission = await Geolocator.requestPermission();

    // Jika izin ditolak → tidak bisa ambil lokasi
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return;
    }

    // Ambil posisi user
    Position pos = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    // Simpan koordinat ke variabel
    setState(() {
      lat = pos.latitude;
      long = pos.longitude;
    });
  }

  // fungsi submit atau simpan laporan
  Future<void> submitReport() async {
    // Validasi semua input harus lengkap
    if (titleCtrl.text.isEmpty ||
        descCtrl.text.isEmpty ||
        imageFile == null ||
        lat == null ||
        long == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Lengkapi semua data!")),
      );
      return;
    }

    // Membuat object laporan
    final report = ReportModel(
      title: titleCtrl.text,
      description: descCtrl.text,
      imagePath: imageFile!.path,
      latitude: lat!,
      longitude: long!,
    );

    // Kirim ke provider untuk disimpan
    await ref.read(reportProvider.notifier).addReport(report);

    // Beri notifikasi
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Laporan berhasil disimpan!")),
    );

    // Kembali ke halaman sebelumnya
    Navigator.pop(context);
  }

  // menambah halaman laporan
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tambah Laporan")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: titleCtrl,
              decoration: const InputDecoration(labelText: "Judul Laporan"),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: descCtrl,
              maxLines: 4,
              decoration: const InputDecoration(labelText: "Deskripsi"),
            ),
            const SizedBox(height: 20),
            Text("Bukti Foto:", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),

            // Jika belum ada foto → tampil kotak abu-abu
            imageFile == null
                ? Container(
                    height: 150,
                    color: Colors.grey[300],
                    child: const Center(child: Text("Belum ada foto")),
                  )
                : Image.file(imageFile!, height: 150),

            Row(
              children: [
                ElevatedButton(
                  onPressed: () => pickImage(true),
                  child: const Text("Kamera"),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () => pickImage(false),
                  child: const Text("Galeri"),
                ),
              ],
            ),

            const SizedBox(height: 20),
            Text("Lokasi:", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),

            // Jika belum ditandai → tampil teks default
            lat == null
                ? const Text("Belum ditandai")
                : Text("Lat: $lat, Long: $long"),

            ElevatedButton(
              onPressed: getLocation,
              child: const Text("Tag Lokasi Terkini"),
            ),

            const SizedBox(height: 25),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: submitReport,
                child: const Text("Simpan Laporan"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
