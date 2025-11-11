import 'package:flutter/material.dart';

class MuzzTheme {
  static const Color pillOutlineInactive = dividerAsh;

  static const double pillOutlineWidth = 1.5;

  static const double pillRadius = 24;

  static const double pillFontSize = 15;

  static const double pillMinWidth = 120;

  static const double pillHeight = 36;

  static const double singleThumb = 56;

  static const double albumThumb = 68;

  static const double tileSpacing = 10;

  static const double tilePad = 8;

  static const Color dividerAsh = Color(0xFF3A3F45);

  static const Color tileAsh = Color(0xFF2B2F34);

  static const double fabVPad = 12;

  static const double fabHPad = 18;

  static const double cornerRadiusLarge = 16;

  static const Color shadowColorStrong = Colors.black54;

  static const Color navBarUnselected = Colors.white70;

  static const Color navBarDark = Color(0xFF000000);

  static const Color darkBackground = Color(0xFF1B1B1D);
  static const Color darkSurface = Color(0xFF3B3B3F);
  static const Color accentColor = Color(0xFFFFD700);

  // Toggle (Switch) styling
  static const Color toggleTrackOn = Color(0xFFFFD54F); // warm yellow like mock
  static const Color toggleThumbOn = Colors.white;
  static const Color toggleTrackOff = Colors.white12;
  static const Color toggleThumbOff = Color(0xFF9EA3AA);

  // Primary & Secondary button styling for Studio screen
  static const double studioButtonRadius = 16;
  static const double studioButtonHeight = 52;
  static const EdgeInsets studioButtonPadding =
      EdgeInsets.symmetric(vertical: 14);
  static const Color studioPrimaryBg = Color(0xFFFFD54F);
  static const Color studioPrimaryText = Colors.black;
  static const Color studioSecondaryBorder = Color(0xFFFFD54F);
  static const Color studioSecondaryText = Colors.white;

  static const Color inputTextColor = Colors.white;
  static const Color inputFillColor = Color(0xFF252B36);
  static const Color inputHintColor = Color(0xFF9096A1);
  static const double inputRadius = 16;
  static const EdgeInsets inputPadding =
      EdgeInsets.symmetric(horizontal: 20, vertical: 18);
  static const Color inputBorderColor = Colors.white24;

  // Section title styling (Albums, Singles, etc.)
  static const TextStyle sectionTitleStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  // Grid item title styling (album/single name)
  static const TextStyle gridItemTitleStyle = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  // Grid item subtitle styling (year)
  static const TextStyle gridItemSubtitleStyle = TextStyle(
    fontSize: 13,
    color: Colors.white70,
  );

  static ThemeData get dark => ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: darkBackground,
        primaryColor: accentColor,
        colorScheme: const ColorScheme.dark(
          onPrimary: Colors.black,
          surface: darkBackground,
          primary: accentColor,
          surfaceContainerHighest: darkSurface,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: darkBackground,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: darkBackground,
          selectedItemColor: accentColor,
          unselectedItemColor: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: accentColor,
            foregroundColor: Colors.black,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          isDense: true,
          contentPadding: MuzzTheme.inputPadding,
          fillColor: MuzzTheme.inputFillColor,
          hintStyle: TextStyle(color: MuzzTheme.inputHintColor),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent),
              borderRadius:
                  BorderRadius.all(Radius.circular(MuzzTheme.inputRadius))),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: MuzzTheme.inputBorderColor),
              borderRadius:
                  BorderRadius.all(Radius.circular(MuzzTheme.inputRadius))),
          border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius:
                  BorderRadius.all(Radius.circular(MuzzTheme.inputRadius))),
        ),
        textTheme: const TextTheme(
          titleLarge: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          bodyLarge: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.normal,
            color: Colors.white,
          ),
          labelLarge: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
      );

  static ThemeData get light => ThemeData.light(); // You can expand this later
}
