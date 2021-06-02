import 'dart:io';

import 'package:files/utilities/MyColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

import '../sizeConfig.dart';
import 'MyDropDown.dart';
import 'Search.dart';
import 'package:path/path.dart' as p;

class AppbarUtils {
  static const duration = Duration(milliseconds: 100);
  static const splashRadius = 25.0;

  static SystemUiOverlayStyle systemUiOverylay(Color backgroundColor) =>
      SystemUiOverlayStyle(
        statusBarBrightness: Brightness.light,
        // systemNavigationBarDividerColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        // systemNavigationBarIconBrightness: Brightness.dark,
        statusBarColor: backgroundColor.withAlpha(248),
      );

  static IconButton searchIcon(BuildContext context) {
    return AppbarUtils.icon(
      context,
      Icon(Icons.search),
      () async => await showSearch(
        context: context,
        delegate: Search(),
      ),
    );
  }

  static IconButton backIcon(BuildContext context) {
    return AppbarUtils.icon(
      context,
      Icon(Icons.arrow_back),
      () => Navigator.pop(context),
    );
  }

  static IconButton icon(BuildContext context, Icon icon, Function onPressed) {
    return IconButton(
      splashRadius: splashRadius,
      color: Colors.grey[500],
      icon: icon,
      onPressed: onPressed,
    );
  }

  static Widget navigator(Function ontap, String path) {
    return Row(
      children: [
        InkWell(
          onTap: () => ontap(Directory(path)),
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.only(
              bottom: 10,
              top: 10,
              left: 5,
              right: 5,
            ),
            child: Text(
              p.basename(path).toUpperCase(),
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 1.7 * Responsive.textMultiplier,
              ),
            ),
          ),
        ),
        Icon(
          Icons.chevron_right,
          color: Colors.grey[400],
        ),
      ],
    );
  }
}

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Color backgroundColor;
  final IconData iconData;
  final bool menu;
  final bool bottomNavBar;
  // final StorageType storageType;
  const MyAppBar({
    this.backgroundColor,
    this.iconData,
    this.menu,
    this.bottomNavBar = false,
  });

  @override
  Size get preferredSize => Size.fromHeight(
      (bottomNavBar ? 12.36 : 6.36) * Responsive.heightMultiplier);

  @override
  Widget build(BuildContext context) {
    final color = backgroundColor ?? MyColors.darkGrey;
    return AppBar(
      systemOverlayStyle: AppbarUtils.systemUiOverylay(color),
      backgroundColor: color,
      leading: AppbarUtils.backIcon(context),
      elevation: 0.0,
      actions: [AppbarUtils.searchIcon(context), MyDropDown()],
      // bottom: bottomNavBar ? MyBottomAppBar() : null,
    );
  }
}
