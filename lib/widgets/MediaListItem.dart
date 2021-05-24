import 'dart:io';

import 'package:files/provider/OperationsProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../sizeConfig.dart';

class MediaListItem extends StatefulWidget {
  final Color selectedColor;
  final String title;
  final Color textColor;
  final Widget description;
  final String currentPath;
  final Function ontap;
  final Function onLongPress;
  final Widget leading;
  final int index;
  final FileSystemEntity data;

  MediaListItem({
    this.index,
    this.title,
    this.description,
    this.currentPath,
    this.ontap,
    this.onLongPress,
    this.leading,
    this.data,
    this.selectedColor,
    this.textColor,
  });

  @override
  _MediaListItemState createState() => _MediaListItemState();
}

class _MediaListItemState extends State<MediaListItem> {
  Widget build(BuildContext context) {
    final Widget padding = Padding(
      padding: EdgeInsets.symmetric(
        horizontal: Responsive.width(4),
        vertical: Responsive.height(0.6),
      ),
      child: Row(
        children: <Widget>[
          widget.leading,
          _Item(
            description: widget.description,
            title: widget.title,
            titleColor: widget.textColor,
          ),
        ],
      ),
    );

    return InkWell(
      onTap: widget.ontap,
      onLongPress: widget.onLongPress,
      child: Consumer<Operations>(
        builder: (context, provider, child) {
          final selectedMedia = provider.selectedMedia;
          final isSelected = selectedMedia.contains(widget.data);
          final color = isSelected ? widget.selectedColor : Colors.transparent;
          return Container(
            color: color,
            child: child,
          );
        },
        child: padding,
      ),
    );
  }
}

class _Item extends StatelessWidget {
  final Widget description;
  final String title;
  final Color titleColor;
  const _Item({this.description, this.title, this.titleColor});
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(left: Responsive.width(4.0)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: TextStyle(
                fontSize: 1.9 * Responsive.textMultiplier,
                fontWeight: FontWeight.w500,
                color: titleColor ?? Colors.grey[800],
              ),
            ),
            SizedBox(height: Responsive.height(0.5)),
            description,
          ],
        ),
      ),
    );
  }
}
