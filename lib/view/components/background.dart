// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  final Widget child;

  final String topImage, bottomImage;

  const Background(
      {Key? key,
      required this.child,
      this.topImage = "assets/images/main_top.png",
      this.bottomImage = "assets/images/login_bottom.png"})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        body: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Positioned(
                  top: 0,
                  left: 0,
                  child: Image.asset(
                    topImage,
                    width: 120,
                  )),
              SafeArea(child: child)
            ],
          ),
        ));
  }
}
