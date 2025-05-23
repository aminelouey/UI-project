import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class DatabaseHelper {
  static Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "clinic.db");

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
      onConfigure: (db) async {
        await db.execute("PRAGMA foreign_keys = ON;");
      },
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE Patients (
        Id INTEGER PRIMARY KEY AUTOINCREMENT,
        Full_Name TEXT UNIQUE,
        Phone_Number INTEGER,
        Birth_Day TEXT
      );
    ''');

    await db.execute('''
      CREATE TABLE Appointments (
        Patient_id INTEGER,
        Date TEXT DEFAULT (DATETIME('now','localtime')),
        FOREIGN KEY (Patient_id) REFERENCES Patients(Id) ON DELETE CASCADE ON UPDATE CASCADE
      );
    ''');

    await db.execute('''
      CREATE TABLE Treatments (
        Patient_id INTEGER,
        Diagnosis TEXT,
        Treatment TEXT,
        FOREIGN KEY (Patient_id) REFERENCES Patients(Id) ON DELETE CASCADE ON UPDATE CASCADE
      );
    ''');

    await db.execute('''
      CREATE TRIGGER id_trigger
      AFTER INSERT ON Patients
      BEGIN
        INSERT INTO Appointments(Patient_id) VALUES (NEW.Id);
        INSERT INTO Treatments(Patient_id) VALUES (NEW.Id);
      END;
    ''');

    await db.execute('CREATE INDEX idx_name ON Patients(Full_Name);');
  }

  Future<void> addPatient(String name, String phone) async {
    final db = await database;
    await db.insert('Patients', {
      'Full_Name': name,
      'Phone_Number': phone,
    });
  }

  Future<void> updatePatientName(String oldName, String newName) async {
    final db = await database;
    await db.update(
      'Patients',
      {'Full_Name': newName},
      where: 'Full_Name = ?',
      whereArgs: [oldName],
    );
  }

  Future<void> updatePhone(String oldPhone, String newPhone) async {
    final db = await database;
    await db.update(
      'Patients',
      {'Phone_Number': newPhone},
      where: 'Phone_Number = ?',
      whereArgs: [oldPhone],
    );
  }

  Future<void> updateAppointment(String name, String date) async {
    final db = await database;
    await db.rawUpdate('''
      UPDATE Appointments 
      SET Date = ?
      WHERE Patient_id = (SELECT Id FROM Patients WHERE Full_Name = ?)
    ''', [date, name]);
  }

  Future<void> updateDiagnosis(String name, String diagnosis) async {
    final db = await database;
    await db.rawUpdate('''
      UPDATE Treatments 
      SET Diagnosis = ?
      WHERE Patient_id = (SELECT Id FROM Patients WHERE Full_Name = ?)
    ''', [diagnosis, name]);
  }

  Future<void> updateTreatment(String name, String treatment) async {
    final db = await database;
    await db.rawUpdate('''
      UPDATE Treatments 
      SET Treatment = ?
      WHERE Patient_id = (SELECT Id FROM Patients WHERE Full_Name = ?)
    ''', [treatment, name]);
  }

  Future<List<Map<String, dynamic>>> getPatientDetails(String name) async {
    final db = await database;
    return await db.rawQuery('''
      SELECT 
        Patients.Id,
        Patients.Full_Name,
        Patients.Phone_Number,
        Appointments.Date,
        Treatments.Diagnosis,
        Treatments.Treatment
      FROM Patients
      LEFT JOIN Appointments ON Patients.Id = Appointments.Patient_Id
      LEFT JOIN Treatments ON Patients.Id = Treatments.Patient_Id
      WHERE Patients.Full_Name LIKE ?
      ORDER BY Appointments.Date
    ''', ['%$name%']);
  }

  Future<void> deletePatient(String name) async {
    final db = await database;
    await db.delete('Patients', where: 'Full_Name = ?', whereArgs: [name]);
  }
}
