import 'dart:io';
import 'package:flutter/gestures.dart';
import 'package:mini_game_manager/game_view.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:window_size/window_size.dart';

import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:mini_game_manager/modules/file_management.dart';
import 'package:mini_game_manager/providers/application_settings.dart';
import 'package:mini_game_manager/providers/game_data.dart';

import 'cards.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    setWindowTitle('Mini Game Manager');
    setWindowMinSize(const Size(800, 600));
    setWindowMaxSize((await getCurrentScreen())!.frame.size);
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
  late GameData games;
  late String _searchText = "";

  List<Widget> buildList() {
    List<Widget> list = [];
    games.data.forEach((key, value) {
      if (_searchText == "" || _searchText.isEmpty) {
        list.add(Cards(
          onRun: () => Process.run(value["game_path"], []),
          imageIcon: value["game_icon"],
          name: value["game_name"],
          onSettings: () => openGameDetailView(
              key, value, () => Process.run(value["game_path"], [])),
        ));
      } else {
        if ((value["game_name"] as String)
                .toLowerCase()
                .contains(_searchText.toLowerCase()) ||
            (value["game_tags"].toString())
                .toLowerCase()
                .contains(_searchText.toLowerCase())) {
          list.add(Cards(
            onRun: () => Process.run(value["game_path"], []),
            imageIcon: value["game_icon"],
            name: value["game_name"],
            onSettings: () => openGameDetailView(
                key, value, () => Process.run(value["game_path"], [])),
          ));
        }
      }
    });
    return list;
  }

  openGameDetailView(
      String reference, Map<String, dynamic> data, Function onRun) {
    showModalBottomSheet(
      elevation: 1,
      // backgroundColor: const Color.fromARGB(255, 75, 75, 75),
      isDismissible: false,
      isScrollControlled: true,
      context: context,
      builder: (_) => Scaffold(
        backgroundColor: const Color.fromARGB(255, 75, 75, 75),
        body: GameView(
          reference: reference,
          currentGameData: data,
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.grey,
        onPressed: () async {
          var path = await pickFile();
          if (path != null) games.addData(path.toString(), []);
        },
        child: const Icon(Icons.add),
      ),
      body: Stack(
        children: [
          Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    Form(
                      child: Expanded(
                        child: TextFormField(
                          decoration: const InputDecoration(
                            icon: Icon(Icons.search),
                            label: Text("Search"),
                            border: InputBorder.none,
                          ),
                          onChanged: (input) {
                            setState(() {
                              _searchText = input;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: GridView(
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
                    mainAxisSpacing: 10,
                  ),
                  shrinkWrap: true,
                  children: buildList(),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                  color: Colors.black,
                  child: Row(
                    children: [
                      // Text(
                      //     "Game Directory: \"${settings.data["games_directory"]}\""),
                      // TextButton(
                      //   onPressed: () async {
                      //     settings.setGameDirectory(await pickFolder());
                      //   },
                      //   child: const Text("UPDATE IT"),
                      // ),
                      // Text(file_path),
                      RichText(
                        text: TextSpan(children: [
                          const TextSpan(
                            text: 'Check the latest version on ',
                            style: TextStyle(),
                          ),
                          TextSpan(
                            recognizer: TapGestureRecognizer()
                              ..onTap = () async {
                                await launch(
                                    "https://github.com/DamonNomadJr/mini_game_manager");
                              },
                            text: 'Github',
                            style: const TextStyle(
                              color: Colors.blue,
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ]),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
