import 'package:flutter/material.dart';
import 'package:flutter_photography/Database.dart';
import 'package:flutter_photography/constants.dart';
import 'package:flutter_photography/data/DatabaseBloc.dart';
import 'package:flutter_photography/ClientModel.dart';

import 'dart:math' as math;

import 'package:flutter_photography/data/StudentBloc.dart';
import 'package:flutter_photography/main.dart';
import 'package:flutter_photography/models/Student.dart';
import 'package:flutter_photography/pages/MainStd.dart';

import 'package:flutter/material.dart';

// void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var routes = <String, WidgetBuilder>{
      MainStd.routeName: (BuildContext context) =>
          new MainStd(title: "MainStudent"),
    };
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: 'Flutter Demo Home Page'),
      routes: routes,
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // int _counter = 0;

  // void _incrementCounter() {
  //   Navigator.pushNamed(context, MyItemsPage.routeName);
  // }

  final stdBloc = StudentBloc();
  Future<List<Student>>? futureList;

  Future<List<Student>> fetchList() async {
    return Future.delayed(Duration(seconds: 2), () {
      return DBProvider.db.getAllStudents();
    });
  }

  @override
  void initState() {
    futureList = fetchList();
    super.initState();
  }

  @override
  void dispose() {
    stdBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // var button = new IconButton(
    //     icon: new Icon(Icons.access_alarm), onPressed: _onButtonPressed);
    return new Scaffold(
        appBar: new AppBar(
          title: new Text(widget.title),
        ),
        body: StreamBuilder<List<Student>>(
          stream: futureList!.asStream(),
          builder:
              (BuildContext context, AsyncSnapshot<List<Student>> snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (BuildContext context, int index) {
                  Student item = snapshot.data![index];
                  return Dismissible(
                    key: UniqueKey(),
                    background: Container(color: Colors.red),
                    onDismissed: (direction) {
                      stdBloc.delete(item.id!);
                    },
                    child: ListTile(
                      title: Text(item.firstName),
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
              onPressed: _onButtonPressed,
              tooltip: 'Increment',
              child: new Icon(Icons.add),
            ),
            SizedBox(
              height: defaultPadding * 1,
            ),
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
        futureList = fetchList();
      });
    });
  }

  void _onHomePressed() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()))
        .then((value) {
      setState(() {
        futureList = fetchList();
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
