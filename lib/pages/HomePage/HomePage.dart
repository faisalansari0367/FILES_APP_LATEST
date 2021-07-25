import 'package:files/pages/HomePage/widgets/HorizontalTabs.dart';
import 'package:files/pages/HomePage/widgets/circleChartAndFilePercent.dart';
import 'package:files/provider/MyProvider.dart';
import 'package:files/provider/StoragePathProvider.dart';
import 'package:files/widgets/FloatingActionButton.dart';
import 'package:files/widgets/MyAppBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';
import '../../sizeConfig.dart';

class HomePage extends StatelessWidget {
  // double sizing;
  Future<void> _onRefresh(context) async {
    await Provider.of<StoragePathProvider>(context, listen: false).onRefresh();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MyProvider>(context, listen: false);
    print(provider.data.toString());
    final children = <Widget>[
      Padding(
        padding: EdgeInsets.only(
          // top: 6 * Responsive.imageSizeMultiplier,
          // left: 6 * Responsive.imageSizeMultiplier,
          left: 6 * Responsive.widthMultiplier,
          right: 6 * Responsive.imageSizeMultiplier,
        ),
        child: bigText(
          title: 'My Files',
          color: Colors.grey[500],
          height: 6,
          // iconName: Icons.more_horiz,
        ),
      ),
      SizedBox(height: 4 * Responsive.heightMultiplier),
      CircleChartAndFilePercent(),
      SizedBox(height: 4 * Responsive.heightMultiplier),
      HorizontalTabs(),
      SizedBox(height: 4 * Responsive.heightMultiplier),
      Padding(
        padding: EdgeInsets.only(
          right: Responsive.width(6),
          left: Responsive.width(6),
          bottom: Responsive.height(2),
        ),
        child: bigText(
          height: 1,
          title: 'Latest Files',
          iconName: Icons.more_horiz,
          color: Colors.grey[500],
        ),
      ),
      // Container(
      //   margin: EdgeInsets.all(Responsive.width(8)),
      //   height: Responsive.width(15),
      //   decoration: BoxDecoration(
      //     color: Color(0xff01cd98),
      //     borderRadius: BorderRadius.circular(22),
      //   ),
      //   child: GestureDetector(
      //     onTap: () {
      //       final route = MaterialPageRoute(builder: (context) => Apps());
      //       Navigator.push(context, route);
      //     },
      //     child: Row(
      //       children: [
      //         SizedBox(width: 20),
      //         Icon(
      //           Icons.app_settings_alt_rounded,
      //           color: Colors.white,
      //           size: 35,
      //         ),
      //         SizedBox(width: 20),
      //         Text(
      //           'Applications',
      //           style: TextStyle(color: Colors.white, fontSize: 20),
      //         ),
      //       ],
      //     ),
      //   ),
      // ),
      // Padding(
      //   padding: EdgeInsets.only(
      //     right: Responsive.width(6),
      //     left: Responsive.width(6),
      //     bottom: Responsive.height(2),
      //   ),
      //   child: bigText(
      //     height: 1,
      //     title: "Latest Files",
      //     iconName: Icons.more_horiz,
      //     color: Colors.grey[500],
      //   ),
      // ),
    ];

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: AppbarUtils.systemUiOverylay(backgroundColor: Colors.white),
      child: Scaffold(
        floatingActionButton: FAB(),
        // backgroundColor: Colors.black,
        appBar: MyAppBar(
          backgroundColor: Colors.white,
          iconData: Icons.menu,
          bottomNavBar: false,
        ),
        body: Container(
          color: Colors.white,
          child: RefreshIndicator(
            onRefresh: () => _onRefresh(context),
            child: ListView(
              physics: BouncingScrollPhysics(),
              children: AnimationConfiguration.toStaggeredList(
                duration: const Duration(milliseconds: 400),
                childAnimationBuilder: (widget) => SlideAnimation(
                  horizontalOffset: 50.0,
                  child: FadeInAnimation(
                    delay: Duration(milliseconds: 80),
                    child: widget,
                  ),
                ),
                children: children,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Widget bigText({height, title, iconName, color}) {
  return Row(
    children: <Widget>[
      SizedBox(
        height: height * Responsive.heightMultiplier,
      ),
      Text(
        title,
        style: TextStyle(fontSize: 3.4 * Responsive.textMultiplier),
      ),
      Spacer(),
      if (iconName != null) Icon(
              Icons.more_horiz,
              size: 6 * Responsive.imageSizeMultiplier,
              color: color,
            ) else Container(height: 0, width: 0),
    ],
  );
}
