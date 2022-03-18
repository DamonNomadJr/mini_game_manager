import 'dart:convert';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GameData with ChangeNotifier {
  Map<String, dynamic> data = {};
  Map<String, dynamic> categories = {};

  final String _dataFileName = "games_list";
  final String _categoryFileName = "games_list";

  late final SharedPreferences _prefs;

  init() async {
    _prefs = await SharedPreferences.getInstance();
    data = await loadPreference(_dataFileName);
    categories = await loadPreference(_categoryFileName);
  }

  Future<void> addNewCategory(String categoryName) async {
    Map<String, List<String>> newCat = {categoryName: []};
    categories.containsKey(categoryName)
        ? null
        : categories.addEntries(newCat.entries);
    await savePreference(_categoryFileName, categories);
    print("Category $categoryName was created");
    notifyListeners();
  }

  Future<void> removeCategory(categoryName) async {
    categories.removeWhere((key, value) => key == categoryName);
    await savePreference(_categoryFileName, categories);
    print("Category $categories was updated and removed $categoryName");
    notifyListeners();
  }

  addGameToCategory(String categoryName, String gameHash) async {
    if (!categories.containsKey(categoryName)) {
      await addNewCategory(categoryName);
    }
    categories.entries.where((element) {
      if (element.key == categoryName) {
        element.value.add(gameHash);
      }
      return true;
    });
    print("$categories");
    notifyListeners();
  }

  void addGameToLibrary({
    required String gameName,
    String gameBackogundImage =
        "https://cdn-www.playstationlifestyle.net/assets/uploads/2019/03/PlayStation-Plus-Value-Change-free-games.png",
    required String mainRunner,
    required List<String> tags,
    required List<Map<String, String>> runners,
  }) async {
    int hash = gameName.hashCode;
    Map<String, dynamic> entry = {
      "$hash": {
        "name": gameName,
        "backgroundImage": gameBackogundImage,
        "main_runner": mainRunner,
        "tags": tags,
        "runner_lists": runners,
      },
    };
    data.containsKey(hash) ? null : data.addEntries(entry.entries);
    await savePreference(_dataFileName, data);
    notifyListeners();
  }

  Future<void> updateGameinLibrary(
    String hash,
    Map<String, dynamic> updates,
  ) async {
    data.update(hash, (value) => updates);
    await savePreference(_dataFileName, data);
    notifyListeners();
  }

  Future<void> removeGameFromLibrary(String hash) async {
    data.remove(hash);
    await savePreference(_dataFileName, data);
    notifyListeners();
  }

  Future<bool> savePreference(
      String fileName, Map<dynamic, dynamic> mapData) async {
    return await _prefs.setString(fileName, json.encode(data));
  }

  Future<Map<String, dynamic>> loadPreference(String fileName) async {
    String? prefData = _prefs.getString(fileName);
    if (prefData != null) {
      return json.decode(prefData);
    } else {
      return {};
    }
  }
}
