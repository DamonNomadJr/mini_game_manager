import 'package:flutter/material.dart';
import 'package:mini_game_manager/modules/custom_widgets.dart';
import 'package:mini_game_manager/providers/application_settings.dart';
import 'package:provider/provider.dart';

class ApplicationSettingsView extends StatefulWidget {
  const ApplicationSettingsView({Key? key}) : super(key: key);

  @override
  State<ApplicationSettingsView> createState() =>
      _ApplicationSettingsViewState();
}

class _ApplicationSettingsViewState extends State<ApplicationSettingsView> {
  late ApplicationSettings _appSettings;

  @override
  Widget build(BuildContext context) {
    _appSettings = Provider.of<ApplicationSettings>(context);
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: _appSettings.activeColorTheme.background,
      appBar: AppBar(
        title: const Text("Settings"),
        backgroundColor: _appSettings.activeColorTheme.primary,
      ),
      body: SingleChildScrollView(
        child: Expanded(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomSection(
                  title: "Change Color Theme",
                  child: GridView(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: width > 2000
                          ? 7
                          : width > 1000
                              ? 5
                              : width > 500
                                  ? 3
                                  : 1,
                      childAspectRatio: 1,
                    ),
                    shrinkWrap: true,
                    children: colorThemeBuilder(),
                  ),
                ),
                Divider(
                  color: _appSettings.activeColorTheme.secondaryText,
                ),
                CustomSection(
                  title: "Library Folders",
                  child: Container(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> colorThemeBuilder() {
    List<Widget> items = [];
    for (var key in _appSettings.colorThemes.keys) {
      items.add(
        Padding(
          padding: const EdgeInsets.all(2.0),
          child: InkWell(
            onTap: () {
              _appSettings.setColorTheme(key);
            },
            child: Container(
              clipBehavior: Clip.hardEdge,
              margin: EdgeInsets.all(15),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: (_appSettings.colorThemes[key])!.backgroundAlt,
                    blurRadius: 5,
                    spreadRadius: 5,
                  )
                ],
                borderRadius: BorderRadius.circular(5),
                color: (_appSettings.colorThemes[key])!.background,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Text(
                      "$key Color pallet",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: (_appSettings.colorThemes[key])!.primaryText,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 50,
                          color: (_appSettings.colorThemes[key])!.primary,
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: 50,
                          color: (_appSettings.colorThemes[key])!.primaryAlt,
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: 50,
                          color: (_appSettings.colorThemes[key])!.secondary,
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: 50,
                          color: (_appSettings.colorThemes[key])!.secondaryAlt,
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      );
    }
    return items;
  }
}
