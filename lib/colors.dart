import 'package:flutter/material.dart';


final blueFishColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: const Color(0xFF0277BD), // Deep ocean blue
  onPrimary: Colors.white, // Text/icons on primary
  primaryContainer: const Color(0xFF58A5F0), // Lighter water-blue
  onPrimaryContainer: Colors.black,

  secondary: const Color(0xFF4DD0E1), // Tropical teal
  onSecondary: Colors.black,
  secondaryContainer: const Color(0xFFB2EBF2), // Pale aqua
  onSecondaryContainer: Colors.black,

  tertiary: const Color(0xFFFF8A65), // Coral/orange pop
  onTertiary: Colors.black,
  tertiaryContainer: const Color(0xFFFFCCBC),
  onTertiaryContainer: Colors.black,

  error: const Color(0xFFB00020),
  onError: Colors.white,

  surface: const Color.fromARGB(255, 226, 243, 250), // Background
  onSurface: Colors.black,
  surfaceContainerHigh: const Color.fromARGB(255, 202, 240, 255),

  surfaceContainerHighest: const Color.fromARGB(255, 217, 238, 255), // Subtle ocean blue tint
  onSurfaceVariant: Colors.black,

  outline: const Color(0xFF90CAF9), // Border/light accents
  shadow: Colors.black,
  inverseSurface: const Color(0xFF37474F),
  onInverseSurface: Colors.white,
  inversePrimary: const Color(0xFF81D4FA),
  surfaceTint: const Color(0xFF0277BD),

);