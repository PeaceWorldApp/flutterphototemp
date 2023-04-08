import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_photography/Database.dart';
import 'package:flutter_photography/constants.dart';
import 'package:flutter_photography/data/StudentBloc.dart';
import 'package:flutter_photography/main.dart';
import 'package:flutter_photography/models/Attendence.dart';
import 'package:flutter_photography/models/Student.dart';
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
  bool _isTextFieldVisible = false;
  final _testList = [
    'Test Item 1',
    'Test Item 2',
    'Test Item 3',
    'Test Item 4',
  ];

  final stdBloc = StudentBloc();
  Future<List<Attendence>>? futureList;
  // Future<List<Student>>? studentList;

  TextEditingController myController2 = TextEditingController();
  List<Student>? myList;
  String current_id = "-1";

  @override
  void initState() {
    // myController2.addListener(_printLatestValue);
    getStringList();
    futureList = fetchStdAttendence();
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

  void getStdAttendList() async {
    var tempList1 = fetchStdAttendence();
    // Or use setState to assign the tempList to myList
    futureList = tempList1;
  }

  void getStringList() async {
    var tempList = await fetchStdList();
    // Or use setState to assign the tempList to myList
    myList = tempList;
  }

  // mocking a future
  Future<List> fetchSimpleData() async {
    await Future.delayed(Duration(milliseconds: 2000));

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
                    onPressed: () async {
                      setState(() {
                        String textContent = myController2.text;
                        current_id =
                            textContent.substring(0, textContent.indexOf(' '));
                        getStdAttendList();
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
                          return ListTile(
                              onTap: () {
                                setState(() {
                                  _addnote(item.id!);
                                });
                              },
                              title: Text(item.date + "    " + item.note));
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
  _addnote(int id) {
    print(id);
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
