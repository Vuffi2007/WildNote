import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:wild_note/screens/photo_screen.dart';
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
                margin: const EdgeInsets.all(8.0),
                child: ListTile(
                  leading: Image.file(
                    File(fish.imagePath),
                    width: 60,
                    fit: BoxFit.cover,
                  ),
                  title: Text(fish.species),
                  subtitle: Text(
                    'Length: ${fish.length?.toStringAsFixed(1)} cm\n'
                    'Weight: ${fish.weight?.toStringAsFixed(1)} g\n'
                    'Caught: ${fish.caughtOn.toLocal()}',
                  ),
                  isThreeLine: true,
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: blueFishColorScheme.error),
                    onPressed: () => box.deleteAt(index),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
