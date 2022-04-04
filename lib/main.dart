import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';

import 'package:window_size/window_size.dart';
import 'package:provider/provider.dart';
import 'package:system_tray/system_tray.dart';
import 'package:flutter_window_close/flutter_window_close.dart';

import 'package:mini_game_manager/games_pages/game_add_view.dart';
import 'package:mini_game_manager/providers/game_categories.dart';
import 'package:mini_game_manager/providers/application_settings.dart';
import 'package:mini_game_manager/providers/game_data.dart';
import 'package:mini_game_manager/api/itch_io.dart';

void main() async {
  ItchIo.init();
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    setWindowTitle('Mini Game Manager');
    setWindowMinSize(const Size(800, 600));
    setWindowMaxSize((await getCurrentScreen())!.frame.size);
  }
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final SystemTray _systemTray = SystemTray();
  final AppWindow _appWindow = AppWindow();
  Timer? _timer;
  @override
  void initState() {
    super.initState();
    initSystemTray();
    FlutterWindowClose.setWindowShouldCloseHandler(() async {
      await _appWindow.hide();
      return false;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
  }

  Future<void> initSystemTray() async {
    String path = Platform.isWindows
        ? 'assets/image/app_icon.ico'
        : 'assets/app_icon.png';

    final menu = [
      MenuItem(label: 'Show', onClicked: _appWindow.show),
      MenuItem(label: 'Exit', onClicked: _appWindow.hide),
    ];

    // We first init the systray menu and then add the menu entries
    await _systemTray.initSystemTray(
      title: "MGL",
      iconPath: path,
      toolTip: "Mini Game Launcher",
    );

    await _systemTray.setContextMenu(menu);

    // handle system tray event
    _systemTray.registerSystemTrayEventHandler((eventName) {
      if (eventName == "leftMouseUp") {
        _appWindow.show();
      } else if (eventName == "rightMouseUp") {
        _systemTray.popUpContextMenu();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ApplicationSettings>(create: (_) {
          ApplicationSettings _local = ApplicationSettings();
          _local.init();
          return _local;
        }),
        ChangeNotifierProvider<GameCategories>(create: (_) {
          GameCategories _local = GameCategories();
          _local.init();
          return _local;
        }),
        ChangeNotifierProvider<GameData>(create: (_) {
          GameData _local = GameData();
          _local.init();
          return _local;
        }),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          brightness: Brightness.dark,
          primarySwatch: Colors.blue,
        ),
        home: const GameAddView(),
      ),
    );
  }
}
