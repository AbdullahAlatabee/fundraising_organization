import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import '../models/user_model.dart';
import '../models/donor_model.dart';
import '../models/donation_case_model.dart';
import '../models/donation_model.dart';
import '../models/activity_log_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('charity_org.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const integerType = 'INTEGER NOT NULL';
    const realType = 'REAL NOT NULL';
    const textNullable = 'TEXT';

    await db.execute('''
    CREATE TABLE users (
      id $idType,
      name $textType,
      email $textType UNIQUE,
      password $textType,
      role $textType,
      created_at $textType
    )
    ''');

    await db.execute('''
    CREATE TABLE donors (
      id $idType,
      full_name $textType,
      phone $textType,
      address $textNullable,
      notes $textNullable,
      created_by $integerType,
      created_at $textType,
      FOREIGN KEY (created_by) REFERENCES users (id)
    )
    ''');

    await db.execute('''
    CREATE TABLE donation_cases (
      id $idType,
      title $textType,
      description $textType,
      target_amount $realType,
      collected_amount $realType,
      status $textType,
      image_path $textNullable,
      created_by $integerType,
      created_at $textType,
      FOREIGN KEY (created_by) REFERENCES users (id)
    )
    ''');

    await db.execute('''
    CREATE TABLE donations (
      id $idType,
      donor_id $integerType,
      case_id $integerType,
      amount $realType,
      donation_type $textType,
      donation_date $textType,
      added_by $integerType,
      FOREIGN KEY (donor_id) REFERENCES donors (id),
      FOREIGN KEY (case_id) REFERENCES donation_cases (id),
      FOREIGN KEY (added_by) REFERENCES users (id)
    )
    ''');

    await db.execute('''
    CREATE TABLE images (
      id $idType,
      related_type $textType,
      related_id $integerType,
      image_path $textType
    )
    ''');

    await db.execute('''
    CREATE TABLE activity_logs (
      id $idType,
      user_id $integerType,
      action $textType,
      entity $textType,
      timestamp $textType,
      FOREIGN KEY (user_id) REFERENCES users (id)
    )
    ''');
  }

  // --- USERS ---
  Future<int> createUser(User user) async {
    final db = await instance.database;
    return await db.insert('users', user.toMap());
  }

  Future<User?> getUserByEmail(String email) async {
    final db = await instance.database;
    final maps = await db.query(
      'users',
      columns: ['id', 'name', 'email', 'password', 'role', 'created_at'],
      where: 'email = ?',
      whereArgs: [email],
    );

    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    } else {
      return null;
    }
  }

  // --- DONORS ---
  Future<int> createDonor(Donor donor) async {
    final db = await instance.database;
    int id = await db.insert('donors', donor.toMap());
    await _logActivity(donor.createdBy, 'Create', 'Donor ID: $id');
    return id;
  }

  Future<List<Donor>> getAllDonors() async {
    final db = await instance.database;
    final result = await db.query('donors', orderBy: 'created_at DESC');
    return result.map((json) => Donor.fromMap(json)).toList();
  }

  Future<int> updateDonor(Donor donor, int userId) async {
    final db = await instance.database;
    int result = await db.update(
      'donors',
      donor.toMap(),
      where: 'id = ?',
      whereArgs: [donor.id],
    );
     await _logActivity(userId, 'Update', 'Donor ID: ${donor.id}');
    return result;
  }

  Future<int> deleteDonor(int id, int userId) async {
    final db = await instance.database;
    int result = await db.delete(
      'donors',
      where: 'id = ?',
      whereArgs: [id],
    );
    await _logActivity(userId, 'Delete', 'Donor ID: $id');
    return result;
  }
  
  Future<List<Donor>> searchDonors(String query) async {
    final db = await instance.database;
    final result = await db.query(
      'donors', 
      where: 'full_name LIKE ?', 
      whereArgs: ['%$query%']
    );
    return result.map((json) => Donor.fromMap(json)).toList();
  }

  // --- CASES ---
  Future<int> createCase(DonationCase dCase) async {
    final db = await instance.database;
    int id = await db.insert('donation_cases', dCase.toMap());
    await _logActivity(dCase.createdBy, 'Create', 'Case ID: $id');
    return id;
  }

  Future<List<DonationCase>> getAllCases() async {
    final db = await instance.database;
    final result = await db.query('donation_cases', orderBy: 'created_at DESC');
    return result.map((json) => DonationCase.fromMap(json)).toList();
  }
  
  Future<DonationCase?> getCaseById(int id) async {
    final db = await instance.database;
    final maps = await db.query(
      'donation_cases',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) return DonationCase.fromMap(maps.first);
    return null;
  }

  Future<int> updateCase(DonationCase dCase, int userId) async {
    final db = await instance.database;
    int result = await db.update(
      'donation_cases',
      dCase.toMap(),
      where: 'id = ?',
      whereArgs: [dCase.id],
    );
    await _logActivity(userId, 'Update', 'Case ID: ${dCase.id}');
    return result;
  }

  // --- DONATIONS ---
  Future<int> createDonation(Donation donation) async {
    final db = await instance.database;
    // 1. Insert Donation
    int id = await db.insert('donations', donation.toMap());
    
    // 2. Update Case Collected Amount
    final dCase = await getCaseById(donation.caseId);
    if (dCase != null) {
      double newAmount = dCase.collectedAmount + donation.amount;
      String status = dCase.status;
      if(newAmount >= dCase.targetAmount) {
         status = 'completed';
      }
      
      await db.update(
        'donation_cases',
        {'collected_amount': newAmount, 'status': status},
        where: 'id = ?',
        whereArgs: [donation.caseId],
      );
    }
    
    await _logActivity(donation.addedBy, 'Create', 'Donation ID: $id');
    return id;
  }

  Future<List<Donation>> getDonationsByCase(int caseId) async {
    final db = await instance.database;
    final result = await db.query(
      'donations',
      where: 'case_id = ?',
      whereArgs: [caseId],
      orderBy: 'donation_date DESC'
    );
    return result.map((json) => Donation.fromMap(json)).toList();
  }
  
  Future<List<Donation>> getDonationsByDonor(int donorId) async {
    final db = await instance.database;
    final result = await db.query(
      'donations',
      where: 'donor_id = ?',
      whereArgs: [donorId],
      orderBy: 'donation_date DESC'
    );
    return result.map((json) => Donation.fromMap(json)).toList();
  }
  
  Future<List<Donation>> getAllDonations() async {
    final db = await instance.database;
     final result = await db.query('donations', orderBy: 'donation_date DESC');
    return result.map((json) => Donation.fromMap(json)).toList();
  }

  // --- LOGS ---
  Future<int> _logActivity(int userId, String action, String entity) async {
    final db = await instance.database;
    final log = ActivityLog(
      userId: userId,
      action: action,
      entity: entity,
      timestamp: DateTime.now().toIso8601String(),
    );
    return await db.insert('activity_logs', log.toMap());
  }
  
  Future<List<ActivityLog>> getLogs() async {
    final db = await instance.database;
    final result = await db.query('activity_logs', orderBy: 'timestamp DESC');
    return result.map((json) => ActivityLog.fromMap(json)).toList();
  }

  Future<void> close() async {
    final db = await instance.database;
    db.close();
  }
}
