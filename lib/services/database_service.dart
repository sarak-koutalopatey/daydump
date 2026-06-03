import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/entry.dart';

class DatabaseService {
  static Database? _db;

  static Future<Database> get _database async {
    return _db ??= await _open();
  }

  static Future<Database> _open() async {
    final dir = await getDatabasesPath();
    final dbPath = join(dir, 'daydump.db');
    if (kDebugMode) await deleteDatabase(dbPath);
    return openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, _) => db.execute('''
        CREATE TABLE entries (
          id TEXT PRIMARY KEY,
          date TEXT NOT NULL,
          accomplished TEXT NOT NULL,
          blockers TEXT NOT NULL,
          tomorrow TEXT NOT NULL
        )
      '''),
    );
  }

  static Future<List<JournalEntry>> getAllEntries() async {
    final db = await _database;
    final rows = await db.query('entries', orderBy: 'date DESC');
    return rows
        .map((r) => JournalEntry.fromJson(Map<String, dynamic>.from(r)))
        .toList();
  }

  static Future<void> insertEntry(JournalEntry entry) async {
    final db = await _database;
    await db.insert(
      'entries',
      entry.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<void> deleteEntry(String id) async {
    final db = await _database;
    await db.delete('entries', where: 'id = ?', whereArgs: [id]);
  }

  static Future<void> deleteAll() async {
    final db = await _database;
    await db.delete('entries');
  }
}
