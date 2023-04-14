import 'dart:async';
import 'dart:collection';

import 'package:flutter_photography/Database.dart';
import 'package:flutter_photography/models/Fee.dart';

class FeeBloc {
  FeeBloc() {
    // getStds();
  }
  List<Fee> _items = [];
  UnmodifiableListView<Fee> get items => UnmodifiableListView(_items);

  final _stdController = StreamController<List<Fee>>.broadcast();

  get clients => _stdController.stream;
  getFees() async {
    _stdController.sink.add(await DBProvider.db.getAllFee());
  }

  Fee? byId(int id) {
    for (var i = 0; i < _items.length; i++) {
      if (_items[i].id == id) {
        return _items[i];
      }
    }
    return null;
  }

  Future<void> delete(int id) async {
    await DBProvider.db.deleteStudent(id);
    // await getStds();
  }

  Future<void> add(Fee s, int attid) async {
    await DBProvider.db.newFee(s, attid);
    await getFees();
  }

  Future<void> edit(Fee s) async {
    await DBProvider.db.updateFee(s);
    await getFees();
  }

  dispose() {
    _stdController.close();
  }
}
