import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GameCategories with ChangeNotifier {
  late SharedPreferences _prefs;
  final String _fileName = "gameCategory";

  final List<GameCategory> _categories = [];

  init() async {
    _prefs = await SharedPreferences.getInstance();
    await load();
  }

  bool categoryExist(String categoryName) {
    return _categories.indexWhere((element) => element.name == categoryName) >
        -1;
  }

  Future<bool> addCategory(String categoryName) async {
    if (categoryExist(categoryName)) {
      return false;
    } else {
      _categories.add(
        GameCategory(
          name: categoryName,
          gameHashes: [],
        ),
      );
      await save();
      notifyListeners();
      return true;
    }
  }

  Future<bool> addGameToCategory(String categoryName, String gamehash) async {
    if (categoryExist(categoryName)) {
      GameCategory item =
          _categories.firstWhere((element) => element.name == categoryName);
      if (item.gameHashes.contains(gamehash)) {
        return false;
      }
      item.gameHashes.add(gamehash.toString());
      await save();
      notifyListeners();
      return true;
    } else {
      return false;
    }
  }

  Future<bool> removeCategoryByName(String categoryName) async {
    if (categoryExist(categoryName)) {
      _categories.removeWhere((element) => element.name == categoryName);
      save();
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> removeCategoryById(String categoryName) async {
    if (categoryExist(categoryName)) {
      _categories.removeWhere((element) => element.name == categoryName);
      save();
      notifyListeners();
      return true;
    }
    return false;
  }

  List<String> getAllCategories() {
    List<String> list = [];
    for (var item in _categories) {
      list.add(item.name);
    }
    return list;
  }

  GameCategory? getCategoryByName(String categoryName) {
    try {
      return _categories.firstWhere((element) => element.name == categoryName);
    } catch (_) {
      return null;
    }
  }

  List<String>? getGameHashesInCategory(String categoryName) {
    try {
      GameCategory item =
          _categories.firstWhere((element) => element.name == categoryName);
      return item.gameHashes;
    } catch (_) {
      return null;
    }
  }

  List<String> getCategoriesOfGame(String gameHash) {
    List<String> list = [];
    for (var item in _categories) {
      print(item);
      if (item.gameHashes.contains(gameHash)) {
        print("add>? " + item.toString());
        list.add(item.name);
      }
    }
    return list;
  }

  int length() {
    return _categories.length;
  }

  @override
  String toString() {
    return _categories.toString();
  }

  Future<bool> save() async {
    List _categoriesList = [];
    for (var item in _categories) {
      _categoriesList.add(item.toJson());
    }
    return await _prefs.setString(
        _fileName, json.encode({_fileName: _categoriesList}));
  }

  Future<void> load() async {
    String? prefData = _prefs.getString(_fileName);
    if (prefData != null) {
      var data = json.decode(prefData);
      for (String item in data[_fileName]) {
        _categories.add(GameCategory.fromJson(json.decode(item)));
      }
      notifyListeners();
    }
  }
}

class GameCategory {
  late String name;
  late List<String> gameHashes;

  GameCategory({
    required this.name,
    required this.gameHashes,
  });

  factory GameCategory.fromJson(Map<String, dynamic> json) {
    return GameCategory(
      name: json["name"],
      gameHashes: List<String>.from(
        json["gameHashes"],
      ),
    );
  }

  String toJson() {
    return json.encode({"name": name, "gameHashes": gameHashes});
  }

  @override
  String toString() {
    return "$name: $gameHashes";
  }
}
