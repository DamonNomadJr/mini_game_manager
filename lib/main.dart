import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:window_size/window_size.dart';
import 'package:provider/provider.dart';

import 'package:mini_game_manager/game_add_view.dart';
import 'package:mini_game_manager/providers/application_settings.dart';
import 'package:mini_game_manager/providers/game_data.dart';
import 'package:mini_game_manager/game_multi_view.dart';

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
  late String _searchText = "";
  late GameData games;
  late ApplicationSettings _appSetting;

  GridView gridViewBuilder(double width, double height) {
    List<Widget> list = [];
    games.data.forEach((key, value) {
      if ((value["name"] as String)
              .toLowerCase()
              .contains(_searchText.toLowerCase()) ||
          (value["tags"].toString())
              .toLowerCase()
              .contains(_searchText.toLowerCase())) {
        list.add(
          GameGridView(gameKey: key),
        );
      }
    });
    return GridView(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: width > 2000
            ? 7
            : width > 1000
                ? 5
                : width > 500
                    ? 3
                    : 1,
        childAspectRatio: height > 500 ? 0.8 : 0.4,
      ),
      shrinkWrap: true,
      children: list,
    );
  }

  Widget comfyViewBuilder() {
    List<Widget> list = [];
    games.data.forEach((key, value) {
      if ((value["name"] as String)
              .toLowerCase()
              .contains(_searchText.toLowerCase()) ||
          (value["tags"].toString())
              .toLowerCase()
              .contains(_searchText.toLowerCase())) {
        list.add(
          GameComfyView(gameKey: key),
        );
      }
    });
    return ListView(
      children: list,
    );
  }

  Widget listViewBuilder() {
    List<Widget> list = [];
    games.data.forEach((key, value) {
      if ((value["name"] as String)
              .toLowerCase()
              .contains(_searchText.toLowerCase()) ||
          (value["tags"].toString())
              .toLowerCase()
              .contains(_searchText.toLowerCase())) {
        list.add(
          GameListView(gameKey: key),
        );
      }
    });
    return ListView(
      children: list,
    );
  }

  List<DropdownMenuItem<gameLibraryView>>? viewOptions() {
    return [
      DropdownMenuItem<gameLibraryView>(
        value: gameLibraryView.gridView,
        child: Row(
          children: const [
            Icon(Icons.grid_view_outlined),
            Padding(padding: EdgeInsets.all(5)),
            Text("Grid View"),
          ],
        ),
      ),
      DropdownMenuItem<gameLibraryView>(
        value: gameLibraryView.comfyView,
        child: Row(
          children: const [
            Icon(Icons.view_agenda_outlined),
            Padding(padding: EdgeInsets.all(5)),
            Text("Comfy View"),
          ],
        ),
      ),
      DropdownMenuItem<gameLibraryView>(
        value: gameLibraryView.listView,
        child: Row(
          children: const [
            Icon(Icons.table_rows_outlined),
            Padding(padding: EdgeInsets.all(5)),
            Text("List View"),
          ],
        ),
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    _appSetting = Provider.of<ApplicationSettings>(context);
    games = Provider.of<GameData>(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: _appSetting.activeColorTheme.primary,
        foregroundColor: _appSetting.activeColorTheme.primaryText,
        child: const Icon(Icons.add),
        onPressed: () async {
          _showMaterialDialog(context);
        },
      ),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Form(
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
              DropdownButtonHideUnderline(
                child: DropdownButton2<gameLibraryView>(
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
                  customButton: Icon(
                    Icons.more_vert,
                    color: _appSetting.activeColorTheme.primaryText,
                  ),
                  items: viewOptions(),
                  onChanged: (val) {
                    _appSetting.setLibraryView(val!);
                  },
                ),
              ),
            ],
          ),
          Expanded(
            child: _appSetting.libraryView == gameLibraryView.gridView
                ? gridViewBuilder(width, height)
                : _appSetting.libraryView == gameLibraryView.comfyView
                    ? comfyViewBuilder()
                    : listViewBuilder(),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              color: Colors.black,
              child: Row(
                children: [
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
    );
  }

  void _showMaterialDialog(BuildContext context) {
    showModalBottomSheet(
      elevation: 1,
      isDismissible: false,
      isScrollControlled: true,
      context: context,
      builder: (_) => const GameAddView(),
    );
  }
}
