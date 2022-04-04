// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:mini_game_manager/games_pages/game_edit_page.dart';
import 'package:mini_game_manager/modules/custom_widgets.dart';
import 'package:mini_game_manager/providers/application_settings.dart';
import 'package:mini_game_manager/providers/game_data.dart';
import 'package:provider/provider.dart';

import 'package:mini_game_manager/game_view.dart';

final List<String> _dropDownItems = [
  'Run game',
  'Edit Details',
  'Remove Game',
];

dropDownAction(
  value,
  Function removeFunction,
) {
  int index = _dropDownItems.indexOf(value);
  if (index == 0) {
    print("To be implemented");
  } else if (index == 1) {
    print("To be implemented");
  } else if (index == 2) {
    removeFunction();
  }
}

openGameDetailView(BuildContext context, String gameHash) {
  showModalBottomSheet(
    elevation: 1,
    isDismissible: false,
    isScrollControlled: true,
    context: context,
    builder: (_) => GameView(
      gameHash: gameHash,
    ),
  );
}

class GamesMultiView extends StatelessWidget {
  final String title;
  final List<Game> games;
  late ApplicationSettings _appSetting;

  GamesMultiView({
    Key? key,
    required this.title,
    required this.games,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _appSetting = Provider.of<ApplicationSettings>(context);
    if (games.isNotEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(10),
        child: CustomSection(
          title: title.isEmpty ? "All Your Games" : title,
          child: viewBuilder(context),
        ),
      );
    }

    return Container(
      alignment: Alignment.center,
      child: Text(
        "No games were found",
        style: TextStyle(
          fontSize: 20,
          color: _appSetting.activeColorTheme.primaryText.shade500,
        ),
      ),
    );
  }

  Widget viewBuilder(BuildContext context) {
    if (_appSetting.libraryView == gameLibraryView.listView) {
      return ListView.builder(
        shrinkWrap: true,
        controller: ScrollController(),
        itemCount: games.length,
        itemBuilder: (BuildContext context, index) {
          return GameListView(game: games[index], remove: () {});
        },
      );
    } else if (_appSetting.libraryView == gameLibraryView.comfyView) {
      return ListView.builder(
        shrinkWrap: true,
        controller: ScrollController(),
        itemCount: games.length,
        itemBuilder: (BuildContext context, index) {
          return GameComfyView(game: games[index], remove: () {});
        },
      );
    } else {
      return GridView.builder(
        shrinkWrap: true,
        controller: ScrollController(),
        itemCount: games.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: MediaQuery.of(context).size.width > 900 ? 7 : 3,
          childAspectRatio: 0.8,
        ),
        itemBuilder: (BuildContext context, index) {
          return GameGridView(
              game: games[index],
              dropDownWidget: _DropDowns(
                runGame: () {},
                removeGame: () {},
                openGameDetails: () {},
              ));
        },
      );
    }
  }
}

class _DropDowns extends StatelessWidget {
  final Function runGame;
  final Function openGameDetails;
  final Function removeGame;
  _DropDowns(
      {Key? key,
      required this.runGame,
      required this.openGameDetails,
      required this.removeGame})
      : super(key: key);

  final List<String> _dropDownItems = [
    'Run game',
    'Edit Details',
    'Remove Game',
  ];

  dropDownAction(value) {
    int index = _dropDownItems.indexOf(value);
    if (index == 0) {
      runGame();
    } else if (index == 1) {
      openGameDetails();
    } else if (index == 2) {
      removeGame();
    }
  }

  @override
  Widget build(BuildContext context) {
    var _appSetting = Provider.of<ApplicationSettings>(context);
    return DropdownButtonHideUnderline(
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
            borderRadius:
                const BorderRadius.only(bottomRight: Radius.circular(10)),
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
        onChanged: (value) => dropDownAction(value),
      ),
    );
  }
}

class GameGridView extends StatelessWidget {
  final Game game;
  _DropDowns dropDownWidget;
  late ApplicationSettings _appSetting;

  GameGridView({
    Key? key,
    required this.game,
    required this.dropDownWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _appSetting = Provider.of<ApplicationSettings>(context);

    return Container(
      padding: const EdgeInsets.all(10),
      height: 300,
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => GameEditPage(
              gameHash: game.hash,
            ),
          ),
        ),
        child: Stack(
          children: [
            SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: Image.network(
                game.background,
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
            // NOTE Drop down widget
            dropDownWidget,
            Container(
              padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
              alignment: Alignment.bottomCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      game.name,
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
                    // TODO
                    onClick: () {
                      // runGame(_gameData, "gameKey");
                    },
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
  final Game game;
  final Function remove;
  late ApplicationSettings _appSetting;
  GameListView({
    Key? key,
    required this.game,
    required this.remove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _appSetting = Provider.of<ApplicationSettings>(context);
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
                game.background,
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
                      color: _appSetting.activeColorTheme.primaryText.shade200,
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
                  onChanged: (value) => dropDownAction(value, remove),
                ),
              ),
            ),
          ],
        ),
      ),
      title: Text(
        game.name,
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
        // TODO run game
        onClick: () async {
          // runGame(_gameData, gameKey);
        },
      ),
      onTap: () => openGameDetailView(context, game.hash),
    );
  }
}

class GameComfyView extends StatelessWidget {
  final Game game;
  final Function remove;
  late ApplicationSettings _appSetting;

  GameComfyView({
    Key? key,
    required this.game,
    required this.remove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _appSetting = Provider.of<ApplicationSettings>(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: InkWell(
        onTap: () => openGameDetailView(context, game.hash),
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
                      game.background,
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
                      onChanged: (value) => dropDownAction(value, remove),
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
                        game.name,
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      Text(
                        game.note.length < 1 ? "You have no notes" : game.note,
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
                  onClick: () {
                    // RunGame(_gameData, gameKey);
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
