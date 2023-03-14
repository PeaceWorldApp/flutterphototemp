import 'dart:async';
import 'dart:collection';

import 'package:flutter_photography/Database.dart';
import 'package:flutter_photography/models/Student.dart';

class StudentBloc {
  StudentBloc() {
    getStds();
  }
  List<Student> _items = [];
  UnmodifiableListView<Student> get items => UnmodifiableListView(_items);

  final _stdController = StreamController<List<Student>>.broadcast();

  get clients => _stdController.stream;

  getStds() async {
    _stdController.sink.add(await DBProvider.db.getAllStudents());
    Future<List<Student>> list = DBProvider.db.getAllStudents2();
    list.then((dbItems) {
      for (var i = 0; i < dbItems.length; i++) {
        _items.add(dbItems[i]);
      }
    });
  }

  Student? byId(int id) {
    for (var i = 0; i < _items.length; i++) {
      if (_items[i].id == id) {
        return _items[i];
      }
    }
    return null;
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
