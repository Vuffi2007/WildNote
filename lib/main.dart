import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:wild_note/fish.dart';

import 'colors.dart';
import 'dart:async';

import 'screens/fish_list_screen.dart';
import 'screens/home_screen.dart';
import 'screens/map_screen.dart';
import 'screens/photo_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(FishAdapter());

  await Hive.openBox<Fish>('fishBox');

  final cameras = await availableCameras();

  final firstCamera = cameras.first;

  runApp(MyApp(camera: firstCamera));
}

class MyApp extends StatefulWidget {
  final CameraDescription camera;

  const MyApp({super.key, required this.camera});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int selectedIndex = 0;
  final PageController _pageController = PageController();

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
    _pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "WildNote",
      theme: ThemeData(colorScheme: blueFishColorScheme),
      home: Scaffold(
        body: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              selectedIndex = index;
            });
          },
          children: [FishListScreen(), HomeScreen(), MapScreen()],
        ),
        floatingActionButton: selectedIndex == 1
            ? Builder(
                builder: (innerContext) => SizedBox(
                  width: 68, // make the FAB bigger
                  height: 68,
                  child: FloatingActionButton(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        width: 3,
                        color: blueFishColorScheme.primary,
                      ),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    onPressed: () {
                      Navigator.of(innerContext).push(
                        MaterialPageRoute(
                          builder: (innerContext) =>
                              PhotoScreen(camera: widget.camera),
                        ),
                      );
                    },
                    tooltip: 'Add new fish',
                    child: Icon(
                      Icons.add,
                      size: 30,
                    ), // bigger icon to match new size
                  ),
                ),
              )
            : null,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomAppBar(
          color: blueFishColorScheme.primary,
          clipBehavior: Clip.antiAlias,
          child: SizedBox(
            height: 30,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.storage,
                    color: selectedIndex == 0 ? Colors.white : Colors.white54,
                    size: 28,
                  ),
                  onPressed: () => onItemTapped(0),
                ),
                IconButton(
                  icon: Icon(
                    Icons.home,
                    color: selectedIndex == 1
                        ? Colors.transparent
                        : Colors.white54,
                    size: 28,
                  ),
                  splashColor: Colors.transparent, // removes ripple effect
                  highlightColor:
                      Colors.transparent, // removes the gray highlight
                  onPressed: selectedIndex == 1 ? null : () => onItemTapped(1),
                ),
                IconButton(
                  icon: Icon(
                    Icons.map,
                    color: selectedIndex == 2 ? Colors.white : Colors.white54,
                    size: 28,
                  ),
                  onPressed: () => onItemTapped(2),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
