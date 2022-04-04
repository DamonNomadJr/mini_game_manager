import 'dart:convert';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GameData with ChangeNotifier {
  List<Game> _games = [];

  final String _fileName = "gamesList";

  late final SharedPreferences _prefs;

  init() async {
    _prefs = await SharedPreferences.getInstance();
    await load();
  }

  bool gameExist(String gameHash) {
    return _games.indexWhere((element) => element.hash == gameHash) > -1;
  }

  List<Game> getAllGames() {
    return _games;
  }

  Future<bool> updateGame(
    String gameHash, {
    String? name,
    List<String>? tags,
    String? background,
    String? note,
  }) async {
    if (gameExist(gameHash)) {
      Game item = getGameByHash(gameHash)!;
      item.name = name ?? item.name;
      item.hash = item.name.hashCode.toString();
      if (tags != null) {
        for (var tag in tags) {
          if (!item.tags.contains(tag)) {
            item.tags.add(tag);
          }
        }
      }
      item.background = background ?? item.background;
      item.note = note ?? item.note;
      await save();
      notifyListeners();
      return true;
    } else {
      return false;
    }
  }

  Future<bool> removeGame(
    String gameHash, {
    String? name,
    List<String>? tags,
    String? background,
    String? note,
  }) async {
    if (gameExist(gameHash)) {
      _games.remove(getGameByHash(gameHash)!);
      await save();
      notifyListeners();
      return true;
    } else {
      return false;
    }
  }

  Future<bool> addGameToLibrary({
    required String name,
    required String background,
    required List<String> tags,
    required List<String> category,
    required String note,
  }) async {
    if (!gameExist(name.hashCode.toString())) {
      _games.add(Game(
        hash: name.hashCode.toString(),
        name: name,
        background: background,
        tags: tags,
        category: category,
        note: note,
      ));
      await save();
      notifyListeners();
      return true;
    } else {
      return false;
    }
  }

  Game? getGameByHash(String gameHash) {
    try {
      Game item = _games.firstWhere((element) => element.hash == gameHash);
      return item;
    } catch (_) {
      return null;
    }
  }

  int length() {
    return _games.length;
  }

  @override
  String toString() {
    return _games.toString();
  }

  Future<bool> save() async {
    List _categoriesList = [];
    for (var item in _games) {
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
        _games.add(Game.fromJson(json.decode(item)));
      }
      notifyListeners();
    }
  }

  Future<GameRunners?> getRunners(String gameHash) async {
    String? prefData = _prefs.getString(gameHash);
    if (prefData != null) {
      var data = json.decode(prefData);
      var returnArg = GameRunners.fromJson(json.decode(data[_fileName]));
      notifyListeners();
      return returnArg;
    }
    return null;
  }

  Future<void> setRunners(String gameHash, GameRunners gameRunners) async {
    await _prefs.setString(gameHash, json.encode(gameRunners.toJson()));
    notifyListeners();
  }
}

class Game {
  String hash;
  String name;
  String background;
  List<String> tags;
  List<String> category;
  String note;

  Game({
    required this.hash,
    required this.name,
    required this.background,
    required this.tags,
    required this.category,
    required this.note,
  });

  factory Game.fromJson(Map<String, dynamic> json) {
    return Game(
      hash: json["hash"],
      name: json["name"],
      background: json["background"],
      tags: List<String>.from(json["tags"] ?? []),
      category: List<String>.from(json["category"] ?? []),
      note: json["note"],
    );
  }

  @override
  String toString() {
    return "$name[$hash] # $tags";
  }

  String toJson() {
    return json.encode({
      "hash": hash,
      "name": name,
      "background": background,
      "tags": tags,
      "note": note,
    });
  }
}

class GameRunners {
  String hash;
  String mainRunner;
  List<Map<String, List<String>>> runnerList;
  GameRunners({
    required this.hash,
    required this.mainRunner,
    required this.runnerList,
  });

  factory GameRunners.fromJson(Map<String, dynamic> json) {
    return GameRunners(
      hash: json["hash"],
      mainRunner: json["mainRunner"],
      runnerList:
          List<Map<String, List<String>>>.from(json["runnerList"] ?? []),
    );
  }

  @override
  String toString() {
    return "$hash: $runnerList";
  }

  String toJson() {
    return json.encode({
      "hash": hash,
      "runnerList": runnerList,
    });
  }
}
