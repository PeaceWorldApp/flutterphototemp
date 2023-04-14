// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_photography/Database.dart';
import 'package:flutter_photography/constants.dart';
import 'package:flutter_photography/data/FeeBloc.dart';
import 'package:flutter_photography/data/StudentBloc.dart';
import 'package:flutter_photography/models/Fee.dart';
import 'package:flutter_photography/pages/mainListStd.dart';
import 'package:flutter_photography/models/Student.dart';
import 'package:flutter_photography/view/components/background.dart';
import 'package:flutter_photography/view/welcome_image.dart';

class MainFee extends StatefulWidget {
  const MainFee(
      {Key? key,
      required this.title,
      required this.attid,
      required this.dateAtt,
      required this.money})
      : super(key: key);

  static const String routeName = "/MainFee";

  final String title;
  final int attid;
  final String dateAtt;
  final String money;
  @override
  _MainFeeState createState() => _MainFeeState(
      stdName: title, attid: attid, dateAtt: dateAtt, money: money);
}

class _MainFeeState extends State<MainFee> {
  _MainFeeState(
      {Key? key,
      required this.stdName,
      required this.attid,
      required this.dateAtt,
      required this.money});

  void _onButtonPressed() {
    Navigator.pop(context);
  }

  final String stdName;
  final int attid;
  final String dateAtt;
  final String money;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Background(
        child: SingleChildScrollView(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ListTile(
              title: Center(
                child: Text(
                  stdName.toUpperCase(),
                  style: TextStyle(
                    fontSize: 40,
                    foreground: Paint()
                      ..style = PaintingStyle.stroke
                      ..strokeWidth = 2
                      ..color = Colors.blue[700]!,
                  ),
                ),
              ),
              // tileColor: Colors.blue[200],
            ),
            SizedBox(
              height: defaultPadding * 0.75,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 350,
                  child: FeeForm(attid: attid, dateAtt: dateAtt, money: money),
                )
              ],
            )
          ],
        )),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: _onButtonPressed,
        child: new Icon(Icons.backspace_sharp),
      ),
    );
  }
}

class FeeForm extends StatefulWidget {
  const FeeForm(
      {Key? key,
      required this.attid,
      required this.dateAtt,
      required this.money})
      : super(key: key);

  final int attid;
  final String dateAtt;
  final String money;
  @override
  State<StatefulWidget> createState() =>
      _FeeFormState(attid: attid, dateAtt: dateAtt, money: money);
}

class _FeeFormState extends State<FeeForm> {
  List textFieldsCatString = [
    "", //fee
    "", // note
    "", //attendence_id
  ];
  _FeeFormState(
      {Key? key,
      required this.attid,
      required this.dateAtt,
      required this.money});

  final int attid;
  int feeiD = -1;
  final String dateAtt;
  final String money;

  final _feeCatKey = GlobalKey<FormState>();
  final _noteCatKey = GlobalKey<FormState>();
  final _attendDateCatKey = GlobalKey<FormState>();
  final feeBloc = FeeBloc();

  @override
  void dispose() {
    feeBloc.dispose();
    super.dispose();
  }

  // final db = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    if (money.length > 0) {
      return Form(
          child: Column(
        children: [
          buildTextField("Money", Icons.monetization_on_outlined, size,
              (value) {
            if (value.length <= 0) {
              buildSnackError("Invalid length or empty", context, size);
              return "";
            }
          }, _feeCatKey, 0, money, true),
          SizedBox(
            height: defaultPadding * 0.75,
          ),
          buildTextField("Note", Icons.note_alt, size, (value) {
            if (value.length <= 0) {
              buildSnackError("Invalid length or empty", context, size);
              return "";
            }
          }, _noteCatKey, 1, "", true),
          SizedBox(
            height: defaultPadding * 0.75,
          ),
          buildTextField("Date", Icons.date_range, size, (value) {
            if (value.length <= 0) {
              buildSnackError("Invalid length or empty", context, size);
              return "";
            }
          }, _attendDateCatKey, 2, dateAtt, false),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Hero(
                tag: "add_std_1",
                child: ElevatedButton(
                  child: Text("Update".toUpperCase()),
                  onPressed: () async {
                    // buildSnackError("Sendiing", context, size);
                    if (_feeCatKey.currentState!.validate()) {
                      if (_noteCatKey.currentState!.validate()) {
                        Fee f = new Fee(
                            money: int.parse(textFieldsCatString[0]),
                            note: textFieldsCatString[1]);
                        feeBloc.edit(f);
                        print("Edit fee  " + f.id.toString());
                      }
                    }
                  },
                ),
              ),
              SizedBox(
                width: defaultPadding * 0.5,
              ),
              Hero(
                tag: "reset",
                child: ElevatedButton(
                  child: Text("Reset".toUpperCase()),
                  onPressed: () {
                    _feeCatKey.currentState!.reset();
                    _noteCatKey.currentState!.reset();
                  },
                ),
              ),
            ],
          ),
        ],
      ));
    } else {
      return Form(
          child: Column(
        children: [
          buildTextField("Money", Icons.monetization_on_outlined, size,
              (value) {
            if (value.length <= 0) {
              buildSnackError("Invalid length or empty", context, size);
              return "";
            }
          }, _feeCatKey, 0, "", true),
          SizedBox(
            height: defaultPadding * 0.75,
          ),
          buildTextField("Note", Icons.note_alt, size, (value) {
            if (value.length <= 0) {
              buildSnackError("Invalid length or empty", context, size);
              return "";
            }
          }, _noteCatKey, 1, "", true),
          SizedBox(
            height: defaultPadding * 0.75,
          ),
          buildTextField("Date", Icons.date_range, size, (value) {
            if (value.length <= 0) {
              buildSnackError("Invalid length or empty", context, size);
              return "";
            }
          }, _attendDateCatKey, 2, dateAtt, false),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Hero(
                tag: "add_std_1",
                child: ElevatedButton(
                  child: Text("Add".toUpperCase()),
                  onPressed: () async {
                    // buildSnackError("Sendiing", context, size);
                    if (_feeCatKey.currentState!.validate()) {
                      if (_noteCatKey.currentState!.validate()) {
                        Fee f = new Fee(
                            money: int.parse(textFieldsCatString[0]),
                            note: textFieldsCatString[1]);
                        feeBloc.add(f, attid);
                        print("Add fee  " + f.money.toString());
                      }
                    }
                  },
                ),
              ),
              SizedBox(
                width: defaultPadding * 0.5,
              ),
              Hero(
                tag: "reset",
                child: ElevatedButton(
                  child: Text("Reset".toUpperCase()),
                  onPressed: () {
                    _feeCatKey.currentState!.reset();
                    _noteCatKey.currentState!.reset();
                  },
                ),
              ),
            ],
          ),
        ],
      ));
    }
  }

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> buildSnackError(
      String error, BuildContext context, Size size) {
    return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: const Duration(seconds: 2),
      backgroundColor: Colors.black12,
      content: SizedBox(
          height: size.height * 0.02,
          child: Center(
            child: Text(error),
          )),
    ));
  }

  Widget buildTextField(
      String hintText,
      IconData icon,
      Size size,
      FormFieldValidator validator,
      Key key,
      int stringToEdit,
      String value,
      bool enabled) {
    return Form(
      key: key,
      child: TextFormField(
        initialValue: value != "" ? value : "",
        enabled: enabled,
        // keyboardType: (key == _emailKey) ? TextInputType.emailAddress : null,
        // textInputAction:
        //     (key == _emailKey) ? TextInputAction.next : TextInputAction.done,
        cursorColor: kPrimaryColor2,
        onSaved: (email) {},
        onChanged: (value) {
          setState(() {
            textFieldsCatString[stringToEdit] = value;
          });
        },
        // obscureText: password,
        validator: validator,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: kHintTextColor),
          prefixIcon: Padding(
            padding: const EdgeInsets.all(defaultPadding),
            child: Icon(
              icon,
              color: kPrimaryColor2,
            ),
          ),
        ),
      ),
    );
  }
}
