import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mini_game_manager/modules/file_management.dart';
import 'package:mini_game_manager/providers/game_data.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class GameView extends StatefulWidget {
  String reference;
  Map<String, dynamic> currentGameData;
  GameView({Key? key, required this.reference, required this.currentGameData})
      : super(key: key);

  @override
  State<GameView> createState() => _GameViewState();
}

class _GameViewState extends State<GameView> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _name;
  late TextEditingController _path;
  late TextEditingController _image;
  late List<dynamic> _tags;
  bool _editing = false;
  late GameData _games;

  InputDecoration createDecoration(String title) {
    return InputDecoration(
      label: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
      border: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white, width: 1.0),
      ),
      enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white, width: 1.0),
      ),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white, width: 1.0),
      ),
      disabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.transparent, width: 1.0),
      ),
    );
  }

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
    List<Widget> itemList = [
      Visibility(
        visible: _editing,
        child: Padding(
          padding: const EdgeInsets.only(right: 5, bottom: 5),
          child: TextButton(
            key: Key(_editing.toString()),
            style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100.0),
                  side: const BorderSide(
                    color: Colors.white,
                    width: 1.0,
                  ),
                ),
              ),
              backgroundColor: MaterialStateProperty.all(
                  const Color.fromARGB(90, 50, 50, 50)),
              foregroundColor: MaterialStateProperty.all(
                  const Color.fromARGB(255, 255, 255, 255)),
              overlayColor:
                  MaterialStateProperty.all(const Color.fromARGB(0, 0, 0, 0)),
              padding: MaterialStateProperty.all(
                  const EdgeInsets.fromLTRB(10, 10, 10, 10)),
            ),
            onPressed: () {
              addTag();
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.add),
                Text("Add Tags"),
              ],
            ),
          ),
        ),
      ),
    ];

    for (var item in _tags) {
      itemList.add(
        Padding(
          padding: const EdgeInsets.only(right: 5, bottom: 5),
          child: Chip(
            backgroundColor: Colors.pink,
            onDeleted: _editing
                ? () {
                    setState(() {
                      _tags.remove(item);
                    });
                  }
                : null,
            labelPadding: const EdgeInsets.fromLTRB(10, 1, 10, 1),
            label: Text("$item"),
          ),
        ),
      );
    }

    return itemList;
  }

  void addTag() {
    String _newTag = "";
    showDialog<void>(
        context: context,
        barrierDismissible: true, // user must tap button!
        barrierColor: const Color.fromARGB(190, 0, 0, 0),
        builder: (BuildContext context) {
          return AlertDialog(
            alignment: Alignment.bottomLeft,
            backgroundColor: const Color.fromARGB(255, 75, 75, 75),
            content: TextField(
              autofocus: true,
              onChanged: ((value) => _newTag = value),
              decoration: const InputDecoration(
                label: Text("Add a new Tag"),
                icon: Icon(Icons.local_offer),
              ),
            ),
            actions: <Widget>[
              TextButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      const Color.fromARGB(0, 0, 0, 0)),
                  foregroundColor: MaterialStateProperty.all(
                      const Color.fromARGB(255, 255, 65, 51)),
                  overlayColor: MaterialStateProperty.all(
                      const Color.fromARGB(30, 255, 255, 255)),
                  padding: MaterialStateProperty.all(
                      const EdgeInsets.fromLTRB(30, 10, 30, 10)),
                ),
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      const Color.fromARGB(0, 0, 0, 0)),
                  foregroundColor: MaterialStateProperty.all(
                      const Color.fromARGB(255, 255, 255, 255)),
                  overlayColor: MaterialStateProperty.all(
                      const Color.fromARGB(30, 255, 255, 255)),
                  padding: MaterialStateProperty.all(
                      const EdgeInsets.fromLTRB(30, 10, 30, 10)),
                ),
                child: const Text('Add'),
                onPressed: () {
                  if (_newTag.isNotEmpty &&
                      !_tags.toString().toLowerCase().contains(_newTag)) {
                    setState(() {
                      _tags.add(_newTag);
                    });
                  } else {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(cannotAddTagSnack);
                  }

                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    _games = Provider.of<GameData>(context);
    _name = TextEditingController(text: widget.currentGameData["game_name"]);
    _path = TextEditingController(text: widget.currentGameData["game_path"]);
    _image = TextEditingController(text: widget.currentGameData["game_icon"]);
    _tags = widget.currentGameData["game_tags"];
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // NOTE BACKGROUND
            Stack(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height / 3,
                  child: (widget.currentGameData["game_icon"]!.contains("http"))
                      ? Image.network(
                          widget.currentGameData["game_icon"]!,
                          alignment: Alignment.topCenter,
                          fit: BoxFit.cover,
                        )
                      : Image.network(
                          "https://s3.envato.com/files/1a8011a5-217f-4a8a-9618-c2ddefbe08e3/inline_image_preview.jpg",
                          alignment: Alignment.center,
                          fit: BoxFit.cover,
                        ),
                ),
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color.fromARGB(100, 0, 0, 0),
                        Color.fromARGB(255, 75, 75, 75),
                      ],
                    ),
                  ),
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height / 3,
                ),
                Positioned(
                  top: 10,
                  left: 10,
                  child: IconButton(
                    iconSize: 30,
                    color: _editing
                        ? const Color.fromARGB(149, 255, 125, 125)
                        : Colors.white,
                    onPressed: () {
                      if (_editing) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(cannotCloseSnack);
                      } else {
                        Navigator.pop(context);
                      }
                    },
                    icon: const Icon(Icons.arrow_back),
                  ),
                ),
              ],
            ),
            // NOTE RUN BUTTONS
            Container(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  TextButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          const Color.fromARGB(255, 255, 65, 51)),
                      foregroundColor: MaterialStateProperty.all(
                          const Color.fromARGB(255, 255, 255, 255)),
                      padding: MaterialStateProperty.all(
                          const EdgeInsets.fromLTRB(30, 20, 30, 20)),
                    ),
                    onPressed: () async {
                      Navigator.pop(context);
                      _games.removeData(widget.reference);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Icon(Icons.close),
                        Padding(padding: EdgeInsets.all(5)),
                        Text("Remove game"),
                      ],
                    ),
                  ),
                  const Padding(padding: EdgeInsets.all(5)),
                  TextButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          const Color.fromARGB(255, 13, 158, 25)),
                      foregroundColor: MaterialStateProperty.all(
                          const Color.fromARGB(255, 255, 255, 255)),
                      padding: MaterialStateProperty.all(
                          const EdgeInsets.fromLTRB(30, 20, 30, 20)),
                    ),
                    onPressed: () async {
                      await Process.run(
                          widget.currentGameData["game_path"], []);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Icon(Icons.play_arrow),
                        Padding(padding: EdgeInsets.all(5)),
                        Text("Run Game"),
                      ],
                    ),
                  ),
                  const Padding(padding: EdgeInsets.all(5)),
                  AnimatedSwitcher(
                    duration: Duration(milliseconds: 200),
                    child: TextButton(
                      key: Key(_editing.toString()),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            const Color.fromARGB(0, 0, 0, 0)),
                        foregroundColor: MaterialStateProperty.all(
                            const Color.fromARGB(255, 255, 255, 255)),
                        overlayColor: MaterialStateProperty.all(
                            const Color.fromARGB(0, 0, 0, 0)),
                        padding: MaterialStateProperty.all(
                            const EdgeInsets.fromLTRB(10, 20, 10, 20)),
                      ),
                      onPressed: () {
                        setState(() {
                          if (_editing && _formKey.currentState!.validate()) {
                            _games.updateData(widget.reference, {
                              "game_name": _name.text,
                              "game_icon": _image.text,
                              "game_path": _path.text,
                              "game_tags": widget.currentGameData["game_tags"]
                            });
                          }
                          _editing = !_editing;
                        });
                      },
                      child: _editing
                          ? const Icon(Icons.check)
                          : const Icon(Icons.edit),
                    ),
                  )
                ],
              ),
            ),
            // NOTE Editing section
            Container(
              padding: const EdgeInsets.fromLTRB(50, 20, 50, 30),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    enabled: _editing,
                    style: createTextStyle(),
                    cursorColor: Colors.white,
                    decoration: createDecoration("Game Name"),
                    controller: _name,
                  ),
                  const Padding(padding: EdgeInsets.all(5)),
                  TextFormField(
                    enabled: _editing,
                    style: createTextStyle(),
                    cursorColor: Colors.white,
                    decoration: createDecoration("Game Path"),
                    controller: _path,
                    readOnly: true,
                    onTap: () async {
                      _path.text = await pickFile() ?? _path.text;
                    },
                  ),
                  const Padding(padding: EdgeInsets.all(5)),
                  TextFormField(
                    enabled: _editing,
                    style: createTextStyle(),
                    cursorColor: Colors.white,
                    decoration: createDecoration("Background"),
                    controller: _image,
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          !(value.contains('http') &&
                              (value.contains('.png') ||
                                  value.contains('.jpg')))) {
                        return 'This is not a valid image url';
                      }
                      return null;
                    },
                  ),
                  const Padding(padding: EdgeInsets.all(5)),
                  const Text("Tags:"),
                  const Padding(padding: EdgeInsets.all(5)),
                  const Divider(
                    height: 0,
                    color: Colors.grey,
                  ),
                  const Padding(padding: EdgeInsets.all(5)),
                  Wrap(
                    alignment: WrapAlignment.start,
                    crossAxisAlignment: WrapCrossAlignment.start,
                    children: tagListBuilder(),
                  ),
                  const Padding(padding: EdgeInsets.all(5)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
