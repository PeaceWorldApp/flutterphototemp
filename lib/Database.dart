import 'dart:async';
import 'dart:io';

import 'package:flutter_photography/data/AttendBloc.dart';
import 'package:flutter_photography/models/Attendence.dart';
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
    return await openDatabase(path, version: 2, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE Student ("
          "id INTEGER PRIMARY KEY,"
          "first_name TEXT,"
          "last_name TEXT,"
          "note TEXT"
          ")");
      await db.execute("CREATE TABLE Attendence ("
          "id INTEGER PRIMARY KEY AUTOINCREMENT,"
          "stdid INTEGER,"
          "date Date,"
          "status BOOLEAN"
          ")");
    });
  }

//Add methods
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

  addMultiAttend(String dateNow) async {
    final db = await database;

    String sql = '''
  INSERT INTO Attendence (
      stdid,date,status
    ) VALUES (?, ?,?)
  ''';
    //you can get this data from json object /API
    List<Map> attendData = [];
    //select all students
    var resStudents = await db!.query("Student");
    List<Student> stdList = resStudents.isNotEmpty
        ? resStudents.map((c) => Student.fromMap(c)).toList()
        : [];
    print("Student lenght: " + stdList.length.toString());
    int i = 0;
    //traverse each student, and insert a new record to Attendence
    for (var s in stdList) {
      Map m = {"stdid": s.id, "date": dateNow, "status": false};
      attendData.add(m);
      ++i;
      print("stt: " + i.toString());
    }
    //and then loop your data here
    var raw = attendData.forEach((element) async {
      await db.rawInsert(
          sql, [element['stdid'], element['date'], element['status']]);
    });
    return raw;
  }

  addSomeNewStudent(String dateNow, List<String> list) async {
    final db = await database;

    String sql = '''
    INSERT INTO Attendence (
        stdid,date,status
      ) VALUES (?, ?,?)
    ''';
    //you can get this data from json object /API
    List<Map> attendData = [];
    //select all students

    int i = 0;
    //traverse each student, and insert a new record to Attendence
    for (var s in list) {
      Map m = {"stdid": s, "date": dateNow, "status": false};
      attendData.add(m);
      ++i;
      print("stt: " + i.toString());
    }
    //and then loop your data here
    var raw = attendData.forEach((element) async {
      await db!.rawInsert(
          sql, [element['stdid'], element['date'], element['status']]);
    });
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
//Edit Methods
//edit a student
  updateStd(Student std) async {
    final db = await database;
    var res = await db!
        .update("Student", std.toMap(), where: "id = ?", whereArgs: [std.id]);
    return res;
  }

  //edit the status of an attendance
  updateAtt(int id) async {
    final db = await database;
    getAttendence(id).then((value) {
      Attendence att = value;
      att.status = 1;
      // print(att.status);

      var res = db!.update("Attendence", att.toMap(),
          where: "id = ?", whereArgs: [att.id]);
      return res;
    });
  }

//Get methods
//get a student by a given id
  Future<Student?> getStudent(int id) async {
    final db = await database;
    var res = await db!.query("Student", where: "id = ?", whereArgs: [id]);
    return res.isNotEmpty ? Student.fromMap(res.first) : null;
  }

  //get an attendence by a given id
  getAttendence(int id) async {
    final db = await database;
    var res = await db!.query("Attendence", where: "id = ?", whereArgs: [id]);
    return res.isNotEmpty ? Attendence.fromMap(res.first) : null;
  }

  //get all students

  Future<List<Student>> getAllStudents() async {
    final db = await database;
    var res = await db!.query("Student");
    List<Student> list =
        res.isNotEmpty ? res.map((c) => Student.fromMap(c)).toList() : [];
    return list;
  }

  Future<List<Student>> getAllStudents2() async {
    final db = await database;

    var results = await db!.query("Student");
    List<Student> expenses = [];
    results.forEach((result) {
      Student expense = Student.fromMap(result);
      expenses.add(expense);
    });
    return expenses;
  }

  Future<List<Attendence>> getAllAttendences(String dateStr) async {
    final db = await database;
    var res = await db!.query("Attendence",
        // where: "date = ?", whereArgs: [dateStr]);
        where: "date = ? and status = ?",
        whereArgs: [dateStr, 0]);
    List<Attendence> list =
        res.isNotEmpty ? res.map((c) => Attendence.fromMap(c)).toList() : [];

    var resStudents = await db!.query("Student");
    List<Student> stdList = resStudents.isNotEmpty
        ? resStudents.map((c) => Student.fromMap(c)).toList()
        : [];
    int studentNumberNow = stdList.length;
    if (list.length < studentNumberNow) {
      List<String> list = [];
      String sqlQuery =
          "SELECT DISTINCT u.id as uid FROM Attendence a, Student u WHERE u.id not in " +
              "(select att.stdid from Attendence att) and a.date ='" +
              dateStr +
              "'";
      var res = await db!.rawQuery(sqlQuery);
      print("Number:" + res.length.toString());
      // list = res.map((c) => ).toList()
      list = await res.map((c) => c['uid'].toString()).toList();
      List<String> data = await list;
      for (var element in data) {
        print("Student id: " + element + "\n");
      }
      await addSomeNewStudent(dateStr, data);
    } else if (list.length > studentNumberNow) {
      List<String> list = [];
      String sqlQuery =
          "SELECT DISTINCT a.id as aid FROM Attendence a, Student u " +
              "WHERE a.stdid not in (select st.id from Student st) and a.date = '" +
              dateStr +
              "'";
      var res = await db!.rawQuery(sqlQuery);
      print("Number:" + res.length.toString());
      // list = res.map((c) => ).toList()
      list = await res.map((c) => c['aid'].toString()).toList();
      List<String> data = await list;
      for (var element in data) {
        print("Attendence id not exist anymore: " + element + "\n");
      }
      await removeSomeStudent(data);
    }
    return list;
  }

/**
 * SELECT DISTINCT u.id FROM `attend` a, `user` u WHERE u.id not in (select att.user_id from attend att) and a.date = '2023-03-03';
 * SELECT DISTINCT a.user_id FROM `attend` a, `Student` u WHERE a.user_id not in (select st.id from student st) and a.date = '2023-03-03';
 */
  Future<List<String>> getNewStudent(String dateStr) async {
    final db = await database;
    List<String> list = [];
    String sqlQuery =
        "SELECT DISTINCT u.id as uid FROM Attendence a, Student u WHERE u.id not in " +
            "(select att.stdid from Attendence att) and a.date ='" +
            dateStr +
            "'";
    var res = await db!.rawQuery(sqlQuery);
    print(res.length);
    // list = res.map((c) => ).toList()
    list = res.map((c) => c['uid'].toString()).toList();
    return list;
  }

  getAllAttendenceCustom(String dateStr) async {
    final db = await database;
    List<Attendence> list = [];
    var res =
        await db!.query("Attendence", where: "date = ?", whereArgs: [dateStr]);
    // where: "date = ? and status = ?", whereArgs: [dateStr, 0]);
    if (res.isEmpty) {
      await addMultiAttend(dateStr);
    }
  }

  ///Delete

  deleteStudent(int id) async {
    final db = await database;
    return db!.delete("Student", where: "id = ?", whereArgs: [id]);
  }

  deleteAttendence(int id) async {
    final db = await database;
    return db!.delete("Attendence", where: "id = ?", whereArgs: [id]);
  }

  deleteAll() async {
    final db = await database;
    db!.rawDelete("Delete * from Student");
  }

  removeSomeStudent(List<String> list) async {
    final db = await database;

    String sql = '''
    DELETE FROM Attendence
      WHERE id = ?
    ''';
    //you can get this data from json object /API
    List<Map> attendData = [];
    //select all students

    int i = 0;
    //traverse each student, and insert a new record to Attendence
    for (var s in list) {
      Map m = {"aid": int.parse(s)};
      attendData.add(m);
      ++i;
      print("stt: " + i.toString());
    }
    //and then loop your data here
    var raw = attendData.forEach((element) async {
      await db!.rawQuery(sql, [element['aid']]);
    });
    return raw;
  }

  Future<List<Attendence>> checkAttend(String dateStr) async {
    final db = await database;
    List<Attendence> list = [];
    String sqlQuery =
        "SELECT * FROM Attendence a, Student s WHERE a.stdid=s.id";
    var res = await db!.rawQuery(sqlQuery);

    list = res.map((c) => Attendence.fromMap(c)).toList();
    return list;
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
