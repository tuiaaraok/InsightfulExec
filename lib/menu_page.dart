import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hr/home_page.dart';
import 'package:hr/meeting_page.dart';
import 'package:hr/search_page.dart';
import 'package:hr/setting_page.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  String svgName = "Home";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        height: 72.15.h,
        color: Colors.black,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children:
              ["Home", "Search", "Meeting", "Setting"].map((toElement) {
                return SizedBox(
                  height: 33.h,
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          svgName = toElement;
                          setState(() {});
                        },
                        child: SvgPicture.asset("assets/icons/$toElement.svg"),
                      ),
                      Spacer(),
                      if (svgName == toElement)
                        Container(
                          width: 12.37.w,
                          height: 2.06,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(
                              Radius.circular(2.06.r),
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              }).toList(),
        ),
      ),
      body: myCurrentBody(svgName),
    );
  }

  Widget myCurrentBody(String svgName) {
    switch (svgName) {
      case "Home":
        return HomePage();
      case "Search":
        return SearchPage();
      case "Meeting":
        return MeetingPage();
      case "Setting":
        return SettingPage();
      default:
        return HomePage();
    }
  }
}
