import 'dart:io';
import 'package:flutter/widgets.dart';
import 'dart:convert';
import 'package:mini_game_manager/modules/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum gameLibraryView {
  gridView,
  comfyView,
  listView,
}

class ApplicationSettings with ChangeNotifier {
  // path to local directory:
  static String home = "";
  late final String _settings = "settings.json";
  late gameLibraryView libraryView;
  late SharedPreferences _prefs;
  Map<String, dynamic> data = {};

  Map<String, ColorPallet> colorThemes = {
    "Default": DefaultColorPallet(),
    "Secondary": SecondColorPallet(),
  };

  ColorPallet activeColorTheme = DefaultColorPallet();

  init() async {
    libraryView = gameLibraryView.gridView;
    Map<String, String> envVars = Platform.environment;
    _prefs = await SharedPreferences.getInstance();
    if (Platform.isMacOS) {
      home = envVars['HOME']!;
    } else if (Platform.isLinux) {
      home = envVars['HOME']!;
    } else if (Platform.isWindows) {
      home = envVars['UserProfile']!;
    }

    home = home + "/AppData/Local/Mini Game Manager/";
    Directory(home).create(recursive: true);
    bool check = await File(home + _settings).exists();

    if (!check) {
      File(home + _settings).writeAsString("");
    } else {
      await loadSettings();
    }
    getLibraryView();
  }

  setColorTheme(String key) {
    activeColorTheme = colorThemes[key] ?? DefaultColorPallet();
    notifyListeners();
  }

  void saveSettings() async {
    await File(home + _settings).writeAsString(jsonEncode(data));
    notifyListeners();
  }

  Future<void> loadSettings() async {
    data = json.decode(await File(home + _settings).readAsString());
    notifyListeners();
  }

  void setGameDirectory(String input) {
    data["games_directory"] = input;
    saveSettings();
  }

  setLibraryView(gameLibraryView view) async {
    libraryView = view;
    await _prefs.setString("libraryView", view.toString());
    notifyListeners();
  }

  void getLibraryView() {
    libraryView = gameLibraryView.values.firstWhere(
        (element) => element.toString() == _prefs.getString("libraryView"),
        orElse: () => gameLibraryView.gridView);
    notifyListeners();
  }
}
