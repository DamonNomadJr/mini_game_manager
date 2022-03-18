import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:mini_game_manager/modules/custom_widgets.dart';
import 'package:mini_game_manager/modules/file_management.dart';
import 'package:mini_game_manager/providers/application_settings.dart';
import 'package:mini_game_manager/providers/game_data.dart';
import 'package:provider/provider.dart';

class GameAddView extends StatefulWidget {
  const GameAddView({Key? key}) : super(key: key);

  @override
  State<GameAddView> createState() => _GameAddViewState();
}

class _GameAddViewState extends State<GameAddView> {
  late ApplicationSettings _appSetting;
  late GameData _gameData;
  final _formkey = GlobalKey<FormState>();

  bool switchToBackgroundInput = true;
  final TextEditingController _backgroundTextController =
      TextEditingController();
  final TextEditingController _nameTextController = TextEditingController();
  final TextEditingController _runnerTextController = TextEditingController();
  final TextEditingController _tagTextController = TextEditingController();
  final TextEditingController _categoryTextController = TextEditingController();

  List<String> gameTags = [];
  List<String> gameCategories = [];
  List<Map<String, String>> gameRunners = [];

  String mainRunner = "";
  String backgroundImage = "";

  @override
  Widget build(BuildContext context) {
    _appSetting = Provider.of<ApplicationSettings>(context);
    _gameData = Provider.of<GameData>(context);

    return Scaffold(
      backgroundColor: _appSetting.activeColorTheme.background,
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomSliver(
            title: "Add a new game",
            expanded: true,
            backgroundUrl: backgroundImage,
            bottomChildren: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                AnimatedSwitcher(
                  duration: Duration.zero,
                  child: switchToBackgroundInput
                      ? CustomButton(
                          child: Row(
                            children: const [
                              Text("Change Background"),
                              Icon(Icons.add),
                            ],
                          ),
                          color: _appSetting.activeColorTheme.primary,
                          onClick: () {
                            setState(() {
                              switchToBackgroundInput =
                                  !switchToBackgroundInput;
                            });
                          },
                        )
                      : createInputBox(
                          _backgroundTextController,
                          (value) {
                            return null;
                          },
                          () => setState(() {
                            updateBackground();
                            switchToBackgroundInput = !switchToBackgroundInput;
                          }),
                        ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Form(
                key: _formkey,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomSection(
                        title: "Game Name",
                        child: SizedBox(
                          width: 500,
                          child: TextFormField(
                            controller: _nameTextController,
                            decoration: createDecoration(""),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Game filed cannot be empty";
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      CustomSection(
                        title: "Game Runners",
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  width: 500,
                                  child: TextFormField(
                                      controller: _runnerTextController,
                                      decoration: createDecoration(""),
                                      validator: (_) {
                                        if (mainRunner == "" ||
                                            gameRunners.isEmpty) {
                                          return "Set atleast one game runner";
                                        }
                                        return null;
                                      },
                                      onTap: () async {
                                        _runnerTextController.text =
                                            await pickFile() ?? "";
                                      }),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: CustomButton(
                                    child: const Icon(Icons.check),
                                    color: _appSetting.activeColorTheme.primary,
                                    onClick: () => updateGameRunners(),
                                  ),
                                ),
                              ],
                            ),
                            Wrap(
                              children: runnerBuilder(),
                            ),
                          ],
                        ),
                      ),
                      CustomSection(
                        title: "Add Tags",
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            createInputBox(_tagTextController, (value) {
                              if (value.toString().isNotEmpty) {
                                return "Remember to finish adding tags";
                              }
                              return null;
                            }, () {
                              setState(() {
                                gameTags.add(_tagTextController.text);
                              });

                              _tagTextController.clear();
                            }),
                            Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: Wrap(
                                children: [...tagListBuilder(gameTags)],
                              ),
                            )
                          ],
                        ),
                      ),
                      CustomSection(
                        title: "Add New Category",
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  width: 500,
                                  child: TypeAheadField(
                                    textFieldConfiguration:
                                        TextFieldConfiguration(
                                      controller: _categoryTextController,
                                      decoration: createDecoration(""),
                                    ),
                                    suggestionsCallback: (pattern) async {
                                      List<String> localList = [];
                                      for (var item
                                          in _gameData.categories.keys) {
                                        if (item
                                            .toLowerCase()
                                            .contains(pattern.toLowerCase())) {
                                          localList.add(item);
                                        }
                                      }
                                      return localList;
                                    },
                                    itemBuilder: (context, suggestion) {
                                      return ListTile(
                                        leading: const Icon(Icons.label),
                                        title: Text(suggestion.toString()),
                                        trailing: IconButton(
                                            visualDensity:
                                                VisualDensity.compact,
                                            icon:
                                                const Icon(Icons.remove_circle),
                                            onPressed: () async =>
                                                removeCategoryGlobaly(
                                                    suggestion.toString())),
                                      );
                                    },
                                    onSuggestionSelected: (suggestion) {
                                      _categoryTextController.text =
                                          suggestion.toString();
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: CustomButton(
                                      child: const Icon(Icons.check),
                                      color:
                                          _appSetting.activeColorTheme.primary,
                                      onClick: () async => updateCateory()),
                                )
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: Wrap(
                                children: [...tagListBuilder(gameCategories)],
                              ),
                            ),
                          ],
                        ),
                      ),
                      CustomButton(
                        child: const Text("Done"),
                        color: Colors.red,
                        onClick: () => addGame(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  addGame() {
    if (_formkey.currentState!.validate()) {
      if (_gameData.data
          .containsKey(_nameTextController.text.hashCode.toString())) {
        messenger("Game alreay exists");
      } else {
        Navigator.pop(context);
        messenger("Adding game to library");
        _gameData.addGameToLibrary(
            gameName: _nameTextController.text,
            gameBackogundImage: _backgroundTextController.text,
            mainRunner: mainRunner,
            tags: gameTags,
            runners: gameRunners);
        for (String item in gameCategories) {
          _gameData.addGameToCategory(
              item, _nameTextController.text.hashCode.toString());
        }
      }
    } else {
      messenger("Please ensure you have the right data");
    }
  }

  void updateBackground() {
    setState(() {
      if (_backgroundTextController.text.endsWith('.jpg') ||
          _backgroundTextController.text.endsWith('.png')) {
        backgroundImage = _backgroundTextController.text;
      } else {
        messenger("Background URL is not an image type JPG or PNG");
        _backgroundTextController.text = "";
        backgroundImage = "";
      }
    });
  }

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

  updateCateory() async {
    await _gameData.addNewCategory(_categoryTextController.text);
    setState(() {
      gameCategories.add(_categoryTextController.text);
      _categoryTextController.clear();
    });
  }

  removeCategoryGlobaly(String categoryName) async {
    FocusScope.of(context).unfocus();
    _gameData.removeCategory(categoryName);
    setState(() {
      gameCategories.remove(categoryName);
    });
    _categoryTextController.text = "";
  }

  messenger(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(text),
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
