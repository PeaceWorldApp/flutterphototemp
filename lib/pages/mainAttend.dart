import 'package:flutter/material.dart';
import 'package:flutter_photography/Database.dart';
import 'package:flutter_photography/constants.dart';
import 'package:flutter_photography/data/AttendBloc.dart';
import 'package:flutter_photography/data/DatabaseBloc.dart';
import 'package:flutter_photography/ClientModel.dart';

import 'dart:math' as math;

import 'package:flutter_photography/data/StudentBloc.dart';
import 'package:flutter_photography/main.dart';
import 'package:flutter_photography/models/Attendence.dart';
import 'package:flutter_photography/models/Student.dart';
import 'package:flutter_photography/pages/MainStd.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// void main() => runApp(new MyApp());

class MainAttend extends StatelessWidget {
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
      home: new MyAttend(title: 'Attedance Today'),
      // routes: routes,
    );
  }
}

class MyAttend extends StatefulWidget {
  MyAttend({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyAttendState createState() => new _MyAttendState();
}

class _MyAttendState extends State<MyAttend> {
  // int _counter = 0;

  // void _incrementCounter() {
  //   Navigator.pushNamed(context, MyItemsPage.routeName);
  // }

  final attBloc = AttendBloc();
  final stdBloc = StudentBloc();
  String currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

  Future<List<Attendence>>? futureList;
  Future<List<Student>>? studentList;

  Future<List<Attendence>> fetchList() async {
    return Future.delayed(Duration(seconds: 1), () async {
      await attBloc.addCheck(currentDate);
      return await DBProvider.db.getAllAttendences(currentDate);
    });
  }

  Future<List<Student>> fetchStdList() async {
    return Future.delayed(Duration(seconds: 1), () async {
      return await DBProvider.db.getAllStudents();
    });
  }

  @override
  void initState() {
    futureList = fetchList();
    super.initState();
  }

  @override
  void dispose() {
    attBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // getLength();
    // futureList = fetchList();
    // var button = new IconButton(
    //     icon: new Icon(Icons.access_alarm), onPressed: _onButtonPressed);
    return new Scaffold(
        appBar: new AppBar(
          title: new Text(currentDate),
        ),
        body: StreamBuilder<List<Attendence>>(
          stream: futureList!.asStream(),
          builder:
              (BuildContext context, AsyncSnapshot<List<Attendence>> snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (BuildContext context, int index) {
                  Attendence item = snapshot.data![index];
                  return Dismissible(
                    key: UniqueKey(),
                    background: Container(color: Colors.red),
                    onDismissed: (direction) {
                      // attBloc.delete(item.id!);
                      attBloc.update(item.id!);
                    },
                    child: ListTile(
                      title: Text(stdBloc.byId(item.stdid)!.firstName),
                      // +
                      //     " " +
                      //     item.status.toString()),
                      leading: Text(item.id.toString()),
                    ),
                  );
                },
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
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
        )
        // new FloatingActionButton(
        //   onPressed: _onButtonPressed,
        //   tooltip: 'Increment',
        //   child: new Icon(Icons.add),
        // ),
        );
  }

//for reload
  void _onButtonPressed() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MainStd(title: "MainStudent"))).then((value) {
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

// class MyItemsPage extends StatefulWidget {
//   MyItemsPage({Key? key, required this.title}) : super(key: key);

//   static const String routeName = "/MyItemsPage";

//   final String title;

//   @override
//   _MyItemsPageState createState() => new _MyItemsPageState();
// }

/// // 1. After the page has been created, register it with the app routes
/// routes: <String, WidgetBuilder>{
///   MyItemsPage.routeName: (BuildContext context) => new MyItemsPage(title: "MyItemsPage"),
/// },
///
/// // 2. Then this could be used to navigate to the page.
/// Navigator.pushNamed(context, MyItemsPage.routeName);
///

// class _MyItemsPageState extends State<MyItemsPage> {
//   @override
//   Widget build(BuildContext context) {
//     var button = new IconButton(
//         icon: new Icon(Icons.arrow_back), onPressed: _onButtonPressed);
//     return new Scaffold(
//       appBar: new AppBar(
//         title: new Text(widget.title),
//       ),
//       body: new Container(
//         child: new Column(
//           children: <Widget>[new Text('Item1'), new Text('Item2'), button],
//         ),
//       ),
//       floatingActionButton: new FloatingActionButton(
//         onPressed: _onFloatingActionButtonPressed,
//         tooltip: 'Add',
//         child: new Icon(Icons.add),
//       ),
//     );
//   }

//   void _onFloatingActionButtonPressed() {}

//   void _onButtonPressed() {
//     Navigator.pop(context);
//   }
// }

// void main() => runApp(MaterialApp(home: MyApp()));

// class MyApp extends StatefulWidget {
//   const MyApp({super.key});

//   @override
//   _MyAppState createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   // data for testing
//   // List<Client> testClients = [
//   //   Client(firstName: "Raouf", lastName: "Rahiche", blocked: false),
//   //   Client(firstName: "Zaki", lastName: "oun", blocked: true),
//   //   Client(firstName: "oussama", lastName: "ali", blocked: false),
//   // ];
//   List<Student> testStd = [
//     Student(firstName: "Raouf", lastName: "Rahiche", note: ''),
//     Student(firstName: "Zaki", lastName: "oun", note: ''),
//     Student(firstName: "oussama", lastName: "ali", note: ''),
//   ];

//   // final bloc = ClientsBloc();
//   final stdBloc = StudentBloc();

//   @override
//   void dispose() {
//     stdBloc.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Flutter SQLite")),
//       body: ElevatedButton(
//         onPressed: () {
//           // Navigate to the second screen when tapped.
//           Navigator.of(context).pushReplacement(
//               MaterialPageRoute(builder: (context) => MainStd()));
//         },
//         child: const Text('Launch screen'),
//       ),
//       // body: StreamBuilder<List<Student>>(
//       //   stream: stdBloc.clients,
//       //   builder: (BuildContext context, AsyncSnapshot<List<Student>> snapshot) {
//       //     if (snapshot.hasData) {
//       //       return ListView.builder(
//       //         itemCount: snapshot.data!.length,
//       //         itemBuilder: (BuildContext context, int index) {
//       //           Student item = snapshot.data![index];
//       //           return Dismissible(
//       //             key: UniqueKey(),
//       //             background: Container(color: Colors.red),
//       //             onDismissed: (direction) {
//       //               stdBloc.delete(item.id!);
//       //             },
//       //             child: ListTile(
//       //               title: Text(item.lastName),
//       //               leading: Text(item.id.toString()),
//       //             ),
//       //           );
//       //         },
//       //       );
//       //     } else {
//       //       return Center(child: CircularProgressIndicator());
//       //     }
//       //   },
//       // ),

//       // floatingActionButton: FloatingActionButton(
//       //   child: Icon(Icons.add),
//       //   onPressed: () async {
//       //     Navigator.of(context).pushReplacement(
//       //         MaterialPageRoute(builder: (context) => MainStd()));
//       //     // Student rnd = testStd[math.Random().nextInt(testStd.length)];
//       //     // stdBloc.add(rnd);
//       //   },
//       // ),
//     );
//   }
// }


// class MyListView extends StatelessWidget {
//   final Future<List<String>> futureItems;

//   MyListView({required this.futureItems});

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<List<String>>(
//       future: futureItems,
//       builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return Center(
//             child: CircularProgressIndicator(),
//           );
//         } else if (snapshot.hasError) {
//           return Center(
//             child: Text('Error loading items'),
//           );
//         } else {
//           List<String> items = snapshot.data!;
//           return ListView.builder(
//             itemCount: items.length,
//             itemBuilder: (BuildContext context, int index) {
//               return ListTile(
//                 title: Text(items[index]),
//               );
//             },
//           );
//         }
//       },
//     );
//   }
// }