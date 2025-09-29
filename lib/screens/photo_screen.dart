import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:native_exif/native_exif.dart';

import 'package:wild_note/fish.dart';

class PhotoScreen extends StatefulWidget {
  const PhotoScreen({super.key, required this.camera});

  final CameraDescription camera;

  @override
  PhotoScreenState createState() => PhotoScreenState();
}

class PhotoScreenState extends State<PhotoScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(widget.camera, ResolutionPreset.medium);

    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Take a picture')),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return CameraPreview(_controller);
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            await _initializeControllerFuture;

            final image = await _controller.takePicture();

            if (!context.mounted) return;

            await Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (context) =>
                    DisplayPictureScreen(imagePath: image.path),
              ),
            );
          } catch (e) {
            print(e);
          }
        },
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}

class FishSpecie {
  final String specie;

  FishSpecie({required this.specie});
}

List<FishSpecie> species = [
  FishSpecie(specie: 'Pike'),
  FishSpecie(specie: 'Perch'),
  FishSpecie(specie: 'Roach Fish'),
  FishSpecie(specie: 'Carp'),
];

class DisplayPictureScreen extends StatefulWidget {
  final String imagePath;

  const DisplayPictureScreen({super.key, required this.imagePath});

  @override
  State<DisplayPictureScreen> createState() => _DisplayPictureScreenState();
}

class _DisplayPictureScreenState extends State<DisplayPictureScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _lengthController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _speciesController = TextEditingController();

  int count = 0;

  @override
  void dispose() {
    _lengthController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  Future<void> _saveFish() async {
    if (_formKey.currentState!.validate()) {
      final box = Hive.box<Fish>("fishBox");

      final exif = await Exif.fromPath(widget.imagePath);
      final latLong = await exif.getLatLong();

      final fish = Fish(
        species: _speciesController.text,
        weight: double.tryParse(_weightController.text),
        length: double.tryParse(_lengthController.text),
        imagePath: widget.imagePath,
        caughtOn: DateTime.now(),
        latitude: latLong!.latitude,
        longitude: latLong!.longitude
        
      );

      await box.add(fish);
      
      await exif.close();


      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Saved ${fish.species} to database')),
      );
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Is this picture good?')),
      body: SingleChildScrollView(
        // prevents overflow when keyboard opens
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Image.file(File(widget.imagePath)),
                const SizedBox(height: 16),

                // Length input
                TextFormField(
                  controller: _lengthController,
                  decoration: const InputDecoration(
                    labelText: 'Length of fish (cm)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter something';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Weight input
                TextFormField(
                  controller: _weightController,
                  decoration: const InputDecoration(
                    labelText: 'Weight of fish (g)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter something';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Specie input
                DropdownMenu(
                  controller: _speciesController,
                  label: Text("Specie of fish"),
                  initialSelection: species[0],
                  dropdownMenuEntries: [
                    for (var fish in species)
                      DropdownMenuEntry(value: fish.specie, label: fish.specie),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: _saveFish,
        child: const Icon(Icons.check),
      ),
    );
  }
}
