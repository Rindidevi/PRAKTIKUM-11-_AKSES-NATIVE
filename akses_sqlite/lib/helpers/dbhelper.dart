import 'dart:async';
import 'package:akses_sqlite/models/contact.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

// Kelas helper untuk mengelola operasi database
class DbHelper {
  // Metode untuk mengembalikan instance database
  static Future<Database> db() async {
    // Mendapatkan path direktori database
    String path = await getDatabasesPath();
    // Membuka atau membuat database dengan nama 'contact.db'
    final database = openDatabase(
      join(path, 'contact.db'),
      // Memanggil _createTable saat database dibuat pertama kali
      onCreate: (database, version) async {
        await _createTable(database);
      },
      version: 1,
    );
    return database;
  }

  // Metode untuk membuat tabel contact di database
  static Future<void> _createTable(Database db) async {
    await db.execute(
      '''
      CREATE TABLE contact (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        phone TEXT
      )
      ''',
    );
  }

  // Metode untuk mendapatkan daftar kontak dari tabel contact
  static Future<List<Contact>> getContactList() async {
    // Mendapatkan instance database
    final Database db = await DbHelper.db();
    // Melakukan query untuk mendapatkan semua baris dari tabel contact,
    // diurutkan berdasarkan kolom name
    final List<Map<String, dynamic>> maps =
        await db.query('contact', orderBy: 'name');
    // Mengonversi hasil query (List<Map<String, dynamic>>) ke List<Contact>
    return List.generate(maps.length, (i) {
      return Contact.forMap(maps[i]);
    });
  }

  // Metode untuk menyisipkan objek Contact ke tabel contact
  static Future<int> insert(Contact contact) async {
    // Mendapatkan instance database
    final db = await DbHelper.db();
    // Menyisipkan contact ke tabel contact, dengan mengganti jika ada konflik
    int count = await db.insert(
      'contact',
      contact.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return count;
  }

  // Metode untuk memperbarui objek Contact di tabel contact
  static Future<int> update(Contact contact) async {
    // Mendapatkan instance database
    final db = await DbHelper.db();
    // Memperbarui contact yang memiliki id yang sama dengan contact yang diberikan
    int count = await db.update(
      'contact',
      contact.toMap(),
      where: 'id=?',
      whereArgs: [contact.id],
    );
    return count;
  }

  // Metode untuk menghapus objek Contact dari tabel contact berdasarkan id
  static Future<int> delete(int id) async {
    // Mendapatkan instance database
    final db = await DbHelper.db();
    // Menghapus contact yang memiliki id yang diberikan
    int count = await db.delete(
      'contact',
      where: 'id=?',
      whereArgs: [id],
    );
    return count;
  }
}
