class ReportModel {
  static const String tableName = 'reports';

  final int? id;               
  final String title;           
  final String description;     
  final String imagePath;       
  final double latitude;        
  final double longitude;       
  final String status;          

  ReportModel({
    this.id,                    
    required this.title,
    required this.description,
    required this.imagePath,
    required this.latitude,
    required this.longitude,
    this.status = 'Pending',
  });

  factory ReportModel.fromMap(Map<String, dynamic> map) {
    return ReportModel(
      id: map['id'],                                  
      title: map['title'],
      description: map['description'],
      imagePath: map['imagePath'],
      latitude: map['latitude'].toDouble(),
      longitude: map['longitude'].toDouble(),
      status: map['status'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'imagePath': imagePath,
      'latitude': latitude,
      'longitude': longitude,
      'status': status,
    };
  }
}
