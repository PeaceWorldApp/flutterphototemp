import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_photography/data/Sample.dart';
import 'package:flutter_photography/helper/Colorsys.dart';
import 'package:flutter_photography/models/Post.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class SinglePost extends StatelessWidget {
  final Post post;
  final String image;

  SinglePost({Key key, this.post, this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(
                top: 70,
                bottom: 20,
                right: 20,
                left: 20,
              ),
              height: height / 2,
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20)),
                  image: DecorationImage(
                      fit: BoxFit.cover, image: AssetImage(image))),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: ClipRect(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                        child: Container(
                          width: 30.0,
                          height: 30.0,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color: Colors.black.withOpacity(0.2)),
                          child: Center(
                            child: Icon(
                              Icons.arrow_back_ios,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          CircleAvatar(
                            maxRadius: 25,
                            backgroundImage:
                                AssetImage(post.user.profilePicture),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            post.user.name,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600),
                          )
                        ],
                      ),
                      ClipRect(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                          child: Container(
                            width: 32.0,
                            height: 32.0,
                            padding: EdgeInsets.all(7),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: Colors.grey[600].withOpacity(0.1)),
                            child: Center(
                                child:
                                    Image.asset('assets/icons/download.png')),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Image.asset('assets/icons/location.png', scale: 1.0),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        "Kabul, Afghanistan",
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Colorsys.grey),
                      )
                    ],
                  ),
                  makeRelatedPhotos(post)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  //List of Cards with size
// List<StaggeredGridTile>  _cardTile = <StaggeredGridTile> [
//   StaggeredGridTile.count(
//       crossAxisCellCount: 2,
//       mainAxisCellCount: 2,
//       child: Tile(index: 0),
//     ),
//     StaggeredGridTile.count(
//       crossAxisCellCount: 2,
//       mainAxisCellCount: 1,
//       child: Tile(index: 1),
//     ),
//     StaggeredGridTile.count(
//       crossAxisCellCount: 1,
//       mainAxisCellCount: 1,
//       child: Tile(index: 2),
//     ),
//     StaggeredGridTile.count(
//       crossAxisCellCount: 1,
//       mainAxisCellCount: 1,
//       child: Tile(index: 3),
//     ),
//     StaggeredGridTile.count(
//       crossAxisCellCount: 4,
//       mainAxisCellCount: 2,
//       child: Tile(index: 4),
//     )
// ];

//List of Cards with color and icon
  List<Widget> _listTile = <Widget>[
    BackGroundTile(backgroundColor: Colors.red, icondata: Icons.home),
    BackGroundTile(backgroundColor: Colors.orange, icondata: Icons.ac_unit),
    BackGroundTile(backgroundColor: Colors.pink, icondata: Icons.landscape),
    BackGroundTile(backgroundColor: Colors.green, icondata: Icons.portrait),
    BackGroundTile(
        backgroundColor: Colors.deepPurpleAccent, icondata: Icons.music_note),
    BackGroundTile(backgroundColor: Colors.blue, icondata: Icons.access_alarms),
    BackGroundTile(
        backgroundColor: Colors.indigo, icondata: Icons.satellite_outlined),
    BackGroundTile(backgroundColor: Colors.cyan, icondata: Icons.search_sharp),
    BackGroundTile(
        backgroundColor: Colors.yellowAccent, icondata: Icons.adjust_rounded),
    BackGroundTile(
        backgroundColor: Colors.deepOrange, icondata: Icons.attach_money),
  ];

  Widget makeRelatedPhotos(Post post) {
    // return GridView.custom(
    //   gridDelegate: SliverQuiltedGridDelegate(
    //     crossAxisCount:2,
    //     mainAxisSpacing: 4,
    //     crossAxisSpacing: 1,
    //     repeatPattern: QuiltedGridRepeatPattern.inverted,
    //     pattern: [
    //       QuiltedGridTile(2, 2),
    //     ],
    //   ),
    //   childrenDelegate: SliverChildBuilderDelegate(
    //     (context, index) => Tile(index: index),
    //   ),
    //   // shrinkWrap: true,
    // );
    return StaggeredGrid.count(
      crossAxisCount: 4,
      mainAxisSpacing: 4,
      crossAxisSpacing: 4,
      children: [
        StaggeredGridTile.count(
          crossAxisCellCount: 2,
          mainAxisCellCount: 2,
          child:
              BackGroundTile(backgroundColor: Colors.red, icondata: Icons.home),
        ),
        StaggeredGridTile.count(
          crossAxisCellCount: 2,
          mainAxisCellCount: 1,
          child: _listTile.elementAt(1),
        ),
        StaggeredGridTile.count(
          crossAxisCellCount: 1,
          mainAxisCellCount: 1,
          child: _listTile.elementAt(2),
        ),
        StaggeredGridTile.count(
          crossAxisCellCount: 1,
          mainAxisCellCount: 1,
          child: _listTile.elementAt(3),
        ),
        StaggeredGridTile.count(
          crossAxisCellCount: 4,
          mainAxisCellCount: 2,
          child: _listTile.elementAt(4),
        ),
        StaggeredGridTile.count(
          crossAxisCellCount: 2,
          mainAxisCellCount: 2,
          child: _listTile.elementAt(5),
        ),
        StaggeredGridTile.count(
          crossAxisCellCount: 2,
          mainAxisCellCount: 1,
          child: _listTile.elementAt(6),
        ),
        StaggeredGridTile.count(
          crossAxisCellCount: 1,
          mainAxisCellCount: 1,
          child: _listTile.elementAt(7),
        ),
        StaggeredGridTile.count(
          crossAxisCellCount: 1,
          mainAxisCellCount: 1,
          child: _listTile.elementAt(8),
        ),
        StaggeredGridTile.count(
          crossAxisCellCount: 4,
          mainAxisCellCount: 2,
          child: _listTile.elementAt(9),
        ),
      ],
    );

    // return StaggeredGridView.countBuilder(
    //   crossAxisCount: 4,
    //   itemCount: post.relatedPhotos.length,
    //   mainAxisSpacing: 10.0,
    //   crossAxisSpacing: 10.0,
    //   physics: NeverScrollableScrollPhysics(),
    //   shrinkWrap: true,
    //   itemBuilder: (context, index) => Container(
    //     decoration: BoxDecoration(
    //         borderRadius: BorderRadius.circular(5),
    //         image: DecorationImage(
    //             fit: BoxFit.cover,
    //             image: AssetImage(post.relatedPhotos[index])),
    //         color: Colors.green),
    //   ),
    //   staggeredTileBuilder: (int index) =>
    //       StaggeredTile.count(2, index.isEven ? 3 : 2),
    // );
  }
}

class BackGroundTile extends StatelessWidget {
  final Color backgroundColor;
  final IconData icondata;

  BackGroundTile({this.backgroundColor, this.icondata});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: backgroundColor,
      child: Icon(icondata, color: Colors.white),
    );
  }
}

class Tile extends StatelessWidget {
  const Tile({
    Key key,
    this.index,
    this.extent,
    this.backgroundColor,
    this.bottomSpace,
  }) : super(key: key);

  final int index;
  final double extent;
  final double bottomSpace;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    final child = Container(
      color: backgroundColor ?? Colors.blue,
      height: extent,
      child: Center(
        child: CircleAvatar(
          minRadius: 20,
          maxRadius: 20,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          child: Text('$index', style: const TextStyle(fontSize: 20)),
        ),
      ),
    );

    if (bottomSpace == null) {
      return child;
    }

    return Column(
      children: [
        Expanded(child: child),
        Container(
          height: bottomSpace,
          color: Colors.green,
        )
      ],
    );
  }
}
