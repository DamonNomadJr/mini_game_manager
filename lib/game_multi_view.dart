// ignore_for_file: must_be_immutable

import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:mini_game_manager/modules/custom_widgets.dart';
import 'package:mini_game_manager/providers/application_settings.dart';
import 'package:mini_game_manager/providers/game_data.dart';
import 'package:provider/provider.dart';

import 'game_view.dart';

final List<String> _dropDownItems = [
  'Run game',
  'Edit Details',
  'Remove Game',
];

dropDownAction(context, value, gameData, gameKey) {
  int index = _dropDownItems.indexOf(value);
  if (index == 0) {
    runGame(gameData, gameKey);
  } else if (index == 1) {
    openGameDetails(context, gameKey);
  } else if (index == 2) {
    removeGame(gameData, gameKey);
  }
}

openGameDetailView(BuildContext context, String reference) {
  showModalBottomSheet(
    elevation: 1,
    isDismissible: false,
    isScrollControlled: true,
    context: context,
    builder: (_) => GameView(
      reference: reference,
    ),
  );
}

runGame(GameData gameData, String gameKey) async => await Process.run(
      gameData.data[gameKey]["main_runner"],
      [],
    );

openGameDetails(context, gameKey) async => openGameDetailView(context, gameKey);

removeGame(GameData gameData, String key) =>
    gameData.removeGameFromLibrary(key);

class GameGridView extends StatelessWidget {
  final String gameKey;
  late ApplicationSettings _appSetting;
  late GameData _gameData;

  GameGridView({
    Key? key,
    required this.gameKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _appSetting = Provider.of<ApplicationSettings>(context);
    _gameData = Provider.of<GameData>(context);

    return Container(
      padding: const EdgeInsets.all(10),
      height: 300,
      child: InkWell(
        onTap: () => openGameDetails(context, gameKey),
        child: Stack(
          children: [
            if (_gameData.data[gameKey]["backgroundImage"] != null)
              SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: Image.network(
                  _gameData.data[gameKey]["backgroundImage"],
                  alignment: Alignment.center,
                  fit: BoxFit.cover,
                ),
              ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    _appSetting.activeColorTheme.background.shade300,
                    _appSetting.activeColorTheme.background,
                  ],
                ),
              ),
            ),
            DropdownButtonHideUnderline(
              child: DropdownButton2(
                isExpanded: false,
                dropdownWidth: 200,
                dropdownDecoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(5),
                    bottomLeft: Radius.circular(5),
                    bottomRight: Radius.circular(5),
                  ),
                  color: _appSetting.activeColorTheme.backgroundAlt,
                ),
                customButton: Container(
                  decoration: BoxDecoration(
                    color: _appSetting.activeColorTheme.primaryText.shade200,
                    borderRadius: const BorderRadius.only(
                        bottomRight: Radius.circular(10)),
                  ),
                  padding: const EdgeInsets.all(5.0),
                  child: Icon(
                    Icons.more_vert,
                    color: _appSetting.activeColorTheme.primaryText,
                  ),
                ),
                items: _dropDownItems
                    .map((item) => DropdownMenuItem<String>(
                          value: item,
                          child: Text(
                            item,
                            style: TextStyle(
                              color: _appSetting.activeColorTheme.primaryText,
                            ),
                            overflow: TextOverflow.fade,
                          ),
                        ))
                    .toList(),
                onChanged: (value) =>
                    dropDownAction(context, value, _gameData, gameKey),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
              alignment: Alignment.bottomCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      _gameData.data[gameKey]["name"],
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 18,
                        color: _appSetting.activeColorTheme.primaryText,
                      ),
                    ),
                  ),
                  CustomButton(
                    padding: EdgeInsets.all(5),
                    color: Colors.transparent,
                    boxShadow: const [],
                    onClick: () => runGame(_gameData, gameKey),
                    child: const Icon(Icons.play_arrow),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class GameListView extends StatelessWidget {
  final String gameKey;
  late ApplicationSettings _appSetting;
  late GameData _gameData;
  GameListView({
    Key? key,
    required this.gameKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _appSetting = Provider.of<ApplicationSettings>(context);
    _gameData = Provider.of<GameData>(context);
    return ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 30),
        leading: SizedBox(
          width: 100,
          height: double.infinity,
          child: Stack(
            children: [
              SizedBox(
                width: 100,
                child: Image.network(
                  _gameData.data[gameKey]["backgroundImage"],
                  fit: BoxFit.cover,
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: DropdownButtonHideUnderline(
                  child: DropdownButton2(
                    isExpanded: false,
                    dropdownWidth: 200,
                    dropdownDecoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(5),
                        bottomLeft: Radius.circular(5),
                        bottomRight: Radius.circular(5),
                      ),
                      color: _appSetting.activeColorTheme.backgroundAlt,
                    ),
                    customButton: Container(
                      alignment: Alignment.centerLeft,
                      height: double.infinity,
                      decoration: BoxDecoration(
                        color:
                            _appSetting.activeColorTheme.primaryText.shade200,
                      ),
                      padding: const EdgeInsets.all(5.0),
                      child: Icon(
                        Icons.more_vert,
                        color: _appSetting.activeColorTheme.primaryText,
                      ),
                    ),
                    items: _dropDownItems
                        .map((item) => DropdownMenuItem<String>(
                              value: item,
                              child: Text(
                                item,
                                style: TextStyle(
                                  color:
                                      _appSetting.activeColorTheme.primaryText,
                                ),
                                overflow: TextOverflow.fade,
                              ),
                            ))
                        .toList(),
                    onChanged: (value) =>
                        dropDownAction(context, value, _gameData, gameKey),
                  ),
                ),
              ),
            ],
          ),
        ),
        title: Text(
          _gameData.data[gameKey]["name"],
          style: const TextStyle(
            fontSize: 20,
          ),
        ),
        trailing: CustomButton(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.play_arrow),
                Padding(padding: EdgeInsets.all(5)),
                Text("Run Game"),
              ],
            ),
            color: _appSetting.activeColorTheme.primary,
            onClick: () async => runGame(_gameData, gameKey)),
        onTap: () => openGameDetails(context, gameKey));
  }
}

class GameComfyView extends StatelessWidget {
  final String gameKey;
  late ApplicationSettings _appSetting;
  late GameData _gameData;

  GameComfyView({
    Key? key,
    required this.gameKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _appSetting = Provider.of<ApplicationSettings>(context);
    _gameData = Provider.of<GameData>(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: InkWell(
        onTap: () => openGameDetails(context, gameKey),
        child: Container(
          height: 150,
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 0),
          child: Row(
            children: [
              Stack(
                children: [
                  SizedBox(
                    width: 200,
                    height: double.infinity,
                    child: Image.network(
                      _gameData.data[gameKey]["backgroundImage"],
                      fit: BoxFit.cover,
                    ),
                  ),
                  Container(
                    width: 200,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          _appSetting.activeColorTheme.background.shade300,
                          _appSetting.activeColorTheme.background,
                        ],
                      ),
                    ),
                  ),
                  DropdownButtonHideUnderline(
                    child: DropdownButton2(
                      isExpanded: false,
                      dropdownWidth: 200,
                      dropdownDecoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(5),
                          bottomLeft: Radius.circular(5),
                          bottomRight: Radius.circular(5),
                        ),
                        color: _appSetting.activeColorTheme.backgroundAlt,
                      ),
                      customButton: Container(
                        decoration: BoxDecoration(
                          color:
                              _appSetting.activeColorTheme.primaryText.shade200,
                          borderRadius: const BorderRadius.only(
                              bottomRight: Radius.circular(10)),
                        ),
                        padding: const EdgeInsets.all(5.0),
                        child: Icon(
                          Icons.more_vert,
                          color: _appSetting.activeColorTheme.primaryText,
                        ),
                      ),
                      items: _dropDownItems
                          .map((item) => DropdownMenuItem<String>(
                                value: item,
                                child: Text(
                                  item,
                                  style: TextStyle(
                                    color: _appSetting
                                        .activeColorTheme.primaryText,
                                  ),
                                  overflow: TextOverflow.fade,
                                ),
                              ))
                          .toList(),
                      onChanged: (value) =>
                          dropDownAction(context, value, _gameData, gameKey),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _gameData.data[gameKey]["name"],
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      Text(
                        _gameData.data[gameKey]["note"] ?? "You have no notes",
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                alignment: Alignment.center,
                child: CustomButton(
                  color: _appSetting.activeColorTheme.primary,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Icon(Icons.play_arrow),
                      Padding(padding: EdgeInsets.all(5)),
                      Text("Run Game"),
                    ],
                  ),
                  onClick: () => runGame(_gameData, gameKey),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
