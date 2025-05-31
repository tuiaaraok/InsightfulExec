import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hr/add_an_employee_page.dart';
import 'package:hr/emloyee_card_page.dart';
import 'package:hr/hive/hive_boxes.dart';
import 'package:hr/hive/meeting/emloyee_model.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController searchController = TextEditingController();
  List<EmloyeeModel> filteredEmployees = [];
  Box<EmloyeeModel>? box;

  @override
  void initState() {
    super.initState();
    // Изначально список пустой, будет заполнен после открытия бокса
    searchController.addListener(_filterEmployees);
  }

  void _filterEmployees() {
    final query = searchController.text.toLowerCase();
    if (box == null) return;

    if (query.isEmpty) {
      setState(() {
        filteredEmployees = box!.values.toList();
      });
    } else {
      setState(() {
        filteredEmployees =
            box!.values.where((employee) {
              final fullNameLower = employee.fullName.toLowerCase();
              final jobTitleLower = employee.jobTitle.toLowerCase();
              return fullNameLower.contains(query) ||
                  jobTitleLower.contains(query);
            }).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder: (BuildContext context) => const AddAnEmployeePage(),
            ),
          );
        },
        child: Container(
          width: 60.w,
          height: 60.h,
          decoration: BoxDecoration(
            color: Color(0xFF7A5AF8),
            shape: BoxShape.circle,
          ),
          child: Center(child: Icon(Icons.add, color: Colors.white)),
        ),
      ),
      body: ValueListenableBuilder(
        valueListenable:
            Hive.box<EmloyeeModel>(HiveBoxes.emloyeeModel).listenable(),
        builder: (context, Box<EmloyeeModel> boxValue, _) {
          box = boxValue;
          // При изменении бокса обновляем полный список и фильтрацию
          if (filteredEmployees.isEmpty && searchController.text.isEmpty) {
            filteredEmployees = boxValue.values.toList();
          }
          return Container(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(top: MediaQuery.paddingOf(context).top),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      height: 49.75.h,
                      width: 354.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(15.55.r),
                        ),
                        color: Colors.white,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10.w),
                              child: TextField(
                                controller: searchController,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  hintText: 'Search by name or position',
                                  hintStyle: GoogleFonts.inter(
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black.withValues(alpha: 0.57),
                                    fontSize: 13.68.sp,
                                  ),
                                ),
                                keyboardType: TextInputType.text,
                                cursorColor: Colors.black,
                                style: GoogleFonts.poppins(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13.68.sp,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: 51.89.w,
                            height: 49.75.h,
                            decoration: BoxDecoration(
                              color: Color(0xFF7A5AF8),
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(15.55.r),
                                bottomRight: Radius.circular(15.55.r),
                              ),
                            ),
                            child: Center(
                              child: SvgPicture.asset(
                                "assets/icons/search_icon.svg",
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 25.25.h),
                    // Используем индекс из бокса для передачи в TeamCardWidget
                    ...filteredEmployees.map((employee) {
                      final index = box!.values.toList().indexOf(employee);
                      return TeamCardWidget(elem: employee, indexBox: index);
                    }),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// Обновляем TeamCardWidget, добавляем поле indexBox:
class TeamCardWidget extends StatelessWidget {
  const TeamCardWidget({super.key, required this.elem, required this.indexBox});
  final EmloyeeModel elem;
  final int indexBox;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute<void>(
            builder:
                (BuildContext context) => EmloyeeCardPage(indexBox: indexBox),
          ),
        );
      },
      child: Container(
        width: 366.w,
        margin: EdgeInsets.only(bottom: 10.h),
        padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 10.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(12.r)),
          color: Colors.white,
        ),
        child: Row(
          children: [
            Container(
              width: 34.w,
              height: 34.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Color(0xFF7A5AF8), width: 2.w),
                image: DecorationImage(
                  image: MemoryImage(elem.imageProfile),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              child: RichText(
                text: TextSpan(
                  text: "${elem.fullName} ",
                  style: GoogleFonts.roboto(
                    fontSize: 14.43.sp,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF475467),
                  ),
                  children: [
                    TextSpan(
                      text: elem.jobTitle,
                      style: GoogleFonts.roboto(
                        fontSize: 14.43.sp,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF7A5AF8),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Spacer(),
            SizedBox(
              width: 33.49.w,
              height: 33.88.h,
              child: CustomPaint(
                painter: LastCirclePhoto(
                  timer: elem.totalKpi,
                  total: 100,
                  strokeWidth: 2.78,
                  colorSearch: Color(0xFF9B8AFB),
                ),
                child: Center(
                  child: Text(
                    "${elem.totalKpi}%",
                    style: GoogleFonts.lato(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF585A66),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LastCirclePhoto extends CustomPainter {
  LastCirclePhoto({
    required this.timer,
    required this.total,
    this.strokeWidth = 5,
    this.colorSearch,
  });
  final int timer;
  final double total;
  double strokeWidth;
  Color? colorSearch;

  @override
  void paint(Canvas canvas, Size size) {
    strokeWidth *= 1.w;
    Paint paintOptions =
        Paint()
          ..color = colorSearch ?? getColor(timer).$1
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth
          ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);
    final radius =
        min(size.width / 2, size.height / 2) - paintOptions.strokeWidth / 2;

    // Draw background circle
    Paint backgroundPaint =
        Paint()
          ..color = Color(0xFFE4EDFF)
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth;

    canvas.drawCircle(center, radius, backgroundPaint);

    // Draw progress arc
    double sweepAngle = (2 * pi * timer) / total;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2, // Start from top
      sweepAngle,
      false,
      paintOptions,
    );
  }

  @override
  bool shouldRepaint(covariant LastCirclePhoto oldDelegate) {
    return oldDelegate.timer != timer || oldDelegate.total != total;
  }
}

(Color, SvgPicture) getColor(int value) {
  if (value < 50) {
    return (
      const Color(0xFFF95555),
      SvgPicture.asset("assets/icons/smail_indicator_red.svg"),
    );
  } else if (value < 75) {
    return (
      const Color(0xFFFFB017),
      SvgPicture.asset("assets/icons/smail_indicator_yellow.svg"),
    );
  } else if (value <= 100) {
    return (
      const Color(0xFF7A5AF8),
      SvgPicture.asset("assets/icons/smail_indicator_purple.svg"),
    );
  }
  return (
    const Color(0xFF7A5AF8),
    SvgPicture.asset("assets/icons/smail_indicator_purple.svg"),
  );
}
