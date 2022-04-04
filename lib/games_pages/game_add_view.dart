import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mini_game_manager/api/search_api.dart';
import 'package:mini_game_manager/modules/custom_widgets.dart';
import 'package:mini_game_manager/modules/file_management.dart';
import 'package:mini_game_manager/providers/application_settings.dart';
import 'package:mini_game_manager/providers/game_categories.dart';
import 'package:mini_game_manager/providers/game_data.dart';
import 'package:provider/provider.dart';
import 'package:desktop_drop/desktop_drop.dart';
import 'package:cross_file/cross_file.dart';

class GameAddView extends StatefulWidget {
  const GameAddView({Key? key}) : super(key: key);

  @override
  State<GameAddView> createState() => _GameAddViewState();
}

class _GameAddViewState extends State<GameAddView> {
  // Providers
  late ApplicationSettings _appSetting;
  late GameData _gameData;
  late GameCategories _gameCategories;

  late XFile? zipFile = null;
  late String zipFileName = "";
  bool _dragging = false;
  bool _toExpand = true;

  bool switchToBackgroundInput = true;
  final TextEditingController _nameTextController = TextEditingController();
  final TextEditingController _runnerTextController = TextEditingController();
  final TextEditingController _tagTextController = TextEditingController();
  final TextEditingController _categoryTextController = TextEditingController();

  String? _gameBackground;
  List<String> gameTags = [];
  List<String> gameCategories = [];
  List<Map<String, String>> gameRunners = [];

  String mainRunner = "";
  String backgroundImage = "";

  final _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    _appSetting = Provider.of<ApplicationSettings>(context);
    _gameData = Provider.of<GameData>(context);
    _gameCategories = Provider.of<GameCategories>(context);

    return Scaffold(
      backgroundColor: _appSetting.activeColorTheme.background,
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomSliver(
            title: "MODE:", //NOTE edit this
            expanded: _toExpand,
            backgroundUrl: _gameBackground ??
                "https://d1csarkz8obe9u.cloudfront.net/posterpreviews/zoom-background-template-design-002cc5a90615130ec4858f4b0505d468_screen.jpg?ts=1610889250",
          ),
          Expanded(
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
                  padding: const EdgeInsets.symmetric(
                      vertical: 30.0, horizontal: 30),
                  child: Column(
                    children: [
                      CustomSection(
                        title: "What's The Name",
                        child: TextFormField(
                          controller: _nameTextController,
                          onChanged: (_) => setState(() {}),
                        ),
                      ),
                      AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        child: _nameTextController.text.isNotEmpty
                            ? CustomSection(
                                title: "Choose Background",
                                child: TextFormField(
                                    readOnly: false,
                                    onTap: () async {
                                      String x = await showModalBottomSheet(
                                        isScrollControlled: true,
                                        builder: (context) => GoogleImagePicker(
                                          searchQuery: _nameTextController.text,
                                        ),
                                        context: context,
                                      );
                                      setState(() {
                                        _gameBackground = x;
                                      });
                                    }),
                              )
                            : const Center(),
                      ),
                      CustomSection(
                        title: "Add Your File",
                        child: Container(
                          child: dragDropSection(),
                        ),
                      ),
                      CustomSection(
                        title: "Choose Categories",
                        child: TextFormField(),
                      ),
                      CustomSection(
                        title: "Add Tags (optional)",
                        child: TextFormField(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  DropTarget dragDropSection() {
    return DropTarget(
      onDragDone: (detail) {
        for (var element in acceptedCompressed) {
          if (detail.files.first.path.contains(element)) {
            setState(() {
              zipFile = detail.files.first;
              zipFileName = detail.files.first.name;
            });
            break;
          } else {
            setState(() {
              zipFile = null;
              zipFileName = "You need a valid zip file";
            });
          }
        }
      },
      onDragEntered: (detail) {
        setState(() {
          _dragging = true;
        });
      },
      onDragExited: (detail) {
        setState(() {
          _dragging = false;
        });
      },
      child: Container(
        height: 100,
        color: _dragging
            ? _appSetting.activeColorTheme.primary.shade400
            : zipFile == null
                ? _appSetting.activeColorTheme.secondary.shade400
                : _appSetting.activeColorTheme.primary.shade400,
        child: zipFile == null
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.folder_zip_outlined),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(zipFile != null
                        ? zipFileName
                        : "Drag your compressed file here"),
                  ),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.folder_zip),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(zipFile!.path),
                  ),
                ],
              ),
      ),
    );
  }

  addGame() async {
    if (_formkey.currentState!.validate()) {
      bool validate = await _gameData.addGameToLibrary(
        name: _nameTextController.text,
        background: backgroundImage,
        tags: gameTags,
        category: gameCategories,
        note: '',
      );
      if (validate) {
        Navigator.pop(context);
        messenger("Added game to library");
      } else {
        messenger("Couldn't add new game");
      }
    } else {
      messenger("Please ensure you have the right data");
    }
  }

  // void updateBackground() async {
  //   String text = _backgroundTextController.text;
  //   text = await Navigator.push(
  //     context,
  //     MaterialPageRoute(builder: (context) {
  //       return GoogleImagePicker(
  //         searchQuery: text,
  //       );
  //     }),
  //   );
  //   setState(() {
  //     backgroundImage = text;
  //     _backgroundTextController.text = "";
  //   });
  // }

  void updateGameRunners() {
    if (_runnerTextController.text != "") {
      String key = _runnerTextController.text.split(RegExp(r'/|\\')).last;
      String val = _runnerTextController.text;
      gameRunners.firstWhere(
        (element) {
          return element.containsKey(key);
        },
        orElse: () {
          setState(() {
            mainRunner == "" ? mainRunner = _runnerTextController.text : null;
            gameRunners.add({key: val});
          });
          return {};
        },
      );

      _runnerTextController.text = "";
    } else {
      messenger('Field Cannot be empty');
    }
  }

  updateCateory() {
    setState(() {
      gameCategories.add(_categoryTextController.text);
      _categoryTextController.clear();
    });
  }

  removeCategoryGlobaly(String categoryName) async {
    FocusScope.of(context).unfocus();
    _gameCategories.removeCategoryByName(categoryName);
    setState(() {
      gameCategories.remove(categoryName);
    });
    _categoryTextController.text = "";
  }

  messenger(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        text,
        style: TextStyle(
          color: _appSetting.activeColorTheme.primaryText,
        ),
      ),
      backgroundColor: _appSetting.activeColorTheme.primaryAlt,
    ));
  }

  List<Widget> runnerBuilder() {
    List<Widget> itemList = [];
    for (var item in gameRunners) {
      itemList.add(
        GameRunnerAddCard(
          name: item.keys.toList()[0],
          isSelected: mainRunner == item.values.toList()[0] ? true : false,
          color: _appSetting.activeColorTheme.primaryAlt,
          onTap: () {
            setState(() {
              mainRunner = item.values.toList()[0];
            });
          },
          onRemove: () {
            setState(() {
              gameRunners.remove(item);
              if (gameRunners.isNotEmpty) {
                mainRunner = gameRunners[0].values.first;
              } else {
                mainRunner = "";
              }
            });
          },
        ),
      );
    }
    return itemList;
  }

  List<Widget> tagListBuilder(List<dynamic> items) {
    List<Widget> itemList = [];
    for (var item in items) {
      itemList.add(
        Padding(
          padding: const EdgeInsets.only(right: 5, bottom: 5),
          child: Chip(
            backgroundColor: _appSetting.activeColorTheme.secondaryAlt,
            label: Text("$item"),
            onDeleted: () => setState(() {
              items.remove(item);
            }),
          ),
        ),
      );
    }
    return itemList;
  }

  InputDecoration createDecoration(String title) {
    return InputDecoration(
      label: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
      border: OutlineInputBorder(
        borderSide:
            BorderSide(color: _appSetting.activeColorTheme.primary, width: 1.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide:
            BorderSide(color: _appSetting.activeColorTheme.primary, width: 1.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
            color: _appSetting.activeColorTheme.primaryAlt, width: 1.0),
      ),
      disabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.transparent, width: 1.0),
      ),
    );
  }

  Widget createInputBox(
    TextEditingController controller,
    String? Function(String? value) validator,
    Function onDone,
  ) {
    return Row(
      children: [
        SizedBox(
          width: 500,
          child: TextFormField(
            controller: controller,
            decoration: createDecoration(""),
            validator: (value) => validator(value),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: CustomButton(
            child: const Icon(Icons.check),
            color: _appSetting.activeColorTheme.primary,
            onClick: () => onDone(),
          ),
        ),
      ],
    );
  }
}
