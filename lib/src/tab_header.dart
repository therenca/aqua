import 'package:flutter/material.dart';

class TabHeader extends StatefulWidget {
  final Color? bgColor;
  final double? borderRadius;
  final Color? underline;
  final List<String> tabListing;
  final Function(int)? onTap;
  final TabController controller;
  final TextStyle? textStyle;
  final TextStyle? selectedTextStyle;
  final BoxDecoration? decoration;
  final Alignment? alignment;
  final EdgeInsets? padding;

  final double? tabHeight;

  TabHeader(
      {required this.tabListing,
      required this.controller,
      this.bgColor,
      this.borderRadius,
      this.underline,
      this.onTap,
      this.textStyle,
      this.decoration,
      this.alignment,
      this.padding,
      this.tabHeight,
      this.selectedTextStyle});

  @override
  TabHeaderState createState() => TabHeaderState();
}

class TabHeaderState extends State<TabHeader> {
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();

    widget.controller.animation!.addListener(() {
      setState(
          () => selectedIndex = widget.controller.animation!.value.round());
    });
  }

  Widget _buildTabHeader(BuildContext context) {
    List<Widget> tabs = [];
    for (int index = 0; index < widget.tabListing.length; index++) {
      Widget tab = SizedBox(
        height: widget.tabHeight,
        child: Tab(
          child: Container(
            padding: widget.padding,
            alignment: widget.alignment ?? Alignment.centerLeft,
            height: widget.tabHeight,
            decoration: widget.decoration,
            child: Text(
              widget.tabListing[index],
              style: index != selectedIndex
                  ? widget.textStyle ??
                      TextStyle(
                          fontSize: 15.0,
                          color: Colors.black,
                          fontWeight: FontWeight.bold)
                  : widget.selectedTextStyle ??
                      TextStyle(
                          fontSize: 15.0,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
            ),
          ),
        ),
      );

      tabs.add(tab);
    }

    return TabBar(
      controller: widget.controller,
      indicatorColor: widget.underline,
      indicator: BoxDecoration(
        color: widget.bgColor,
        borderRadius: BorderRadius.circular(widget.borderRadius ?? 0),
      ),
      tabs: tabs,
      onTap: (int index) {
        setState(() => selectedIndex = index);
        if (widget.onTap != null) {
          widget.onTap!(index);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) => _buildTabHeader(context);
}
