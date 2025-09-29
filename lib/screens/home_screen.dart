import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:wild_note/fish.dart';
import 'package:wild_note/my_flutter_app_icons.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:wild_note/colors.dart';

import 'dart:io';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home Screen')),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<Fish>('fishBox').listenable(),
        builder: (context, Box<Fish> box, _) {
          if (box.isEmpty) {
            return const Center(child: Text('No catches yet'));
          }

          return ListView(
            children: [
              if (box.values.isNotEmpty) ...[
                // Heaviest fish
                _buildFishCard(
                  box.values.reduce(
                    (a, b) => (a.weight ?? 0) > (b.weight ?? 0) ? a : b,
                  ),
                  label: "Heaviest catch",
                ),

                // Longest fish
                _buildFishCard(
                  box.values.reduce(
                    (a, b) => (a.length ?? 0) > (b.length ?? 0) ? a : b,
                  ),
                  label: "Longest catch",
                ),

                // Most recent fish
                _buildFishCard(
                  box.values.reduce(
                    (a, b) => a.caughtOn.isAfter(b.caughtOn) ? a : b,
                  ),
                  label: "Most recent catch",
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}

Widget _buildFishCard(Fish fish, {String? label}) {
  return Card(
    color: blueFishColorScheme.surfaceContainerHigh,
    margin: const EdgeInsets.all(20.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              label,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.file(
              File(fish.imagePath),
              width: 120,
              height: 120,
              fit: BoxFit.cover,
            ),
            Expanded(
              child: ListTile(
                title: Text(fish.species),
                subtitle: RichText(
                  text: TextSpan(
                    children: [
                      WidgetSpan(child: Icon(MyFlutterApp.ruler, size: 18)),
                      TextSpan(
                        text: "  ${fish.length?.toStringAsFixed(1)} cm\n",
                        style: const TextStyle(color: Colors.black),
                      ),
                      WidgetSpan(
                        child: Icon(MyFlutterApp.kettlebell, size: 18),
                      ),
                      TextSpan(
                        text: "  ${fish.weight?.toStringAsFixed(1)} g\n",
                        style: const TextStyle(color: Colors.black),
                      ),
                      WidgetSpan(child: Icon(MyFlutterApp.clock, size: 18)),
                      TextSpan(
                        text:
                            "  ${fish.caughtOn.toLocal().day}-${fish.caughtOn.toLocal().month}-${fish.caughtOn.toLocal().year}",
                        style: const TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                ),
                isThreeLine: true,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
