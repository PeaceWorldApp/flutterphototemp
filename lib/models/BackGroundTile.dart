import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_photography/constants.dart';

class BackGroundTile extends StatelessWidget {
  final Color backgroundColor;
  // final IconData icondata;
  final String title;

  // const BackGroundTile({this.backgroundColor, this.icondata, this.title});
  const BackGroundTile({required this.backgroundColor, required this.title});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: backgroundColor,
      child: SizedBox(
        width: 300,
        height: 100,
        child: Center(
            child: Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 25
                ),
        )),
      ),
      // child: Icon(icondata, color: Colors.white),
    );
  }
}
