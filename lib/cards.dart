import 'package:flutter/material.dart';

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
