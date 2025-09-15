import 'package:flutter/material.dart';

import 'colors.dart';

import 'screens/fish_list_screen.dart';
import 'screens/home_screen.dart';
import 'screens/map_screen.dart';
import 'screens/photo_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

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
          children: const[
            FishListScreen(),
            HomeScreen(),
            MapScreen()
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: const FloatingActionButton(
          onPressed: (null),
          tooltip: 'Take photo',
          child: Icon(Icons.camera_alt),
        ),
        bottomNavigationBar: BottomAppBar(
          color: blueFishColorScheme.primary,
          shape: const CircularNotchedRectangle(),
          notchMargin: 5.0,
          clipBehavior: Clip.antiAlias,
          child: SizedBox(
            height: kBottomNavigationBarHeight,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.storage, color: selectedIndex == 0 ? Colors.white : Colors.white54,),
                  onPressed: () => onItemTapped(0),
                ),
                IconButton(
                  icon: Icon(Icons.home, color: selectedIndex == 1 ? Colors.white : Colors.white54,),
                  onPressed: () => onItemTapped(1),
                ),
                IconButton(
                  icon: Icon(Icons.map, color: selectedIndex == 2 ? Colors.white : Colors.white54,),
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