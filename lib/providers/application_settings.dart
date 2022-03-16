import 'dart:io';
import 'package:flutter/widgets.dart';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class ApplicationSettings with ChangeNotifier {
  // path to local directory:
  static String home = "";
  late final String _settings = "settings.json";
  Map<String, dynamic> data = {};

  init() async {
    String os = Platform.operatingSystem;

    Map<String, String> envVars = Platform.environment;
    if (Platform.isMacOS) {
      home = envVars['HOME']!;
    } else if (Platform.isLinux) {
      home = envVars['HOME']!;
    } else if (Platform.isWindows) {
      home = envVars['UserProfile']!;
    }
    print(home);

    home = home + "/AppData/Local/Mini Game Manager/";
    Directory(home).create(recursive: true);
    bool check = await File(home + _settings).exists();

    if (!check) {
      print("didnt find");
      File(home + _settings).writeAsString("");
    } else {
      print("did find");
      await loadSettings();
    }
  }

  void saveSettings() async {
    await File(home + _settings).writeAsString(jsonEncode(data));
    notifyListeners();
  }

  Future<void> loadSettings() async {
    this.data = json.decode(await File(home + _settings).readAsString());
    notifyListeners();
  }

  void setGameDirectory(String input) {
    data["games_directory"] = input;
    saveSettings();
  }
}
