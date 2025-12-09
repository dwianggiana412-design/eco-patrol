// lib/models/report_model.dart

// Tidak perlu impor database lokal (Hive/SQFlite) di file model
// karena kita hanya menggunakan tipe data dasar Dart.

class ReportModel {
  // Nama tabel (Konstanta yang digunakan di DBHelper)
  static const String tableName = 'reports'; 

  final String id; // ID unik laporan (PRIMARY KEY di SQFlite)
  final String description; // Deskripsi laporan dari user
  final double latitude; // Koordinat GPS (Latitude)
  final double longitude; // Koordinat GPS (Longitude)
  final String photoPath; // Path lokal file foto
  final String status; // Status laporan (e.g., 'Pending', 'Processed', 'Done')

  ReportModel({
    required this.id,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.photoPath,
    this.status = 'Pending', // Nilai default
  });

  // Metode untuk konversi dari Map (dari hasil db.query)
  factory ReportModel.fromMap(Map<String, dynamic> map) {
    // Catatan: Pastikan field yang dikembalikan dari DB adalah tipe yang tepat
    return ReportModel(
      id: map['id'] as String,
      description: map['description'] as String,
      // Karena latitude dan longitude disimpan sebagai REAL di SQFlite, 
      // kita harus memastikan konversinya ke double
      latitude: map['latitude'] is int 
          ? (map['latitude'] as int).toDouble() 
          : map['latitude'] as double,
      longitude: map['longitude'] is int 
          ? (map['longitude'] as int).toDouble() 
          : map['longitude'] as double,
      photoPath: map['photoPath'] as String,
      status: map['status'] as String,
    );
  }

  // Metode untuk konversi ke Map (untuk db.insert atau db.update)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'description': description,
      'latitude': latitude,
      'longitude': longitude,
      'photoPath': photoPath,
      'status': status,
    };
  }
}