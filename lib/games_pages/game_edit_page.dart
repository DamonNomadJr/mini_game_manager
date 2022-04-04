// ignore_for_file: must_be_immutable

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:provider/provider.dart';

import 'package:mini_game_manager/providers/game_categories.dart';
import 'package:mini_game_manager/providers/game_data.dart';
import 'package:mini_game_manager/modules/custom_widgets.dart';
import 'package:mini_game_manager/providers/application_settings.dart';

enum editModes {
  createNew,
  editCurrent,
}

class GameEditPage extends StatefulWidget {
  final String gameHash;
  const GameEditPage({Key? key, this.gameHash = ""}) : super(key: key);

  @override
  State<GameEditPage> createState() => _GameEditPageState();
}

class _GameEditPageState extends State<GameEditPage>
    with SingleTickerProviderStateMixin {
  late ApplicationSettings _appSetting;
  late GameData _gameData;
  late GameCategories _gameCategories;

  bool _toExpand = true;
  late PageController pageController = PageController();

  @override
  void initState() {
    super.initState();
  }

  Game? gameInfo;
  GameRunners? gameRunners;
  List<String> gameCategory = [];
  bool editingMode = false;

  Future<editModes> loadGameData() async {
    if (widget.gameHash.isEmpty) {
      return editModes.createNew;
    } else {
      gameInfo = _gameData.getGameByHash(widget.gameHash);
      gameRunners = await _gameData.getRunners(widget.gameHash);
      gameCategory = _gameCategories.getCategoriesOfGame(widget.gameHash);
      // If game is not found and no runners were associated =>
      if (gameInfo == null && gameRunners == null) {
        return editModes.createNew;
      }
      // If no game is found and a runners was found =>
      else if (gameInfo == null && gameRunners != null) {
        // Add logic to remove existing runners
        return editModes.createNew;
      }
      return editModes.editCurrent;
    }
  }

  @override
  Widget build(BuildContext context) {
    _appSetting = Provider.of<ApplicationSettings>(context);
    _gameData = Provider.of<GameData>(context);
    _gameCategories = Provider.of<GameCategories>(context);

    return Scaffold(
      backgroundColor: _appSetting.activeColorTheme.background,
      body: FutureBuilder<editModes>(
        future: loadGameData(),
        builder: (BuildContext context, AsyncSnapshot<editModes> snapshot) {
          if (snapshot.hasData) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomSliver(
                  title: "MODE: ${snapshot.data}", //NOTE edit this
                  expanded: _toExpand,
                  backgroundUrl: gameInfo!.background,
                  bottomChildren: Row(
                    children: [
                      CustomInfoBox(
                        leadingIcon: Icons.info,
                        title: "Hours played",
                        subTitltle: "1000 hrs",
                      ),
                      CustomInfoBox(
                        leadingIcon: FontAwesomeIcons.clock,
                        title: "Last played",
                        subTitltle: "March 1st",
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SizedBox(
                    width: double.infinity,
                    child: NotificationListener<UserScrollNotification>(
                      onNotification: (notification) {
                        setState(() {
                          if (notification.direction ==
                              ScrollDirection.reverse) {
                            _toExpand = false;
                          } else if (notification.direction ==
                                  ScrollDirection.forward &&
                              notification.metrics.pixels <= 20) {
                            _toExpand = true;
                          }
                        });
                        return true;
                      },
                      child: SingleChildScrollView(
                        controller: ScrollController(),
                        dragStartBehavior: DragStartBehavior.down,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            // Left Side
                            Expanded(
                              flex: 7,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 20),
                                child: gameDetailsLeftSide(),
                              ),
                            ),

                            // Right side
                            Expanded(
                              flex: 3,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 20),
                                child: gameDetailsRightSide(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
          return Center(
            child: CircularProgressIndicator(
              color: _appSetting.activeColorTheme.primary,
            ),
          );
        },
      ),
    );
  }

  Widget gameDetailsLeftSide() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        SizedBox(
          width: double.infinity,
          child: CustomSection(
              title: "Runners",
              child: Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Wrap(
                  children: [
                    CustomRunnerInfoBox(
                      title: "Runner 1",
                    ),
                    CustomRunnerInfoBox(
                      title: "Runner 2",
                    )
                  ],
                ),
              )),
        ),
        SizedBox(
          width: double.infinity,
          child: CustomSection(
            title: "Categories",
            child: Wrap(
              alignment: WrapAlignment.start,
              crossAxisAlignment: WrapCrossAlignment.start,
              children: tagListBuilder(gameCategory),
            ),
          ),
        ),
        SizedBox(
          width: double.infinity,
          child: CustomSection(
            title: "Tags",
            child: Wrap(
              alignment: WrapAlignment.start,
              crossAxisAlignment: WrapCrossAlignment.start,
              children: tagListBuilder(gameInfo!.tags),
            ),
          ),
        ),
      ],
    );
  }

  Widget gameDetailsRightSide() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: SizedBox(
            width: double.infinity,
            child: CustomSection(
              title: "Notes",
              child: Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                child: yourNotes(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget yourNotes() {
    return SizedBox(
      height: 300,
      child: TextField(
        onTap: () {
          setState(() {
            editingMode = true;
          });
        },
        maxLines: double.maxFinite.toInt(),
        decoration: const InputDecoration(
          hintText: "Write your notes...",
        ),
      ),
    );
  }

  List<Widget> tabBarButtons() {
    return const [
      Tab(
        icon: Icon(Icons.info),
        text: "Game Details",
      ),
      Tab(
        icon: Icon(Icons.person),
        text: "Your Notes",
      )
    ];
  }

  List<Widget> tagListBuilder(List<String> items) {
    List<Widget> itemList = [];

    for (var item in items) {
      itemList.add(
        Padding(
          padding: const EdgeInsets.only(right: 5, bottom: 5),
          child: Chip(
            backgroundColor: _appSetting.activeColorTheme.secondaryAlt,
            label: Text(item),
          ),
        ),
      );
    }
    return itemList;
  }
}
