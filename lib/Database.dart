import 'dart:async';
import 'dart:io';

import 'package:flutter_photography/models/Student.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_photography/ClientModel.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  DBProvider._();

  static final DBProvider db = DBProvider._();

  Database? _database;

  Future<Database?> get database async {
    if (_database == null) {
      _database = await initDB();
    }
    return _database;
    // if (_database != null) return _database;
    // // if _database is null we instantiate it
    // _database = await initDB();
    // return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "TestDB.db");
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE Student ("
          "id INTEGER PRIMARY KEY,"
          "first_name TEXT,"
          "last_name TEXT,"
          "note TEXT"
          ")");
      // await db.execute("CREATE TABLE Attendance ("
      //     "id INTEGER PRIMARY KEY,"
      //     "stu_id TEXT,"
      //     "date DATE"
      //     ")");
    });
  }

  //Create a student
  newStudent(Student newStd) async {
    final db = await database;
    //get the biggest id in the table
    var table = await db!.rawQuery("SELECT MAX(id)+1 as id FROM Student");
    var id = table.first["id"] ?? 1;
    // int id = table.first["id"] as int;
    //insert to the table using the new id
    var raw = await db.rawInsert(
        "INSERT Into Student (id,first_name,last_name,note)"
        " VALUES (?,?,?,?)",
        [id, newStd.firstName, newStd.lastName, newStd.note]);
    return raw;
  }

  // newClient(Client newClient) async {
  //   final db = await database;
  //   //get the biggest id in the table
  //   var table = await db.rawQuery("SELECT MAX(id)+1 as id FROM Client");
  //   int id = table.first["id"];
  //   //insert to the table using the new id
  //   var raw = await db.rawInsert(
  //       "INSERT Into Client (id,first_name,last_name,blocked)"
  //       " VALUES (?,?,?,?)",
  //       [id, newClient.firstName, newClient.lastName, newClient.blocked]);
  //   return raw;
  // }

  // blockOrUnblock(Client client) async {
  //   final db = await database;
  //   Client blocked = Client(
  //       id: client.id,
  //       firstName: client.firstName,
  //       lastName: client.lastName,
  //       blocked: !client.blocked);
  //   var res = await db.update("Client", blocked.toMap(),
  //       where: "id = ?", whereArgs: [client.id]);
  //   return res;
  // }

  // updateClient(Client newClient) async {
  //   final db = await database;
  //   var res = await db.update("Client", newClient.toMap(),
  //       where: "id = ?", whereArgs: [newClient.id]);
  //   return res;
  // }

//edit a student
  updateStd(Student std) async {
    final db = await database;
    var res = await db!
        .update("Student", std.toMap(), where: "id = ?", whereArgs: [std.id]);
    return res;
  }

//get a student by a given id
  getStudent(int id) async {
    final db = await database;
    var res = await db!.query("Student", where: "id = ?", whereArgs: [id]);
    return res.isNotEmpty ? Student.fromMap(res.first) : null;
  }

  //get all students

  Future<List<Student>> getAllStudents() async {
    final db = await database;
    var res = await db!.query("Student");
    List<Student> list =
        res.isNotEmpty ? res.map((c) => Student.fromMap(c)).toList() : [];
    return list;
  }

  deleteStudent(int id) async {
    final db = await database;
    return db!.delete("Student", where: "id = ?", whereArgs: [id]);
  }

  deleteAll() async {
    final db = await database;
    db!.rawDelete("Delete * from Student");
  }

  // getClient(int id) async {
  //   final db = await database;
  //   var res = await db.query("Client", where: "id = ?", whereArgs: [id]);
  //   return res.isNotEmpty ? Client.fromMap(res.first) : null;
  // }

  // Future<List<Client>> getBlockedClients() async {
  //   final db = await database;

  //   print("works");
  //   // var res = await db.rawQuery("SELECT * FROM Client WHERE blocked=1");
  //   var res = await db.query("Client", where: "blocked = ? ", whereArgs: [1]);

  //   List<Client> list =
  //       res.isNotEmpty ? res.map((c) => Client.fromMap(c)).toList() : [];
  //   return list;
  // }

  // Future<List<Client>> getAllClients() async {
  //   final db = await database;
  //   var res = await db.query("Client");
  //   List<Client> list =
  //       res.isNotEmpty ? res.map((c) => Client.fromMap(c)).toList() : [];
  //   return list;
  // }

  // deleteClient(int id) async {
  //   final db = await database;
  //   return db.delete("Client", where: "id = ?", whereArgs: [id]);
  // }

  // deleteAll() async {
  //   final db = await database;
  //   db.rawDelete("Delete * from Client");
  // }
}
