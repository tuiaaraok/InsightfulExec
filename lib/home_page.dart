import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hr/hive/hive_boxes.dart';
import 'package:hr/hive/meeting/emloyee_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Box<EmloyeeModel> _employeesBox = Hive.box<EmloyeeModel>(
    HiveBoxes.emloyeeModel,
  );

  @override
  void initState() {
    super.initState();
    _employeesBox = Hive.box<EmloyeeModel>(HiveBoxes.emloyeeModel);
  }

  // Получаем топ-3 сотрудников по KPI
  List<EmloyeeModel> _getTopEmployees() {
    final list = _employeesBox.values.toList();
    list.sort((a, b) => b.totalKpi.compareTo(a.totalKpi));
    return list.take(3).toList();
  }

  // Средняя продуктивность всех сотрудников
  int _getAverageProductivity() {
    if (_employeesBox.isEmpty) return 0;
    final total = _employeesBox.values
        .map((e) => e.totalKpi)
        .reduce((a, b) => a + b);
    return total ~/ _employeesBox.length;
  }

  @override
  Widget build(BuildContext context) {
    final topEmployees = _getTopEmployees();
    final averageProductivity = _getAverageProductivity();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Топ-3 сотрудника
              Container(
                width: 378.w,
                padding: EdgeInsets.all(16.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Top 3 employees",
                      style: GoogleFonts.inter(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    if (topEmployees.isEmpty)
                      Center(
                        child: Text(
                          "No employees yet",
                          style: GoogleFonts.inter(color: Colors.grey),
                        ),
                      )
                    else
                      Row(
                        mainAxisAlignment:
                            topEmployees.length == 1
                                ? MainAxisAlignment.start
                                : MainAxisAlignment.spaceEvenly,
                        children:
                            topEmployees
                                .map(
                                  (employee) =>
                                      _EmployeeCard(employee: employee),
                                )
                                .toList(),
                      ),
                  ],
                ),
              ),
              SizedBox(height: 16.h),

              // Общая продуктивность
              Container(
                width: 378.w,
                padding: EdgeInsets.all(16.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Overall productivity",
                          style: GoogleFonts.inter(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          "$averageProductivity%",
                          style: GoogleFonts.inter(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: _getProductivityColor(averageProductivity),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12.h),
                    Container(
                      height: 49.57.h,
                      width: double.infinity,
                      padding: EdgeInsets.only(left: 8.26.w, right: 8.26.w),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(12.26.r),
                        ),
                        color: Color(0xFFF9FAFB),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          getColor(averageProductivity).$2,
                          Container(
                            width: 276.48.w,
                            height: 4.13.h,
                            decoration: BoxDecoration(
                              color: Color(0xFFE7E7E7),
                              borderRadius: BorderRadius.all(
                                Radius.circular(30.98.r),
                              ),
                            ),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                width: averageProductivity.toDouble(),
                                height: 4.13.h,
                                decoration: BoxDecoration(
                                  color: _getProductivityColor(
                                    averageProductivity,
                                  ),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(30.98.r),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24.h),

              // Графическое изображение (можно заменить на реальный график)
              Image.asset("assets/home.png", width: 402.w, height: 402.h),
            ],
          ),
        ),
      ),
    );
  }

  Color _getProductivityColor(int value) {
    if (value < 50) return const Color(0xFFF95555);
    if (value < 75) return const Color(0xFFFFB017);
    return const Color(0xFF7A5AF8);
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
}

class _EmployeeCard extends StatelessWidget {
  final EmloyeeModel employee;

  const _EmployeeCard({required this.employee});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 102.41.w,

      decoration: BoxDecoration(
        color: Color(0xFFF9F9F9),
        borderRadius: BorderRadius.all(Radius.circular(12.r)),
      ),
      child: Column(
        children: [
          // Аватар с прогрессом
          SizedBox(
            width: 80.w,
            height: 80.h,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  value: employee.totalKpi / 100,
                  strokeWidth: 4.w,
                  backgroundColor: const Color(0xFFE4EDFF),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    _getKpiColor(employee.totalKpi),
                  ),
                ),
                CircleAvatar(
                  radius: 30.r,
                  backgroundImage: MemoryImage(employee.imageProfile),
                ),
              ],
            ),
          ),
          SizedBox(height: 8.h),
          // Имя и должность
          Text(
            employee.fullName.split(' ').first,
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            employee.jobTitle,
            style: GoogleFonts.inter(fontSize: 12.sp, color: Colors.grey),
          ),
          SizedBox(height: 4.h),
          // KPI
          Text(
            "${employee.totalKpi}%",
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: _getKpiColor(employee.totalKpi),
            ),
          ),
        ],
      ),
    );
  }

  Color _getKpiColor(int value) {
    if (value < 50) return const Color(0xFFF95555);
    if (value < 75) return const Color(0xFFFFB017);
    return const Color(0xFF7A5AF8);
  }
}
