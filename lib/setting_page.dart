import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          Spacer(),
          SizedBox(
            height: 160.h,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                settingWidget(
                  SvgPicture.asset("assets/icons/contact.svg"),
                  "Contact Us",
                  () async {
                    String? encodeQueryParameters(Map<String, String> params) {
                      return params.entries
                          .map(
                            (MapEntry<String, String> e) =>
                                '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}',
                          )
                          .join('&');
                    }

                    // ···
                    final Uri emailLaunchUri = Uri(
                      scheme: 'mailto',
                      path: 'dev@katwillbitellc.com',
                      query: encodeQueryParameters(<String, String>{'': ''}),
                    );
                    try {
                      if (await canLaunchUrl(emailLaunchUri)) {
                        await launchUrl(emailLaunchUri);
                      } else {
                        throw Exception("Could not launch $emailLaunchUri");
                      }
                    } catch (e) {
                      log('Error launching email client: $e'); // Log the error
                    }
                  },
                ),
                settingWidget(
                  SvgPicture.asset("assets/icons/privacy.svg"),
                  "Privacy Policy",
                  () async {
                    final Uri url = Uri.parse(
                      'https://docs.google.com/document/d/1Bh70iQgCK453hDfDsQx9uyE05Vc2dTUnaAg4Oo_MqbA/mobilebasic',
                    );
                    if (!await launchUrl(url)) {
                      throw Exception('Could not launch $url');
                    }
                  },
                ),
                settingWidget(
                  SvgPicture.asset("assets/icons/rate.svg"),
                  "Rate Us",
                  () async {
                    InAppReview.instance.openStoreListing(
                      appStoreId: '6746621953',
                    );
                  },
                ),
              ],
            ),
          ),
          SizedBox(height: 102.h),
          Image.asset("assets/home.png", width: 402.w, height: 402.h),
        ],
      ),
    );
  }
}

Widget settingWidget(SvgPicture svg, String title, Function onTab) {
  return Container(
    width: 344.28.w,
    height: 44.h,
    padding: EdgeInsets.symmetric(horizontal: 12.w),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.all(Radius.circular(8.r)),
      border: Border.all(color: Color(0xFF98A2B3), width: 1.w),
    ),
    child: GestureDetector(
      onTap: () {
        onTab();
      },
      child: Row(
        children: [
          svg,
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              title,
              style: GoogleFonts.roboto(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          SvgPicture.asset("assets/icons/arrow-right.svg"),
        ],
      ),
    ),
  );
}
