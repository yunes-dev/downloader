import 'package:download_every_thing/another/classes/components/components.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/widgetList.dart';

class ListTabBar extends StatelessWidget {
  WidgetListTabBar tabBar;
  Function() onPress;
  int index;
  int current;
  ListTabBar({
    super.key,
    required this.tabBar,
    required this.onPress,
    required this.index,
    required this.current,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: index == 0 ? 10 : 23, top: 1),
      child: GestureDetector(
        onTap: onPress,
        child: Container(
          decoration: current == index
              ? BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: Components().lightColor.withOpacity(0.5))
              : null,
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.all(5),
                child: Image.asset(
                  tabBar.img,
                  height: 20,
                  width: 20,
                ),
              ),
              Text(
                tabBar.name,
                style: GoogleFonts.ubuntu(
                  fontSize: current == index ? 14 : 12,
                  fontWeight:
                      current == index ? FontWeight.w400 : FontWeight.w300,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
