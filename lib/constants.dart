import 'package:flutter/material.dart';
import 'package:flutter_photography/models/BackGroundTile.dart';

const kPrimaryColor = Color(0xFF366CF6);
const kPrimaryColor2 = Color(0xFF6F35A5);
const kPrimaryLightColor = Color(0xFFF1E6FF);
const kSecondaryColor = Color(0xFFF5F6FC);
const kBgLightColor = Color(0xFFF2F4FC);
const kBgDarkColor = Color(0xFFEBEDFA);
const kBadgeColor = Color(0xFFEE376E);
const kGrayColor = Color(0xFF8793B2);
const kTitleTextColor = Color(0xFF30384D);
const kTextColor = Color(0xFF4D5875);
const kHintTextColor = Colors.black45;

const kDefaultPadding = 20.0;
const double defaultPadding = 16.0;
const String topImage = "assets/icons/chat.svg";
const String loginImage = "assets/icons/login.svg";
const String productBnImage = "assets/icons/probn.svg";

const List<Widget> listTile = <Widget>[
  BackGroundTile(
      backgroundColor: Color.fromARGB(255, 15, 5, 101), title: 'Students'),
  BackGroundTile(
      backgroundColor: Color.fromARGB(255, 16, 122, 96), title: 'Attendance'),
  BackGroundTile(backgroundColor: Colors.pink, title: 'Analysist'),
  BackGroundTile(
      backgroundColor: Color.fromARGB(255, 228, 136, 86), title: 'Search')
];

// const List<Widget> listTile = <Widget>[
//     BackGroundTile(backgroundColor: Colors.red, icondata: Icons.home),
//     BackGroundTile(backgroundColor: Colors.orange, icondata: Icons.ac_unit),
//     BackGroundTile(backgroundColor: Colors.pink, icondata: Icons.landscape),
//     BackGroundTile(backgroundColor: Colors.green, icondata: Icons.portrait),
//     BackGroundTile(
//         backgroundColor: Colors.deepPurpleAccent, icondata: Icons.music_note),
//     BackGroundTile(backgroundColor: Colors.blue, icondata: Icons.access_alarms),
//     BackGroundTile(
//         backgroundColor: Colors.indigo, icondata: Icons.satellite_outlined),
//     BackGroundTile(backgroundColor: Colors.cyan, icondata: Icons.search_sharp),
//     BackGroundTile(
//         backgroundColor: Colors.yellowAccent, icondata: Icons.adjust_rounded),
//     BackGroundTile(
//         backgroundColor: Colors.deepOrange, icondata: Icons.attach_money),
//   ];

