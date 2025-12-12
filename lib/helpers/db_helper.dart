import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/report_model.dart';

class DBHelper {
  static Database? _database;
  static const String _databaseName = 'ecopatrol.db';
  static const int _databaseVersion = 2; //versi database sekarang

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async { //menentukan jalur dan memanggil fungsi callback
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade, 
    );
  }

//dipanggil jika database blm prnh ada
  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE ${ReportModel.tableName} (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        description TEXT,
        imagePath TEXT,             
        latitude REAL,
        longitude REAL,
        status TEXT,
        officerDescription TEXT,    
        resultImagePath TEXT        
      )
    ''');
    print("SQFlite: Tabel '${ReportModel.tableName}' berhasil dibuat dengan skema lengkap (V$version).");
  }

  //Dijalankan saat database lama ditemukan dan versinya lebih rendah
  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    print("SQFlite: Melakukan upgrade dari V$oldVersion ke V$newVersion...");
    
    //dipanggil ktika pengguna menginstal versi baru
    if (oldVersion < 2) {
      await db.execute(
        'ALTER TABLE ${ReportModel.tableName} ADD COLUMN officerDescription TEXT',
      );
      await db.execute(
        'ALTER TABLE ${ReportModel.tableName} ADD COLUMN resultImagePath TEXT',
      );
      print("SQFlite: Kolom officerDescription dan resultImagePath berhasil ditambahkan.");
    }
  }

  // menyimpan laporan baru dari pengguna ke database
  Future<int> insertReport(ReportModel report) async {
    final db = await database;
    return await db.insert(
      ReportModel.tableName,
      report.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // mengambil laporan yag tersimpann
  Future<List<ReportModel>> getReports() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(ReportModel.tableName);
    return List.generate(maps.length, (i) {
      return ReportModel.fromMap(maps[i]);
    });
  }

  // memperbarui detail laporan yag sudah ada
  Future<int> updateReport(ReportModel report) async {
    final db = await database;
    return await db.update(
      ReportModel.tableName,
      report.toMap(),
      where: 'id = ?',
      whereArgs: [report.id],
    );
  }

  // menghapus laporan berdasarkan id
  Future<int> deleteReport(int id) async {
    final db = await database;
    return await db.delete(
      ReportModel.tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}

final dbHelperProvider = Provider((ref) => DBHelper()); //mendefinisikan sebagai provider