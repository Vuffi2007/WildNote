import 'package:flutter/material.dart';
import 'package:wild_note/my_flutter_app_icons.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:wild_note/fish.dart';
import 'package:wild_note/colors.dart';
import 'dart:io';

class FishListScreen extends StatelessWidget {
  const FishListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Catches')),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<Fish>('fishBox').listenable(),
        builder: (context, Box<Fish> box, _) {
          if (box.isEmpty) {
            return const Center(child: Text('No catches yet'));
          }

          return ListView.builder(
            itemCount: box.length,
            itemBuilder: (context, index) {
              final fish = box.getAt(index);

              if (fish == null) return const SizedBox();

              return Card(
                color: blueFishColorScheme.surfaceContainerHigh,
                margin: const EdgeInsets.all(8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.file(
                      File(fish.imagePath),
                      width: 120, // larger than 60
                      height: 120,
                      fit: BoxFit.cover,
                    ),
                    Expanded(
                      child: ListTile(
                        title: Text(fish.species),
                        subtitle: RichText(
                          text: TextSpan(
                            children: [
                              WidgetSpan(
                                child: Icon(MyFlutterApp.ruler, size: 18),
                              ),
                              TextSpan(
                                text:
                                    "  ${fish.length?.toStringAsFixed(1)} cm\n",
                                style: const TextStyle(color: Colors.black),
                              ),
                              WidgetSpan(
                                child: Icon(MyFlutterApp.kettlebell, size: 18),
                              ),
                              TextSpan(
                                text:
                                    "  ${fish.weight?.toStringAsFixed(1)} g\n",
                                style: const TextStyle(color: Colors.black),
                              ),
                              WidgetSpan(
                                child: Icon(MyFlutterApp.clock, size: 18),
                              ),
                              TextSpan(
                                text:
                                    "  ${fish.caughtOn.toLocal().day}-${fish.caughtOn.toLocal().month}-${fish.caughtOn.toLocal().year}",
                                style: const TextStyle(color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                        isThreeLine: true,
                        trailing: IconButton(
                          icon: Icon(
                            Icons.delete,
                            color: blueFishColorScheme.error,
                          ),
                          onPressed: () => box.deleteAt(index),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
