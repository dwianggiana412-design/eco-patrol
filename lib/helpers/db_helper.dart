import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/report_model.dart';

class DBHelper {
  static Database? _database;
  static const String _databaseName = 'ecopatrol.db';
  static const int _databaseVersion = 1;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  // PERBAIKAN KRITIS: Sinkronisasi nama kolom database dengan ReportModel.toMap()
  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE ${ReportModel.tableName} (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        description TEXT,
        imagePath TEXT,             // Kolom untuk foto laporan awal
        latitude REAL,
        longitude REAL,
        status TEXT,
        officerDescription TEXT,    // Kolom baru untuk deskripsi petugas
        resultImagePath TEXT        // Kolom baru untuk foto hasil pengerjaan
      )
    ''');
    print("SQFlite: Tabel '${ReportModel.tableName}' berhasil dibuat dengan skema lengkap.");
  }

  // Insert report
  Future<int> insertReport(ReportModel report) async {
    final db = await database;
    return await db.insert(
      ReportModel.tableName,
      report.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Get all reports
  Future<List<ReportModel>> getReports() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(ReportModel.tableName);
    // Logika dari ReportModel.fromMap yang baru sekarang bisa membaca semua kolom
    return List.generate(maps.length, (i) {
      return ReportModel.fromMap(maps[i]);
    });
  }

  // Update report
  Future<int> updateReport(ReportModel report) async {
    final db = await database;
    return await db.update(
      ReportModel.tableName,
      report.toMap(),
      where: 'id = ?',
      whereArgs: [report.id],
    );
  }

  // Delete report by id
  Future<int> deleteReport(int id) async {
    final db = await database;
    return await db.delete(
      ReportModel.tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}

final dbHelperProvider = Provider((ref) => DBHelper());