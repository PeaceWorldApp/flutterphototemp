import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_photography/Database.dart';
import 'package:flutter_photography/constants.dart';
import 'package:flutter_photography/data/AttendBloc.dart';
import 'package:flutter_photography/data/FeeBloc.dart';
import 'package:flutter_photography/data/StudentBloc.dart';
import 'package:flutter_photography/main.dart';
import 'package:flutter_photography/models/Attendence.dart';
import 'package:flutter_photography/models/Fee.dart';
import 'package:flutter_photography/models/Student.dart';
import 'package:flutter_photography/pages/MainFee.dart';
import 'package:textfield_search/textfield_search.dart';

class MainSearch extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // var routes = <String, WidgetBuilder>{
    //   MainStd.routeName: (BuildContext context) =>
    //       new MainStd(title: "MainStudent"),
    // };
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MySearch(title: 'Search by Student Name'),
      // routes: routes,
    );
  }
}

class MySearch extends StatefulWidget {
  MySearch({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MySearchState createState() => new _MySearchState();
}

class _MySearchState extends State<MySearch> {
  Future<List<Fee>>? feeGlobal;
  List<Fee>? feeList;
  String _moneyGlobal = "";
  final _testList = [
    'Test Item 1',
    'Test Item 2',
    'Test Item 3',
    'Test Item 4',
  ];

  final stdBloc = StudentBloc();
  // final attBloc = AttendBloc();
  final feeBloc = FeeBloc();
  Future<List<Attendence>>? futureList;
  // Future<List<Student>>? studentList;

  TextEditingController myController2 = TextEditingController();
  List<Student>? myList;
  Student? currentStd;
  String current_id = "-1";

  @override
  void initState() {
    // myController2.addListener(_printLatestValue);
    getStringList();
    feeGlobal = fetchStdFee();
    futureList = fetchStdAttendence();
    feeGlobal = fetchStdFee();
    super.initState();
    // studentList = fetchStdList();
  }

  // _printLatestValue() {
  //   print("text field: ${myController2.text}");
  // }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    myController2.dispose();
    stdBloc.dispose();
    feeBloc.dispose();
    super.dispose();
  }

  Future<List<Student>> fetchStdList() async {
    return Future.delayed(Duration(seconds: 1), () async {
      return await DBProvider.db.getAllStudents();
    });
  }

  Future<List<Attendence>> fetchStdAttendence() async {
    return Future.delayed(Duration(seconds: 1), () async {
      return await DBProvider.db.getAllAttendencesByStd(current_id);
    });
  }

  Future<List<Fee>> fetchStdFee() async {
    return Future.delayed(Duration(seconds: 1), () async {
      return await DBProvider.db.getAllFee();
    });
  }

  void getStdAttendList() async {
    var tempList1 = fetchStdAttendence();
    // Or use setState to assign the tempList to myList
    futureList = tempList1;
  }

  void getFeeMoney() async {
    var tempList2 = fetchStdFee();
    // Or use setState to assign the tempList to myList
    feeGlobal = tempList2;
  }

  void getStringList() async {
    var tempList = await fetchStdList();
    // Or use setState to assign the tempList to myList
    myList = tempList;
  }

  getMoneyFromFee(int feid) async {
    for (Fee element in feeList!) {
      if (element.id!.compareTo(feid) == 0) {
        _moneyGlobal = element.money.toString();
      }
    }
  }

  void getStudent() async {
    var tempList = await DBProvider.db.getStudent(int.parse(current_id));
    // Or use setState to assign the tempList to myList
    currentStd = tempList;
  }

  void func() async {
    List<Fee>? value = await feeGlobal; // Await on your future.
    setState(() {
      feeList = value;
    });
  }

  // mocking a future
  Future<List> fetchSimpleData() async {
    await Future.delayed(Duration(seconds: 1));

    List _list = <dynamic>[];

    List<Student>? lstStd = myList;
    for (Student s in lstStd!) {
      _list.add(s.id.toString() + ' ' + s.lastName + ' ' + s.firstName);
    }
    return _list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(widget.title),
        ),
        body: Padding(
          padding: EdgeInsets.all(20),
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: Form(
            child: ListView(
              children: <Widget>[
                SizedBox(height: 16),
                TextFieldSearch(
                    label: 'Enter 3 letter in student\'s name',
                    controller: myController2,
                    future: () {
                      return fetchSimpleData();
                    }),
                SizedBox(height: 16),
                Hero(
                  tag: "add_std_1",
                  child:
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   children: [
                      ElevatedButton(
                    child: Text("Search".toUpperCase()),
                    onPressed: () {
                      setState(() {
                        String textContent = myController2.text;
                        current_id =
                            textContent.substring(0, textContent.indexOf(' '));

                        getStdAttendList();
                        getStudent();
                        func();
                      });
                      // String textContent = myController2.text;
                      // String id =
                      //     textContent.substring(0, textContent.indexOf(' '));
                      // print(id);
                    },
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                StreamBuilder<List<Attendence>>(
                  stream: futureList!.asStream(),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<Attendence>> snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: snapshot.data!.length,
                        itemBuilder: (BuildContext context, int index) {
                          Attendence item = snapshot.data![index];
                          print("feeid: " + item.feid.toString());
                          getMoneyFromFee(item.feid);
                          print("check datemoney:" +
                              item.date +
                              " " +
                              _moneyGlobal);
                          return ListTile(
                              onTap: () {
                                setState(() {
                                  _addnote(
                                      item.id!,
                                      currentStd!.firstName +
                                          " " +
                                          currentStd!.lastName,
                                      item.date,
                                      _moneyGlobal);

                                  print("std: " + current_id);
                                });
                              },
                              title: Text(item.date + "    " + _moneyGlobal));
                          // Dismissible(
                          //   key: UniqueKey(),
                          //   background: Container(color: Colors.red),
                          //   onDismissed: (direction) {
                          //     // stdBloc.delete(item.id!);
                          //     _addnote(item.id!);
                          //   },
                          //   child: Container(
                          //     height: 50,
                          //     color: Colors.amber[index],
                          //     child: Center(
                          //         child: Text(
                          //             item.date + " " + item.id.toString())),
                          //   ),
                          // );
                        },
                      );
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  },
                )
              ],
            ),
          ),
        ),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              heroTag: null,
              onPressed: _onHomePressed,
              tooltip: 'Home',
              child: new Icon(Icons.home),
            )
          ],
        ));
  }

  _list() => Text('list of contacts goes here');
  // _addnote(int id) {
  //   print(id);
  // }

  void _addnote(int id, String name, String date, String money) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MainFee(
                attid: id,
                title: name,
                dateAtt: date,
                money: money))).then((value) {
      setState(() {
        // futureList = fetchList();
      });
    });
  }

  void _onHomePressed() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()))
        .then((value) {
      setState(() {
        // futureList = fetchList();
      });
    });
  }
}
