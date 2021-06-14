import 'package:files/pages/MediaPage/sliver_appbar.dart';
import 'package:files/provider/MyProvider.dart';
import 'package:files/utilities/DataModel.dart';
import 'package:files/utilities/MyColors.dart';
import 'package:files/utilities/OperationsUtils.dart';
import 'package:files/widgets/FloatingActionButton.dart';
import 'package:files/widgets/ListBuilder.dart';
import 'package:files/widgets/MyAppBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';
import './MediaStorageInfo.dart';
import '../../provider/MyProvider.dart';
import '../../provider/OperationsProvider.dart';
import 'MediaFiles.dart';

// define the work to do
// issues that need to be fixed
// this is what needs to be fixed at priority file observer crashing the app...
// photos should notify whenever a change happen...
// file operations should happen in a service..
// add options to encrypt and decrypt files
// add feature to open pdf zip
// add a video player
// create a music player ui
// features to add fingerpring and face authentication
// remove the lags
//

class MediaPage extends StatefulWidget {
  final Data storage;
  final int spaceInfoIndex;

  MediaPage({this.storage, this.spaceInfoIndex});

  @override
  _MediaPageState createState() => _MediaPageState();
}

class _MediaPageState extends State<MediaPage>
    with SingleTickerProviderStateMixin {
  ScrollController _scrollController;
  ScrollController _listViewController;
  AnimationController _controller;
  Animation animation;
  Animation opacity;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );
    animation = Tween<Offset>(
      begin: Offset(0, -1.0),
      end: Offset(0.0, 0.0),
    ).animate(_controller);
    opacity = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);

    _scrollController = ScrollController();
    _listViewController = ScrollController();
    _listViewController.addListener(_scrollListener);
  }

  _scrollListener() {
    final provider = Provider.of<Operations>(context, listen: false);
    var direction = _listViewController.position.userScrollDirection;
    provider.scrolledPixels = _listViewController.position.pixels;
    if (direction == ScrollDirection.forward) {
      provider.scrollListener(6, true);
    } else if (direction == ScrollDirection.reverse) {
      provider.scrollListener(0, false);
    }
  }

  @override
  void dispose() {
    print('mediapage disposed');
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    _listViewController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    final provider = Provider.of<MyProvider>(context, listen: false);
    final storage = widget.storage;

    List<Widget> children = <Widget>[
      AnimationConfiguration.synchronized(
        child: FadeInAnimation(
          child: MediaStorageInfo(),
        ),
      ),
      // MediaStorageInfo(),
      MediaFiles(),
      DirectoryLister(path: storage.path),
    ];

    // final mediaStorage = Sliver(
    //   child: AnimationConfiguration.synchronized(
    //     child: FadeInAnimation(
    //       child: MediaStorageInfo(),
    //     ),
    //   ),
    // );

    final listView = ListView.builder(
      shrinkWrap: true,
      controller: _listViewController,
      physics: BouncingScrollPhysics(),
      itemCount: children.length,
      itemBuilder: (context, index) => children[index],
    );

    // final selector = Selector<MyProvider, Data>(
    //   selector: (context, provider) => provider.data[provider.currentPage],
    //   shouldRebuild: (previous, next) =>
    //       previous.currentPath != next.currentPath,
    //   builder: (context, value, child) {
    //     print(value.path);
    //     print(value.currentPath);
    //     return value.path == value.currentPath
    //         ? listView
    //         : DirectoryLister(
    //             path: value.currentPath,
    //             scrollController: _listViewController,
    //           );
    //   },
    // );

    final consumer = Consumer<MyProvider>(
      builder: (context, value, child) {
        return storage.path == storage.currentPath
            ? listView
            : DirectoryLister(
                path: storage.currentPath,
                scrollController: _listViewController,
              );
      },
    );

    final WillPopScope willPopScope = WillPopScope(
      onWillPop: () => provider.onGoBack(context),
      child: consumer,
    );

    final csv = CustomScrollView(
      controller: _scrollController,
      scrollDirection: Axis.vertical,
      physics: NeverScrollableScrollPhysics(),
      slivers: [
        MySliverAppBar(),
        SliverFillRemaining(child: willPopScope),
      ],
    );

    return AnnotatedRegion(
      value: AppbarUtils.systemUiOverylay(MyColors.darkGrey),
      child: Scaffold(
        body: SafeArea(child: csv),
        backgroundColor: Colors.white,
        bottomNavigationBar: OperationsUtils.bottomNavigation(),
        floatingActionButton: FAB(),
      ),
    );
  }
}
