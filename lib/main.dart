import 'package:flutter/material.dart';

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

  final List<Widget> widgetOptions = const [
    FishListScreen(),
    HomeScreen(),
    MapScreen(),
    PhotoScreen(),
  ];

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple)
      ),
      title: 'WildNote',
      home: Scaffold(
        bottomNavigationBar: BottomAppBar(
          shape: CircularNotchedRectangle(),
          color: Theme.of(context).colorScheme.primary,
        ),
        floatingActionButton: const FloatingActionButton(
          onPressed: (null),
          tooltip: 'Take photo',
          child: Icon(Icons.camera_alt,),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }
}
