// lib/helpers/db_helper.dart (Implementasi SQFLITE)

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/report_model.dart';

class DBHelper {
  // Instance database SQFlite yang akan dipertahankan
  static Database? _database;
  static const String _databaseName = 'ecopatrol.db';
  static const int _databaseVersion = 1;

  // Getter yang memastikan database sudah terbuka sebelum digunakan
  Future<Database> get database async {
    // Jika instance sudah ada, langsung kembalikan
    if (_database != null) return _database!;
    
    // Jika belum ada, inisialisasi dan simpan instance
    _database = await _initDatabase();
    return _database!;
  }

  // --- INISIALISASI DATABASE (Tugas Mahasiswa 1: DB Init) ---
  Future<Database> _initDatabase() async {
    // 1. Dapatkan lokasi direktori untuk menyimpan database
    String path = join(await getDatabasesPath(), _databaseName);
    
    // 2. Buka database (atau buat jika belum ada)
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate, // Panggil _onCreate saat database baru dibuat
    );
  }

  // Fungsi yang dipanggil saat database pertama kali dibuat
  Future _onCreate(Database db, int version) async {
    // Perintah SQL untuk membuat tabel 'reports' (menggunakan ReportModel.tableName)
    await db.execute('''
      CREATE TABLE ${ReportModel.tableName} (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT,
      description TEXT,
      imagePath TEXT,
      latitude REAL,
      longitude REAL,
      status TEXT
      )
    ''');
    print("SQFlite: Tabel '${ReportModel.tableName}' berhasil dibuat.");
  }

  // --- FUNGSI DASAR OPERASI DATABASE ---

  // Menyimpan Laporan (Tugas Mahasiswa 2: Create)
  Future<int> insertReport(ReportModel report) async {
    final db = await database;
    return await db.insert(
      ReportModel.tableName,
      report.toMap(),
      // Mengatasi konflik jika ID sudah ada (misal, update laporan)
      conflictAlgorithm: ConflictAlgorithm.replace, 
    );
  }

  // Mengambil semua Laporan (Tugas Mahasiswa 3: Read)
  Future<List<ReportModel>> getReports() async {
    final db = await database;
    // Query semua data dari tabel 'reports'
    final List<Map<String, dynamic>> maps = await db.query(ReportModel.tableName);
    
    // Konversi List<Map> yang didapat dari database menjadi List<ReportModel>
    return List.generate(maps.length, (i) {
      return ReportModel.fromMap(maps[i]);
    });
  }
}

// Provider untuk mengakses DBHelper di seluruh aplikasi
final dbHelperProvider = Provider((ref) => DBHelper());