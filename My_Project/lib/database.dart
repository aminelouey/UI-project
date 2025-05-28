import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Appointmentee {
  final int? id;
  final String name;
  final String? date;
  final String? note;
  final String? phoneNumber;

  Appointmentee(
      {this.id, required this.name, this.date, this.note, this.phoneNumber});

  Map<String, dynamic> toMap() {
    return {
      'Id': id,
      'Name': name,
      'Date': date,
      'Note': note,
      'Phone_Number': phoneNumber,
    };
  }

  factory Appointmentee.fromMap(Map<String, dynamic> map) {
    return Appointmentee(
      id: map['Id'],
      name: map['Name'],
      date: map['Date'],
      note: map['Note'],
      phoneNumber: map['Phone_Number'],
    );
  }
}

class AppDatabase {
  static final AppDatabase _instance = AppDatabase._();
  static Database? _database;

  AppDatabase._();

  factory AppDatabase() => _instance;

  Future<Database> get database async {
    _database ??= await _initDB('appointments.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final path = join(await getDatabasesPath(), filePath);
    return openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
      onOpen: (db) async {
        await db.execute("PRAGMA auto_vacuum = ON;");
        await db.execute("PRAGMA journal_mode = WAL;");
      },
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE Appointments (
        Id INTEGER PRIMARY KEY AUTOINCREMENT,
        Name TEXT,
        Date TEXT DEFAULT (DATETIME('now','localtime')),
        Note TEXT,
        Phone_Number TEXT
      );
    ''');
  }

  Future<int> insertAppointment(Appointmentee appointment) async {
    final db = await database;
    return await db.insert('Appointments', appointment.toMap());
  }

  Future<List<Appointmentee>> getAppointments({String? query}) async {
    final db = await database;
    final result = await db.query('Appointments');
    return result.map((map) => Appointmentee.fromMap(map)).toList();
  }

  Future<List<Appointmentee>> searchByName(String name) async {
    final db = await database;
    final result = await db
        .query('Appointments', where: 'Name LIKE ?', whereArgs: ['%$name%']);
    return result.map((map) => Appointmentee.fromMap(map)).toList();
  }

  Future<int> updateAppointment(Appointmentee appointment) async {
    final db = await database;
    return await db.update(
      'Appointments',
      appointment.toMap(),
      where: 'Id = ?',
      whereArgs: [appointment.id],
    );
  }

  Future<int> deleteAppointment(String name) async {
    final db = await database;
    return await db
        .delete('Appointments', where: 'Name = ?', whereArgs: [name]);
  }

  Future close() async {
    final db = await database;
    db.close();
  }
}
