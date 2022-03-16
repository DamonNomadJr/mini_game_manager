import 'dart:io';
import 'package:window_size/window_size.dart';

import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:mini_game_manager/modules/file_management.dart';
import 'package:mini_game_manager/providers/application_settings.dart';
import 'package:mini_game_manager/providers/game_data.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    setWindowTitle('Mini Game Manager');
    setWindowMinSize(const Size(400, 300));
    setWindowMaxSize((await getCurrentScreen())!.frame.size);
    // setWindowMaxSize(Size.infinite);
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ApplicationSettings>(create: (_) {
          ApplicationSettings appSett = ApplicationSettings();
          appSett.init();
          return appSett;
        }),
        ChangeNotifierProvider<GameData>(create: (_) {
          GameData games = GameData();
          games.init();
          return games;
        }),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          brightness: Brightness.dark,
          primarySwatch: Colors.blue,
        ),
        home: const MyHomePage(title: 'Flutter Demo Home Pag 2e'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String file_path = "";
  List<String> myProducts = [];
  late GameData games;
  List<Widget> buildList() {
    List<Widget> list = [];
    games.data.forEach((key, value) {
      list.add(Cards(
        onRun: () => Process.run(value["game_path"], []),
        imageIcon: value["game_icon"],
        name: value["game_name"],
        onSettings: () => changeGameData(
            key, value, () => Process.run(value["game_path"], [])),
      ));
    });
    return list;
  }

  changeGameData(String reference, Map<String, dynamic> data, Function onRun) {
    final _formKey = GlobalKey<FormState>();
    TextEditingController _name =
        TextEditingController(text: data["game_name"]);
    TextEditingController _path =
        TextEditingController(text: data["game_path"]);
    TextEditingController _image =
        TextEditingController(text: data["game_icon"]);
    showModalBottomSheet(
      backgroundColor: Color.fromARGB(255, 75, 75, 75),
      isScrollControlled: true,
      context: context,
      builder: (_) => SizedBox(
        width: 800,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Stack(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height / 3,
                    child: (data["game_icon"]!.contains("http"))
                        ? Image.network(
                            data["game_icon"]!,
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
                          color: Colors.white,
                          onPressed: () => Navigator.pop(context),
                          icon: Icon(Icons.close)))
                ],
              ),
              Container(
                padding: EdgeInsets.all(10),
                child: Row(
                  children: [
                    TextButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            Color.fromARGB(255, 255, 65, 51)),
                        foregroundColor: MaterialStateProperty.all(
                            Color.fromARGB(255, 255, 255, 255)),
                        padding: MaterialStateProperty.all(
                            const EdgeInsets.fromLTRB(30, 20, 30, 20)),
                      ),
                      onPressed: () async {
                        await games.removeData(reference);
                        Navigator.pop(context);
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
                            Color.fromARGB(255, 13, 158, 25)),
                        foregroundColor: MaterialStateProperty.all(
                            Color.fromARGB(255, 255, 255, 255)),
                        padding: MaterialStateProperty.all(
                            const EdgeInsets.fromLTRB(30, 20, 30, 20)),
                      ),
                      onPressed: () async {
                        onRun();
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
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      style: const TextStyle(
                        color: Colors.white,
                        decorationColor: Colors.white,
                      ),
                      cursorColor: Colors.white,
                      decoration: const InputDecoration(
                        label: Text(
                          "Game Name",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.white, width: 1.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.white, width: 1.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.white, width: 1.0),
                        ),
                      ),
                      controller: _name,
                    ),
                    const Padding(padding: EdgeInsets.all(5)),
                    TextFormField(
                      style: const TextStyle(
                        color: Colors.white,
                        decorationColor: Colors.white,
                      ),
                      cursorColor: Colors.white,
                      decoration: const InputDecoration(
                        label: Text(
                          "Game Path",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.white, width: 1.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.white, width: 1.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.white, width: 1.0),
                        ),
                      ),
                      controller: _path,
                      readOnly: true,
                      onTap: () async {
                        _path.text = await pickFile() ?? _path.text;
                      },
                    ),
                    const Padding(padding: EdgeInsets.all(5)),
                    TextFormField(
                      style: const TextStyle(
                        color: Colors.white,
                        decorationColor: Colors.white,
                      ),
                      cursorColor: Colors.white,
                      decoration: const InputDecoration(
                        label: Text(
                          "Background URL",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.white, width: 1.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.white, width: 1.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.white, width: 1.0),
                        ),
                      ),
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
                    Text(data["game_tags"].toString()),
                    const Padding(padding: EdgeInsets.all(5)),
                    TextButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          Map<String, dynamic> updates = {
                            "game_name": _name.text,
                            "game_icon": _image.text,
                            "game_path": _path.text,
                            "game_tags": data["game_tags"]
                          };
                          games.updateData(reference, updates);
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Saving Data'),
                            ),
                          );
                        }
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            const Color.fromARGB(255, 31, 31, 31)),
                        foregroundColor: MaterialStateProperty.all(
                            const Color.fromARGB(255, 255, 255, 255)),
                        padding: MaterialStateProperty.all(
                            const EdgeInsets.fromLTRB(20, 20, 20, 20)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(Icons.refresh),
                          Padding(padding: EdgeInsets.all(5)),
                          Text("Update Game Info"),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    var settings = Provider.of<ApplicationSettings>(context);
    games = Provider.of<GameData>(context);
    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            GridView(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: width > 2000
                      ? 8
                      : width > 1000
                          ? 6
                          : width > 500
                              ? 4
                              : 2,
                  childAspectRatio: height > 500 ? 0.8 : 0.4,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 20),
              shrinkWrap: true,
              children: buildList(),
            ),
            Positioned(
              bottom: 0,
              child: Row(
                children: [
                  Text(
                      "Game Directory: \"${settings.data["games_directory"]}\""),
                  TextButton(
                    onPressed: () async {
                      settings.setGameDirectory(await pickFolder());
                    },
                    child: Text("UPDATE IT"),
                  ),
                  Text(file_path),
                  TextButton(
                    onPressed: () async {
                      var path = await pickFile();
                      if (path != null) games.addData(path.toString(), []);
                    },
                    child: const Text("Add Games"),
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

class Cards extends StatelessWidget {
  // late String? backgroundImage;
  final String name;
  final String? imageIcon;
  final Function onSettings;
  final Function onRun;
  const Cards({
    Key? key,
    required this.name,
    required this.imageIcon,
    required this.onSettings,
    required this.onRun,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => onSettings(),
        child: SizedBox(
          height: 300,
          child: Stack(
            children: [
              if (imageIcon != null)
                SizedBox(
                    width: double.infinity,
                    height: double.infinity,
                    child: (imageIcon!.contains("http"))
                        ? Image.network(
                            imageIcon!,
                            alignment: Alignment.center,
                            fit: BoxFit.cover,
                          )
                        : Image.network(
                            "https://s3.envato.com/files/1a8011a5-217f-4a8a-9618-c2ddefbe08e3/inline_image_preview.jpg",
                            alignment: Alignment.center,
                            fit: BoxFit.cover,
                          )),
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color.fromARGB(75, 0, 0, 0),
                      Color.fromARGB(255, 75, 75, 75),
                    ],
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(left: 10, right: 10),
                alignment: Alignment.bottomCenter,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FittedBox(
                      fit: BoxFit.contain,
                      child: Text(
                        name,
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                    IconButton(
                      enableFeedback: false,
                      iconSize: 30,
                      color: Color.fromARGB(255, 13, 158, 25),
                      focusColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onPressed: () {
                        onRun();
                      },
                      icon: const Icon(Icons.play_arrow),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
