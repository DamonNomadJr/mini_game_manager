import 'package:flutter/material.dart';

abstract class ColorPallet {
  abstract MaterialColor primary;
  abstract MaterialColor primaryAlt;
  abstract MaterialColor secondary;
  abstract MaterialColor secondaryAlt;
  abstract MaterialColor background;
  abstract MaterialColor backgroundAlt;
  abstract MaterialColor primaryText;
  abstract MaterialColor secondaryText;
}

class DefaultColorPallet implements ColorPallet {
  @override
  MaterialColor background = const MaterialColor(0xFF1A1A1A, <int, Color>{
    50: Color(0x0D1A1A1A),
    100: Color(0x1A1A1A1A),
    200: Color(0x331A1A1A),
    300: Color(0x4D1A1A1A),
    400: Color(0x661A1A1A),
    500: Color(0x801A1A1A),
    600: Color(0x991A1A1A),
    700: Color(0xB31A1A1A),
    800: Color(0xCC1A1A1A),
    900: Color(0xE61A1A1A),
  });

  @override
  MaterialColor backgroundAlt = const MaterialColor(0xFF2A2B2A, <int, Color>{
    50: Color(0x0D2A2B2A),
    100: Color(0x1A2A2B2A),
    200: Color(0x332A2B2A),
    300: Color(0x4D2A2B2A),
    400: Color(0x662A2B2A),
    500: Color(0x802A2B2A),
    600: Color(0x992A2B2A),
    700: Color(0xB32A2B2A),
    800: Color(0xCC2A2B2A),
    900: Color(0xE62A2B2A),
  });

  @override
  MaterialColor primary = const MaterialColor(0xFF023E8A, <int, Color>{
    50: Color(0x0D023E8A),
    100: Color(0x1A023E8A),
    200: Color(0x33023E8A),
    300: Color(0x4D023E8A),
    400: Color(0x66023E8A),
    500: Color(0x80023E8A),
    600: Color(0x99023E8A),
    700: Color(0xB3023E8A),
    800: Color(0xCC023E8A),
    900: Color(0xE6023E8A),
  });

  @override
  MaterialColor primaryAlt = const MaterialColor(0xFF0077B6, <int, Color>{
    50: Color(0x0D0077B6),
    100: Color(0x1A0077B6),
    200: Color(0x330077B6),
    300: Color(0x4D0077B6),
    400: Color(0x660077B6),
    500: Color(0x800077B6),
    600: Color(0x990077B6),
    700: Color(0xB30077B6),
    800: Color(0xCC0077B6),
    900: Color(0xE60077B6),
  });

  @override
  MaterialColor primaryText = const MaterialColor(0xFFFFFFFF, <int, Color>{
    50: Color(0x0DFFFFFF),
    100: Color(0x1AFFFFFF),
    200: Color(0x33FFFFFF),
    300: Color(0x4DFFFFFF),
    400: Color(0x66FFFFFF),
    500: Color(0x80FFFFFF),
    600: Color(0x99FFFFFF),
    700: Color(0xB3FFFFFF),
    800: Color(0xCCFFFFFF),
    900: Color(0xE6FFFFFF),
  });

  @override
  MaterialColor secondary = const MaterialColor(0xFF8E0003, <int, Color>{
    50: Color(0x0D8E0003),
    100: Color(0x1A8E0003),
    200: Color(0x338E0003),
    300: Color(0x4D8E0003),
    400: Color(0x668E0003),
    500: Color(0x808E0003),
    600: Color(0x998E0003),
    700: Color(0xB38E0003),
    800: Color(0xCC8E0003),
    900: Color(0xE68E0003),
  });

  @override
  MaterialColor secondaryAlt = const MaterialColor(0xFF9E2A2B, <int, Color>{
    50: Color(0x0D9E2A2B),
    100: Color(0x1A9E2A2B),
    200: Color(0x339E2A2B),
    300: Color(0x4D9E2A2B),
    400: Color(0x669E2A2B),
    500: Color(0x809E2A2B),
    600: Color(0x999E2A2B),
    700: Color(0xB39E2A2B),
    800: Color(0xCC9E2A2B),
    900: Color(0xE69E2A2B),
  });

  @override
  MaterialColor secondaryText = const MaterialColor(0xFFEEEEEE, <int, Color>{
    50: Color(0x0DEEEEEE),
    100: Color(0x1AEEEEEE),
    200: Color(0x33EEEEEE),
    300: Color(0x4DEEEEEE),
    400: Color(0x66EEEEEE),
    500: Color(0x80EEEEEE),
    600: Color(0x99EEEEEE),
    700: Color(0xB3EEEEEE),
    800: Color(0xCCEEEEEE),
    900: Color(0xE6EEEEEE),
  });
}
