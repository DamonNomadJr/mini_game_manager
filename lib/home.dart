import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:provider/provider.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:mini_game_manager/games_pages/game_add_view.dart';
import 'package:mini_game_manager/game_multi_view.dart';
import 'package:mini_game_manager/api/itch_io.dart';
import 'package:mini_game_manager/modules/custom_widgets.dart';
import 'package:mini_game_manager/providers/game_data.dart';
import 'package:mini_game_manager/providers/game_categories.dart';
import 'package:mini_game_manager/providers/application_settings.dart';
import 'package:mini_game_manager/pages/application_settings_view.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  late String _searchText = "";
  late String _categoryText = "";
  late String _itchIoName = "Itch.io Login";
  late GameData _gamesData;
  late GameCategories _gameCategories;
  late ApplicationSettings _appSetting;
  late Animation<double> _animation;
  late AnimationController _animationController;

  @override
  void initState() async {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
    );
    final curvedAnimation =
        CurvedAnimation(curve: Curves.easeInOut, parent: _animationController);
    _animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);
    setUserName();
    super.initState();
  }

  Future<void> setUserName() async {
    if (ItchIo.getAuthToken() != null) {
      _itchIoName = await ItchIo.getUserDetail() ?? "Itch.io Login";
      setState(() {
        _itchIoName = "Signed in as $_itchIoName";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    _appSetting = Provider.of<ApplicationSettings>(context);
    _gamesData = Provider.of<GameData>(context);
    _gameCategories = Provider.of<GameCategories>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: _appSetting.activeColorTheme.primary,
        title: Form(
          child: TextFormField(
            cursorColor: _appSetting.activeColorTheme.primaryAlt,
            decoration: InputDecoration(
              icon: Icon(
                Icons.search,
                color: _appSetting.activeColorTheme.primaryText,
              ),
              label: Text(
                "Search",
                style:
                    TextStyle(color: _appSetting.activeColorTheme.primaryText),
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent),
              ),
              border: InputBorder.none,
            ),
            onChanged: (input) {
              setState(() {
                _searchText = input;
              });
            },
          ),
        ),
        actions: [
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
              customButton: SizedBox(
                width: 50,
                child: Icon(
                  Icons.sort,
                  color: _appSetting.activeColorTheme.primaryText,
                ),
              ),
              items: sortOptions,
              onChanged: (val) {
                _appSetting.setLibraryView(val!);
              },
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
              customButton: SizedBox(
                width: 50,
                child: Icon(
                  Icons.more_vert,
                  color: _appSetting.activeColorTheme.primaryText,
                ),
              ),
              items: viewOptions,
              onChanged: (val) {
                _appSetting.setLibraryView(val!);
              },
            ),
          ),
        ],
      ),
      drawer: Drawer(
        backgroundColor: _appSetting.activeColorTheme.background,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: double.infinity,
              child: DrawerHeader(
                decoration:
                    BoxDecoration(color: _appSetting.activeColorTheme.primary),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.only(bottom: 10),
                        width: double.infinity,
                        child: const Text(
                          "Mini-Game Manager",
                          style: TextStyle(
                            fontSize: 25,
                          ),
                        ),
                      ),
                    ),
                    const Text(
                      'Follow the project on',
                      style: TextStyle(fontSize: 16),
                    ),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: CustomButton(
                        child: const Icon(FontAwesomeIcons.github),
                        color: Colors.transparent,
                        boxShadow: const [],
                        onClick: () async {
                          await launch(
                              "https://github.com/DamonNomadJr/mini_game_manager");
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  ExpansionTile(
                    leading: const Icon(Icons.label_outline),
                    title: const Text('Choose a category'),
                    children: selectCategoryList(),
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: ListTile(
                        leading: const Icon(FontAwesomeIcons.itchIo),
                        title: Text(_itchIoName),
                        onTap: () async {
                          if (ItchIo.getAuthToken() == null) {
                            openBrowser();
                          } else {
                            await setUserName();
                          }
                        }),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionBubble(
        items: floatingActionBubles(),
        animation: _animation,
        onPress: () => _animationController.isCompleted
            ? _animationController.reverse()
            : _animationController.forward(),
        iconColor: _appSetting.activeColorTheme.primaryText,

        // Flaoting Action button Icon
        iconData: Icons.menu,
        backGroundColor: _appSetting.activeColorTheme.primary,
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            flex: 1,
            child: SingleChildScrollView(
              controller: ScrollController(),
              child: GamesMultiView(
                  games: _gamesData.getAllGames(), title: _categoryText),
            ),
          ),
        ],
      ),
    );
  }

  List<DropdownMenuItem<gameLibraryView>> viewOptions = [
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

  List<DropdownMenuItem<gameLibraryView>> sortOptions = [
    DropdownMenuItem<gameLibraryView>(
      value: gameLibraryView.gridView,
      child: Row(
        children: const [
          Icon(Icons.sort_by_alpha),
          Padding(padding: EdgeInsets.all(5)),
          Text("Alphabetical"),
        ],
      ),
    ),
    DropdownMenuItem<gameLibraryView>(
      value: gameLibraryView.comfyView,
      child: Row(
        children: const [
          Icon(Icons.calendar_today),
          Padding(padding: EdgeInsets.all(5)),
          Text("Last Played"),
        ],
      ),
    ),
  ];

  List<Bubble> floatingActionBubles() {
    List<Bubble> returnList = [
      createMenuItem(
        title: "Add a game",
        icon: Icons.create_new_folder,
        function: () {
          _showMaterialDialog();
        },
      ),
      createMenuItem(
        title: "Add a zip",
        icon: Icons.folder_zip,
        function: () {
          _showMaterialDialog();
        },
      ),
      createMenuItem(
        title: "Settings",
        icon: Icons.settings,
        function: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ApplicationSettingsView(),
            ),
          );
        },
      ),
    ];
    return returnList;
  }

  Bubble createMenuItem(
      {required String title,
      required IconData icon,
      required Function function}) {
    return Bubble(
      title: title,
      icon: icon,
      iconColor: _appSetting.activeColorTheme.primaryText,
      bubbleColor: _appSetting.activeColorTheme.primaryAlt,
      titleStyle: TextStyle(
        color: _appSetting.activeColorTheme.primaryText,
      ),
      onPress: () {
        function();
        _animationController.reverse();
      },
    );
  }

  void _showMaterialDialog() {
    showModalBottomSheet(
      elevation: 1,
      isDismissible: false,
      isScrollControlled: true,
      context: context,
      builder: (_) => const GameAddView(),
    );
  }

  openBrowser() {
    Navigator.pop(context);
    launch(
        "https://itch.io/user/oauth?client_id=e2e7c96c802041d26685546533f4607b&scope=profile%3Ame&response_type=token&redirect_uri=https%3A%2F%2Fhtmlpreview.github.io%2F%3Fhttps%3A%2F%2Fgithub.com%2FDamonNomadJr%2Fmini_game_manager%2Fblob%2Fmain%2F.docs%2Fitch_io_response.html");
    showDialog(
      context: context,
      builder: (context) {
        String accessToken = "";
        return AlertDialog(
          title: const Text("Confirm your access token"),
          content: TextField(onChanged: ((value) => accessToken = value)),
          actions: [
            CustomButton(
              child: const Text("Confirm"),
              color: Colors.black,
              onClick: () {
                if (accessToken.isNotEmpty) {
                  ItchIo.setAuthToken(accessToken);
                  Navigator.pop(context);
                }
              },
            ),
          ],
        );
      },
    );
  }

  List<Widget> selectCategoryList() {
    List<String> category = _gameCategories.getAllCategories();
    category.sort();
    List<Widget> returnList = [];
    for (var element in category) {
      returnList.add(ListTile(
        onTap: () {
          setState(() {
            if (_categoryText == element) {
              _categoryText = "";
            } else {
              _categoryText = element;
            }
          });
        },
        leading: Icon(
          _categoryText == element
              ? Icons.check_box
              : Icons.check_box_outline_blank,
        ),
        title: Text(element),
      ));
    }
    return returnList;
  }
}
