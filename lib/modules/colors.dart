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

class SecondColorPallet implements ColorPallet {
  @override
  MaterialColor background = const MaterialColor(0xFF023047, <int, Color>{
    50: Color(0x0D023047),
    100: Color(0x0230471A),
    200: Color(0x33023047),
    300: Color(0x4D023047),
    400: Color(0x66023047),
    500: Color(0x80023047),
    600: Color(0x99023047),
    700: Color(0xB3023047),
    800: Color(0xCC023047),
    900: Color(0xE6023047),
  });

  @override
  MaterialColor backgroundAlt = const MaterialColor(0xFF035177, <int, Color>{
    50: Color(0x0D035177),
    100: Color(0x1A035177),
    200: Color(0x33035177),
    300: Color(0x4D035177),
    400: Color(0x66035177),
    500: Color(0x80035177),
    600: Color(0x99035177),
    700: Color(0xB3035177),
    800: Color(0xCC035177),
    900: Color(0xE6035177),
  });

  @override
  MaterialColor primary = const MaterialColor(0xFFFB8500, <int, Color>{
    50: Color(0x0DFB8500),
    100: Color(0x1AFB8500),
    200: Color(0x33FB8500),
    300: Color(0x4DFB8500),
    400: Color(0x66FB8500),
    500: Color(0x80FB8500),
    600: Color(0x99FB8500),
    700: Color(0xB3FB8500),
    800: Color(0xCCFB8500),
    900: Color(0xE6FB8500),
  });

  @override
  MaterialColor primaryAlt = const MaterialColor(0xFFC73E1D, <int, Color>{
    50: Color(0x0DC73E1D),
    100: Color(0x1AC73E1D),
    200: Color(0x33C73E1D),
    300: Color(0x4DC73E1D),
    400: Color(0x66C73E1D),
    500: Color(0x80C73E1D),
    600: Color(0x99C73E1D),
    700: Color(0xB3C73E1D),
    800: Color(0xCCC73E1D),
    900: Color(0xE6C73E1D),
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
  MaterialColor secondary = const MaterialColor(0xFFFFB703, <int, Color>{
    50: Color(0x0DFFB703),
    100: Color(0x1AFFB703),
    200: Color(0x33FFB703),
    300: Color(0x4DFFB703),
    400: Color(0x66FFB703),
    500: Color(0x80FFB703),
    600: Color(0x99FFB703),
    700: Color(0xB3FFB703),
    800: Color(0xCCFFB703),
    900: Color(0xE6FFB703),
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
  MaterialColor secondaryText = const MaterialColor(0xFFE0A100, <int, Color>{
    50: Color(0x0DE0A100),
    100: Color(0x1AE0A100),
    200: Color(0x33E0A100),
    300: Color(0x4DE0A100),
    400: Color(0x66E0A100),
    500: Color(0x80E0A100),
    600: Color(0x99E0A100),
    700: Color(0xB3E0A100),
    800: Color(0xCCE0A100),
    900: Color(0xE6E0A100),
  });
}
