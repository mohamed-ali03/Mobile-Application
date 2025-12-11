import 'package:flutter/material.dart';

final ThemeData appTheme = ThemeData(
  // 1. Primary Colors
  primaryColor: const Color(
    0xFFE44E57,
  ), // A vibrant red, derived from the background/accents
  colorScheme: const ColorScheme(
    primary: Color(0xFFE44E57), // Vibrant Red
    secondary: Color(
      0xFFFC6A75,
    ), // Lighter Red for accents/highlights (e.g., secondary buttons)
    surface: Color(0xFFFFFFFF), // White for card backgrounds and main surface
    error: Color(0xFFD32F2F), // Standard error red
    onPrimary: Color(0xFFFFFFFF), // White text on primary color
    onSecondary: Color(0xFFFFFFFF), // White text on secondary color
    onSurface: Color(0xFF1E1E1E), // Dark text/icons on white surface
    onError: Color(0xFFFFFFFF), // White text on error color
    brightness: Brightness.light,
  ),

  // 2. Scaffold (Screen) Background
  scaffoldBackgroundColor: const Color(
    0xFFFAFAFA,
  ), // Matches the background color scheme
  // 3. Typography (Text Theme)
  textTheme: const TextTheme(
    displayLarge: TextStyle(
      fontFamily: 'Montserrat',
      fontSize: 32,
      fontWeight: FontWeight.bold,
      color: Color(0xFF1E1E1E),
    ),
    headlineMedium: TextStyle(
      fontFamily: 'Montserrat',
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: Color(0xFF1E1E1E),
    ),
    titleLarge: TextStyle(
      fontFamily: 'Montserrat',
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: Color(0xFF1E1E1E),
    ),
    bodyMedium: TextStyle(
      fontFamily: 'Poppins',
      fontSize: 14,
      color: Color(0xFF4C4C4C),
    ), // Default text
    labelLarge: TextStyle(
      fontFamily: 'Poppins',
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: Color(0xFFFFFFFF),
    ), // Button text
  ),

  // 4. App Bar (Header)
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFFFAFAFA),
    elevation: 0, // Flat design
    iconTheme: IconThemeData(color: Color(0xFF1E1E1E)),
    titleTextStyle: TextStyle(
      fontFamily: 'Montserrat',
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: Color(0xFF1E1E1E),
    ),
  ),

  // 5. Elevated Button (e.g., "ORDER NOW" button)
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFFE44E57), // Primary Red background
      foregroundColor: Colors.white, // White text
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0), // Rounded corners
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      textStyle: const TextStyle(
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w600,
      ),
    ),
  ),

  // 6. Card (e.g., product item cards)
  cardTheme: CardThemeData(
    color: Colors.white,
    elevation: 2, // Subtle shadow for lift
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15.0), // Rounded corners for cards
    ),
  ),

  // 7. Input Decoration (e.g., "Search" bar)
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.white, // White fill for the search bar
    contentPadding: const EdgeInsets.symmetric(
      vertical: 10.0,
      horizontal: 16.0,
    ),
    hintStyle: const TextStyle(
      color: Color(0xFFB0B0B0),
    ), // Light gray hint text
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(30.0), // Highly rounded
      borderSide: BorderSide.none, // No visible border line
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(30.0),
      borderSide: const BorderSide(
        color: Color(0xFFFC6A75),
        width: 1.5,
      ), // Subtle focus indicator
    ),
  ),

  // 8. Icon Theme (e.g., for navigation and action icons)
  iconTheme: const IconThemeData(
    color: Color(0xFF1E1E1E), // Default dark icon color
  ),
);
