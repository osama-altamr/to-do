import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import '../models/task.dart';

class DBHelper {
  static Database? _database;
  static const int _version = 1;
  static const String _tabelName = 'tasks';

  static initDb() async {
    if (_database != null) {
      debugPrint('');
      return;
    } else {
      try {
        String _path = await getDatabasesPath() + 'task.db';
        debugPrint('in database path');
        _database = await openDatabase(_path, version: _version,
            onCreate: (Database db, int version) async {
          debugPrint('creating a new database');
          await db.execute(
            'CREATE TABLE $_tabelName ('
            'id INTEGER PRIMARY KEY AUTOINCREMENT, '
            'title STRING, note TEXT, date STRING, '
            'startTime STRING, endTime STRING, '
            'remind INTEGER, repeat STRING, '
            'color INTEGER, '
            'isCompleted INTEGER)',
          );
        });
        debugPrint('Data base Created ');
      } catch (e) {
        debugPrint('$e');
      }
    }
  }

  static Future<int> insert(Task? task) async {
    print('insert function called  ');
    try {
      return await _database!.insert(_tabelName, task!.toJson());
    } catch (e) {
      debugPrint('We are here ');
      return 99999;
    }
  }

  static Future<int> delete(Task? task) async {
    print('delete function called  ');
    return await _database!.delete(
      _tabelName,
      where: 'id = ?',
      whereArgs: [task!.id],
    );
  }

  static  deleteAll() async {
    print('deleteAll function called  ');
    return await _database!.delete(
      _tabelName,
    );
  }

  static Future<List<Map<String, dynamic>>> query() async {
    print('query function called');
    return await _database!.query(_tabelName);
  }

  static Future<int> update(int? id) async {
    print('update function called  ');
    return await _database!.rawUpdate('''
    UPDATE tasks
    SET isCompleted = ?
    WHERE id = ? 
    ''', [1, id!]);
  }
}
