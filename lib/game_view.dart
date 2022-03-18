import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mini_game_manager/modules/custom_widgets.dart';
import 'package:mini_game_manager/providers/application_settings.dart';
import 'package:mini_game_manager/providers/game_data.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class GameView extends StatefulWidget {
  String reference;
  GameView({Key? key, required this.reference}) : super(key: key);

  @override
  State<GameView> createState() => _GameViewState();
}

class _GameViewState extends State<GameView> {
  late Map<String, dynamic> currentGame;
  late ApplicationSettings _appSetting;
  bool _toExpand = true;

  final cannotCloseSnack = const SnackBar(
    elevation: 1000,
    content: Text('Cannot Close while editing'),
  );

  final cannotAddTagSnack = const SnackBar(
    elevation: 1000,
    content: Text('Tag was not added'),
  );

  TextStyle createTextStyle() {
    return const TextStyle(
      color: Colors.white,
      decorationColor: Colors.white,
    );
  }

  List<Widget> tagListBuilder() {
    List<Widget> itemList = [];

    for (var item in currentGame["tags"]) {
      itemList.add(
        Padding(
          padding: const EdgeInsets.only(right: 5, bottom: 5),
          child: Chip(
            backgroundColor: _appSetting.activeColorTheme.secondaryAlt,
            label: Text("$item"),
          ),
        ),
      );
    }

    return itemList;
  }

  @override
  Widget build(BuildContext context) {
    _appSetting = Provider.of<ApplicationSettings>(context);
    currentGame = (Provider.of<GameData>(context)).data[widget.reference];
    return Scaffold(
      backgroundColor: _appSetting.activeColorTheme.background,
      body: Column(
        children: [
          CustomSliver(
            title: currentGame["name"],
            expanded: _toExpand,
            backgroundUrl: currentGame["backgroundImage"],
            bottomChildren: Row(
              children: [
                CustomButton(
                  color: _appSetting.activeColorTheme.primary,
                  onClick: () async => await Process.run(
                    currentGame["main_runner"],
                    [],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Icon(Icons.play_arrow),
                      Padding(padding: EdgeInsets.all(5)),
                      Text("Run Game"),
                    ],
                  ),
                ),
                CustomButton(
                  color: Colors.transparent,
                  borderRadius: 100,
                  boxShadow: const [],
                  onClick: () {},
                  child: const Icon(Icons.edit),
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
                    if (notification.direction == ScrollDirection.reverse) {
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
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomSection(
                          title: "Your notes",
                          child: currentGame.containsKey("notes")
                              ? Text(currentGame["notes"])
                              : const Text("You have no notes"),
                        ),
                        CustomSection(
                          title: "Tags",
                          child: Wrap(
                            alignment: WrapAlignment.start,
                            crossAxisAlignment: WrapCrossAlignment.start,
                            children: tagListBuilder(),
                          ),
                        ),
                        const Padding(padding: EdgeInsets.only(top: 10000))
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
