import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';

class WelcomeImage extends StatelessWidget {
  final String topImage;
  final String topTitle;

  const WelcomeImage({
    Key? key,
    required this.topImage,
    required this.topTitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          topTitle.toUpperCase(),
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        // SizedBox(height: defaultPadding * 2),
        Row(
          children: [
            Spacer(),
            Expanded(
              flex: 6,
              child: SvgPicture.asset(
                topImage,
                width: 400,
                height: 400,
              ),
              // AssetImage(topImage)
            ),
            Spacer()
          ],
        ),
        // SizedBox(height: defaultPadding)
      ],
    );
  }
}
