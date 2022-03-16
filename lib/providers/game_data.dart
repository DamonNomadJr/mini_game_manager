import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GameData with ChangeNotifier {
  Map<String, dynamic> data = {};
  final String _filename = "games_list";
  late final SharedPreferences _prefs;

  init() async {
    _prefs = await SharedPreferences.getInstance();
    data = await loadFileData(_filename);
  }

  void addData(String file, List<String> tags) async {
    int hash = file.hashCode;
    Map<String, dynamic> entry = {
      "$hash": {
        "game_name": file.split('\\').last,
        "game_icon": "",
        "game_path": file,
        "game_tags": tags
      },
    };
    data.containsKey(hash) ? null : data.addEntries(entry.entries);
    await saveFileData(_filename, data);
    notifyListeners();
  }

  Future<void> updateData(String hash, Map<String, dynamic> updates) async {
    data.update(hash, (value) => updates);
    await saveFileData(_filename, data);
    notifyListeners();
  }

  Future<void> removeData(String hash) async {
    data.remove(hash);
    await saveFileData(_filename, data);
    notifyListeners();
  }

  Future<bool> saveFileData(String fileName, Map<dynamic, dynamic> data) async {
    return await _prefs.setString(fileName, json.encode(data));
  }

  Future<Map<String, dynamic>> loadFileData(String fileName) async {
    String? prefData = _prefs.getString(fileName);
    if (prefData != null) {
      return json.decode(prefData);
    } else {
      return {};
    }
  }
}
