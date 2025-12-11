// lib/models/report_model.dart

class ReportModel {
  static const String tableName = 'reports';

  final int? id;
  final String title;
  final String description;
  final String imagePath;
  final double latitude;
  final double longitude;
  final String status;
  
  // Field untuk Tugas Mhs 4 (Penyelesaian Laporan) 
  final String? officerDescription; // Deskripsi pekerjaan yang dilakukan petugas 
  final String? resultImagePath; // Foto hasil pengerjaan (setelah selesai) 

  ReportModel({
    this.id,
    required this.title,
    required this.description,
    required this.imagePath,
    required this.latitude,
    required this.longitude,
    this.status = 'Pending',
    this.officerDescription,
    this.resultImagePath,
  });

  // Konstruktor dari Map (Untuk Read dari Database)
  factory ReportModel.fromMap(Map<String, dynamic> map) {
    // Pengamanan untuk memastikan konversi toDouble() aman
    final latValue = map['latitude'];
    final longValue = map['longitude'];

    return ReportModel(
      id: map['id'] as int?,
      title: map['title'] as String,
      description: map['description'] as String,
      imagePath: map['imagePath'] as String,
      latitude: latValue is double ? latValue : (latValue as num).toDouble(),
      longitude: longValue is double ? longValue : (longValue as num).toDouble(),
      status: map['status'] as String? ?? 'Pending',
      officerDescription: map['officerDescription'] as String?, 
      resultImagePath: map['resultImagePath'] as String?,
    );
  }

  // Konversi ke Map (Untuk Insert/Update ke Database)
  Map<String, dynamic> toMap() {
    return {
      // ID tidak diperlukan saat INSERT, tapi penting saat UPDATE
      'id': id, 
      'title': title,
      'description': description,
      'imagePath': imagePath,
      'latitude': latitude,
      'longitude': longitude,
      'status': status,
      'officerDescription': officerDescription,
      'resultImagePath': resultImagePath,
    };
  }

  // Metode copyWith untuk mempermudah update data
  ReportModel copyWith({
    int? id,
    String? status,
    String? title,
    String? description,
    String? imagePath,
    double? latitude,
    double? longitude,
    String? officerDescription,
    String? resultImagePath,
  }) {
    return ReportModel(
      id: id ?? this.id, // ID dapat dipertahankan atau diubah jika diberikan
      title: title ?? this.title,
      description: description ?? this.description,
      imagePath: imagePath ?? this.imagePath,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      status: status ?? this.status,
      officerDescription: officerDescription ?? this.officerDescription,
      resultImagePath: resultImagePath ?? this.resultImagePath,
    );
  }
}