import 'dart:async';

import 'package:flutter_photography/Database.dart';
import 'package:flutter_photography/models/Attendence.dart';
import 'package:intl/intl.dart';

class AttendBloc {
  AttendBloc() {
    // getAtds();
  }

  final _stdController = StreamController<List<Attendence>>.broadcast();

  get clients => _stdController.stream;
  String currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

  // getAtds() async {
  //   _stdController.sink
  //       .add(await DBProvider.db.getAllAttendenceCustom(currentDate));
  // }

  Future<void> delete(int id) async {
    await DBProvider.db.deleteAttendence(id);
    // await getAtds();
  }

  // Future<void> add(Student s) async {
  //   await DBProvider.db.newStudent(s);
  //   await getStds();
  // }

  dispose() {
    _stdController.close();
  }
}
