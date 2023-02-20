import 'dart:async';

import 'package:flutter_photography/Database.dart';
import 'package:flutter_photography/models/Student.dart';

class StudentBloc {
  StudentBloc() {
    getStds();
  }

  final _stdController = StreamController<List<Student>>.broadcast();

  get clients => _stdController.stream;

  getStds() async {
    _stdController.sink.add(await DBProvider.db.getAllStudents());
  }

  Future<void> delete(int id) async {
    await DBProvider.db.deleteStudent(id);
    await getStds();
  }

  Future<void> add(Student s) async {
    await DBProvider.db.newStudent(s);
    await getStds();
  }

  dispose() {
    _stdController.close();
  }
}
