class ReportModel {
  static const String tableName = 'reports'; 

  final String id; 
  final String description; 
  final double latitude; 
  final double longitude;
  final String photoPath;
  final String status;  

  ReportModel({
    required this.id,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.photoPath,
    this.status = 'Pending', 
  });

  // Metode untuk konversi dari Map (dari hasil db.query)
  factory ReportModel.fromMap(Map<String, dynamic> map) {
    return ReportModel(
      id: map['id'] as String,
      description: map['description'] as String,
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