import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NeuroCosmosTheme {
  // Core Colors
  static const Color primaryDark = Color(0xFF0A0528); // Dark purple
  static const Color deepBlueCosmos = Color(0xFF0D1B3B); // Deep blue cosmos
  static const Color electricTurquoise = Color(0xFF00F5FF); // Electric turquoise
  static const Color neonPink = Color(0xFFFF00FF); // Neon pink
  static const Color brightOrange = Color(0xFFFF6B00); // Bright orange
  static const Color softGlow = Color(0x4D00F5FF); // Soft glow
  
  // Gradient definitions
  static const LinearGradient cosmosGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryDark, deepBlueCosmos],
  );
  
  static const LinearGradient energyGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [electricTurquoise, neonPink],
  );
  
  static const LinearGradient glowGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [softGlow, Colors.transparent],
  );

  // Dark Theme (NeuroCosmos style)
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: electricTurquoise,
      scaffoldBackgroundColor: primaryDark,
      colorScheme: ColorScheme.dark(
        primary: electricTurquoise,
        secondary: neonPink,
        tertiary: brightOrange,
        surface: const Color(0xFF251A4D), // Slightly lighter more contrasty surface
        onSurface: Colors.white, // Explicitly white text on surfaces
        onPrimaryContainer: Colors.white,
      ),
      textTheme: GoogleFonts.orbitronTextTheme(ThemeData.dark().textTheme).apply(
        bodyColor: Colors.white,
        displayColor: Colors.white,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: electricTurquoise),
        titleTextStyle: GoogleFonts.orbitron(
          color: electricTurquoise,
          fontSize: 24,
          fontWeight: FontWeight.w700,
          letterSpacing: 2.0,
          shadows: [
            Shadow(
              offset: const Offset(0, 0),
              blurRadius: 10,
              color: electricTurquoise.withValues(alpha: 0.5),
            ),
          ],
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          textStyle: GoogleFonts.orbitron(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.5,
          ),
        ).copyWith(
          overlayColor: WidgetStateProperty.all(electricTurquoise.withValues(alpha: 0.2)),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: electricTurquoise,
          textStyle: GoogleFonts.orbitron(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            letterSpacing: 1.0,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF1A1035).withValues(alpha: 0.6),
        contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: electricTurquoise, width: 2),
        ),
        labelStyle: GoogleFonts.orbitron(color: Colors.grey[400]),
        prefixIconColor: electricTurquoise,
      ),
      cardTheme: CardThemeData(
        color: const Color(0xFF1A1035).withValues(alpha: 0.4),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color(0xFF1A1035),
        selectedItemColor: electricTurquoise,
        unselectedItemColor: Colors.grey,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
      ),
      iconTheme: const IconThemeData(
        color: electricTurquoise,
      ),
    );
  }

  // Light Theme (NeuroCosmos style - lighter version)
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: electricTurquoise,
      scaffoldBackgroundColor: const Color(0xFFE8E4FF),
      colorScheme: ColorScheme.light(
        primary: electricTurquoise,
        secondary: neonPink,
        tertiary: brightOrange,
        surface: Colors.white,
      ),
      textTheme: GoogleFonts.orbitronTextTheme().apply(
        bodyColor: const Color(0xFF0A0528),
        displayColor: const Color(0xFF0A0528),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: primaryDark),
        titleTextStyle: GoogleFonts.orbitron(
          color: primaryDark,
          fontSize: 24,
          fontWeight: FontWeight.w700,
          letterSpacing: 2.0,
          shadows: [
            Shadow(
              offset: const Offset(0, 0),
              blurRadius: 10,
              color: electricTurquoise.withValues(alpha: 0.3),
            ),
          ],
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: primaryDark,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          textStyle: GoogleFonts.orbitron(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.5,
          ),
        ).copyWith(
          overlayColor: WidgetStateProperty.all(electricTurquoise.withValues(alpha: 0.2)),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryDark,
          textStyle: GoogleFonts.orbitron(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            letterSpacing: 1.0,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.8),
        contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: electricTurquoise, width: 2),
        ),
        labelStyle: GoogleFonts.orbitron(color: Colors.grey[600]),
        prefixIconColor: electricTurquoise,
      ),
      cardTheme: CardThemeData(
        color: Colors.white.withValues(alpha: 0.8),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: electricTurquoise,
        unselectedItemColor: Colors.grey,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
      ),
      iconTheme: const IconThemeData(
        color: primaryDark,
      ),
    );
  }
}
