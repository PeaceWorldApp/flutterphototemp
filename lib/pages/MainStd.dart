// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_photography/constants.dart';
import 'package:flutter_photography/data/StudentBloc.dart';
import 'package:flutter_photography/main.dart';
import 'package:flutter_photography/models/Student.dart';
import 'package:flutter_photography/view/components/background.dart';
import 'package:flutter_photography/view/welcome_image.dart';

class MainStd extends StatefulWidget {
  const MainStd({Key? key, required this.title}) : super(key: key);

  static const String routeName = "/MainStd";

  final String title;
  @override
  _MainStdState createState() => _MainStdState();
}

class _MainStdState extends State<MainStd> {
  void _onButtonPressed() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Background(
        child: SingleChildScrollView(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            WelcomeImage(topImage: productBnImage, topTitle: "Category"),
            SizedBox(
              height: defaultPadding * 0.75,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 350,
                  child: StdForm(),
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

    // Background(
    //   child: SingleChildScrollView(
    //       child: Column(
    //     mainAxisAlignment: MainAxisAlignment.start,
    //     crossAxisAlignment: CrossAxisAlignment.center,
    //     children: [
    //       WelcomeImage(topImage: productBnImage, topTitle: "Category"),
    //       SizedBox(
    //         height: defaultPadding * 0.75,
    //       ),
    //       Row(
    //         mainAxisAlignment: MainAxisAlignment.center,
    //         children: [
    //           SizedBox(
    //             width: 350,
    //             child: StdForm(),
    //           )
    //         ],
    //       )
    //     ],
    //   )),
    // );
  }
}

class StdForm extends StatefulWidget {
  const StdForm({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _StdFormState();
}

class _StdFormState extends State<StdForm> {
  List textFieldsCatString = [
    "", //first_name
    "", //last_name
    "", // note
  ];
  // final _idCatKey = GlobalKey<FormState>();
  final _fnameCatKey = GlobalKey<FormState>();
  final _lnameCatKey = GlobalKey<FormState>();
  final _noteCatKey = GlobalKey<FormState>();
  final stdBloc = StudentBloc();

  @override
  void dispose() {
    stdBloc.dispose();
    super.dispose();
  }

  // final db = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Form(
        child: Column(
      children: [
        buildTextField("First Name", Icons.numbers, size, (value) {
          if (value.length <= 0) {
            buildSnackError("Invalid length or empty", context, size);
            return "";
          }
        }, _fnameCatKey, 0),
        SizedBox(
          height: defaultPadding * 0.75,
        ),
        buildTextField("Last name", Icons.category, size, (value) {
          if (value.length <= 0) {
            buildSnackError("Invalid length or empty", context, size);
            return "";
          }
        }, _lnameCatKey, 1),
        SizedBox(
          height: defaultPadding * 0.75,
        ),
        buildTextField("Note", Icons.category, size, (value) {
          if (value.length <= 0) {
            buildSnackError("Invalid length or empty", context, size);
            return "";
          }
        }, _noteCatKey, 2),
        SizedBox(
          height: defaultPadding * 0.75,
        ),
        Hero(
            tag: "add_std",
            child: ElevatedButton(
              child: Text("Save".toUpperCase()),
              onPressed: () async {
                // buildSnackError("Sendiing", context, size);
                if (_fnameCatKey.currentState!.validate()) {
                  if (_lnameCatKey.currentState!.validate()) {
                    Student s = new Student(
                        firstName: textFieldsCatString[0],
                        lastName: textFieldsCatString[1],
                        note: textFieldsCatString[2]);
                    stdBloc.add(s);
                    // db.collection("category").add(cat).then(
                    //     (DocumentReference ref) => buildSnackError(
                    //         "Sendiing with id: ${ref.id}", context, size));
                  }
                }
              },
            ))
      ],
    ));
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

  Widget buildTextField(String hintText, IconData icon, Size size,
      FormFieldValidator validator, Key key, int stringToEdit) {
    return Form(
      key: key,
      child: TextFormField(
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
