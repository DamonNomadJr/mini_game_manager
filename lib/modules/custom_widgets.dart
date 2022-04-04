// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:mini_game_manager/providers/application_settings.dart';
import 'package:provider/provider.dart';

class CustomButton extends StatelessWidget {
  final Widget child;
  final Color color;
  final double? borderRadius;
  final Function onClick;
  final Gradient? gradient;
  final EdgeInsets? padding;
  final List<BoxShadow>? boxShadow;
  final EdgeInsets? leading;
  const CustomButton({
    Key? key,
    required this.child,
    required this.color,
    required this.onClick,
    this.borderRadius,
    this.gradient,
    this.padding,
    this.boxShadow,
    this.leading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: leading ?? const EdgeInsets.only(right: 10),
      child: InkWell(
        borderRadius: BorderRadius.circular(borderRadius ?? 5),
        onTap: () => onClick(),
        child: Container(
          decoration: BoxDecoration(
            color: color,
            gradient: gradient,
            borderRadius: BorderRadius.circular(borderRadius ?? 5),
            boxShadow: boxShadow ??
                <BoxShadow>[
                  const BoxShadow(
                    color: Colors.black,
                    blurRadius: 10,
                    spreadRadius: -5,
                    offset: Offset(1, 1),
                  ),
                ],
          ),
          padding: padding ?? const EdgeInsets.all(10),
          child: child,
        ),
      ),
    );
  }
}

class CustomSliver extends StatefulWidget {
  late String title;
  late String backgroundUrl;
  late bool expanded;
  late double minHeight;
  late double maxHeight;
  late Widget? bottomChildren;
  CustomSliver({
    Key? key,
    required this.title,
    required this.expanded,
    this.backgroundUrl = "",
    this.minHeight = 150,
    this.maxHeight = 300,
    this.bottomChildren,
  }) : super(key: key);

  @override
  State<CustomSliver> createState() => _CustomSliverState();
}

class _CustomSliverState extends State<CustomSliver> {
  late ApplicationSettings _appSetting;
  @override
  Widget build(BuildContext context) {
    _appSetting = Provider.of<ApplicationSettings>(context);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: double.infinity,
      height: widget.expanded ? 300 : 140,
      child: Stack(
        children: [
          SizedBox(
            width: double.infinity,
            child: (widget.backgroundUrl.contains("http"))
                ? Image.network(
                    widget.backgroundUrl,
                    alignment: Alignment.topCenter,
                    fit: BoxFit.cover,
                  )
                : const SizedBox(),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  _appSetting.activeColorTheme.background.shade400,
                  _appSetting.activeColorTheme.background,
                ],
              ),
            ),
            width: double.infinity,
          ),
          Positioned(
            top: 10,
            child: Row(
              children: [
                CustomButton(
                  color: Colors.transparent,
                  boxShadow: const [],
                  onClick: () => Navigator.pop(context),
                  child: const Icon(Icons.close),
                ),
                Text(
                  widget.title,
                  style: const TextStyle(fontSize: 30),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 20,
            left: 10,
            child: widget.bottomChildren ?? Container(),
          ),
        ],
      ),
    );
  }
}

class CustomSection extends StatelessWidget {
  final String title;
  final Widget child;
  const CustomSection({Key? key, required this.title, required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 30),
          child: child,
        ),
      ],
    );
  }
}

class GameRunnerCard extends StatelessWidget {
  final String name;
  final List<String> runArgument;
  final Function onRemove;
  final Color color;
  const GameRunnerCard({
    Key? key,
    required this.name,
    required this.runArgument,
    required this.color,
    required this.onRemove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      margin: const EdgeInsets.only(right: 10, top: 10, bottom: 10),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          const Padding(
            padding: EdgeInsets.only(right: 10),
            child: Icon(Icons.play_arrow),
          ),
          Expanded(
            child: Text(
              name,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 16),
            ),
          ),
          SizedBox(
            child: CustomButton(
              child: const Icon(Icons.cancel),
              color: Colors.transparent,
              boxShadow: const [],
              onClick: () => onRemove(),
            ),
          ),
        ],
      ),
    );
  }
}

class GameRunnerAddCard extends StatelessWidget {
  final String name;
  final bool isSelected;
  final Function onTap;
  final Function onRemove;
  final Color color;
  const GameRunnerAddCard({
    Key? key,
    required this.name,
    required this.isSelected,
    required this.color,
    required this.onTap,
    required this.onRemove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 70,
      margin: const EdgeInsets.only(right: 10, top: 10, bottom: 10),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () => onTap(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: isSelected
                    ? const Icon(Icons.check_box)
                    : const Icon(Icons.check_box_outline_blank),
              ),
              Expanded(
                child: Text(
                  name,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              SizedBox(
                child: CustomButton(
                  child: const Icon(Icons.cancel),
                  color: Colors.transparent,
                  boxShadow: const [],
                  onClick: () => onRemove(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomInfoBox extends StatelessWidget {
  String title;
  String subTitltle;
  IconData leadingIcon;
  double? height;
  Color? color;
  Color? titleColor;
  Color? textColor;
  EdgeInsets? padding;
  EdgeInsets? margin;

  CustomInfoBox({
    Key? key,
    required this.title,
    required this.subTitltle,
    required this.leadingIcon,
    this.height,
    this.color,
    this.titleColor,
    this.textColor,
    this.padding,
    this.margin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _appSetting = Provider.of<ApplicationSettings>(context);
    return Container(
      alignment: Alignment.topCenter,
      padding: padding ?? const EdgeInsets.fromLTRB(20, 10, 30, 10),
      margin: margin ?? const EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
        color: _appSetting.activeColorTheme.primaryText.shade50,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 5, right: 10.0),
            child: Icon(
              leadingIcon,
              color: _appSetting.activeColorTheme.primaryText.shade700,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: _appSetting.activeColorTheme.primaryText.shade700,
                ),
              ),
              Text(
                subTitltle,
                style: TextStyle(
                  fontSize: 16,
                  color: _appSetting.activeColorTheme.primaryText,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CustomRunnerInfoBox extends StatelessWidget {
  String title;
  bool isMain;
  Color? color;
  Color? titleColor;
  Color? textColor;
  EdgeInsets? padding;
  EdgeInsets? margin;

  CustomRunnerInfoBox({
    Key? key,
    required this.title,
    this.isMain = false,
    this.color,
    this.titleColor,
    this.textColor,
    this.padding,
    this.margin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _appSetting = Provider.of<ApplicationSettings>(context);
    return Stack(
      children: [
        Container(
          width: 200,
          alignment: Alignment.topCenter,
          margin: margin ?? const EdgeInsets.only(right: 10),
          decoration: BoxDecoration(
            color: _appSetting.activeColorTheme.secondaryAlt.shade400,
            borderRadius: BorderRadius.circular(5),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(5),
            onTap: () {},
            child: Padding(
              padding: padding ?? const EdgeInsets.fromLTRB(25, 10, 15, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: _appSetting.activeColorTheme.primaryText.shade700,
                    ),
                  ),
                  Icon(
                    Icons.play_arrow,
                    color: _appSetting.activeColorTheme.primaryText.shade700,
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: 0,
          child: InkWell(
            borderRadius: BorderRadius.circular(10000),
            onTap: () {},
            child: Icon(isMain ? Icons.bookmark : Icons.bookmark_add_outlined),
          ),
        ),
      ],
    );
  }
}
