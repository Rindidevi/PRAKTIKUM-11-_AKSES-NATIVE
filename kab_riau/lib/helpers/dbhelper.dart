import 'dart:async';
import 'package:kab_riau/models/kabupaten.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  static Future<Database> db() async {
    String path = await getDatabasesPath();
    final database = openDatabase(
      join(path, 'kabupaten.db'),
      onCreate: (database, version) async {
        await _createTable(database);
      },
      version: 1,
    );
    return database;
  }

  static Future<void> _createTable(Database db) async {
    await db.execute(
      '''
      CREATE TABLE kabupaten (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        logo TEXT,
        name TEXT,
        pusatPemerintahan TEXT,
        bupatiWalikota TEXT,
        luasWilayah REAL,
        jumlahPenduduk INTEGER,
        jumlahKecamatan INTEGER,
        jumlahKelurahan INTEGER,
        jumlahDesa INTEGER,
        link TEXT
      )
      ''',
    );
  }

  static Future<List<Kabupaten>> getKabupatenList() async {
    final Database db = await DbHelper.db();
    final List<Map<String, dynamic>> maps = await db.query('kabupaten', orderBy: 'name');
    return List.generate(maps.length, (i) {
      return Kabupaten.forMap(maps[i]);
    });
  }

  static Future<int> insert(Kabupaten kabupaten) async {
    final db = await DbHelper.db();
    int count = await db.insert(
      'kabupaten',
      kabupaten.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return count;
  }

  static Future<int> update(Kabupaten kabupaten) async {
    final db = await DbHelper.db();
    int count = await db.update(
      'kabupaten',
      kabupaten.toMap(),
      where: 'id=?',
      whereArgs: [kabupaten.id],
    );
    return count;
  }

  static Future<int> delete(int id) async {
    final db = await DbHelper.db();
    int count = await db.delete(
      'kabupaten',
      where: 'id=?',
      whereArgs: [id],
    );
    return count;
  }
}
