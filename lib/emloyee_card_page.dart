import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hr/add_an_goal_page.dart';
import 'package:hr/hive/hive_boxes.dart';
import 'package:hr/hive/meeting/emloyee_model.dart';
import 'package:hr/hive/meeting/goan_model.dart';
import 'package:keyboard_actions/keyboard_actions.dart';

class EmloyeeCardPage extends StatefulWidget {
  const EmloyeeCardPage({super.key, required this.indexBox});
  final int indexBox;

  @override
  State<EmloyeeCardPage> createState() => _EmloyeeCardPageState();
}

class _EmloyeeCardPageState extends State<EmloyeeCardPage> {
  late Box<EmloyeeModel> box;
  late EmloyeeModel employee;
  List<TextEditingController> descriptionController = [];
  TextStyle textStyle = GoogleFonts.roboto(
    fontSize: 14.43.sp,
    fontWeight: FontWeight.w400,
    color: Color(0xFF475467),
  );

  FocusNode ratingNode = FocusNode();
  TextEditingController ratingController = TextEditingController();
  List<FocusNode> descriptionNode = [];
  @override
  void dispose() {
    ratingController.dispose();
    ratingNode.dispose();
    for (var controller in descriptionController) {
      controller.dispose();
    }
    for (var node in descriptionNode) {
      node.dispose();
    }
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    box = Hive.box<EmloyeeModel>(HiveBoxes.emloyeeModel);
    employee = box.getAt(widget.indexBox)!;

    ratingController.text = employee.colleaguesRating;

    // Инициализация контроллеров и фокусов для lastFeedback
    descriptionController = [];
    descriptionNode = [];
    for (var feedback in employee.lastFeedback) {
      descriptionController.add(TextEditingController(text: feedback));
      descriptionNode.add(FocusNode());
    }

    // Добавим слушатели для сохранения lastFeedback при изменениях
    for (var controller in descriptionController) {
      controller.addListener(_saveLastFeedback);
    }
  }

  void _onRatingChanged() {
    final text = ratingController.text.trim();

    // Проверяем, что введённое значение — число от 0 до 5
    final ratingValue = double.tryParse(text);
    if (ratingValue == null || ratingValue < 0 || ratingValue > 5) {
      // Можно опционально показать ошибку или игнорировать
      return;
    }

    // Обновляем модель и сохраняем в Hive
    employee.colleaguesRating = ratingValue.toStringAsFixed(1);

    // Сохраняем обновлённый объект обратно в Hive
    box.putAt(widget.indexBox, employee);
  }

  void _saveLastFeedback() {
    // Собираем все тексты из контроллеров в список
    employee.lastFeedback =
        descriptionController
            .map((e) => e.text.trim())
            .where((e) => e.isNotEmpty)
            .toList();
    // Сохраняем в Hive
    box.putAt(widget.indexBox, employee);
  }

  Future<void> _addNewGoal() async {
    final newGoal = await Navigator.push<GoanModel>(
      context,
      MaterialPageRoute(builder: (_) => AddAnGoalPage(name: employee.fullName)),
    );

    if (newGoal != null) {
      setState(() {
        employee.currentGoal.add(newGoal);
        box.putAt(widget.indexBox, employee);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Подсчёт времени в компании (например, в формате "X лет Y месяцев")
    final now = DateTime.now();
    final duration = now.difference(employee.hireDate);
    final years = (duration.inDays / 365).floor();
    final months = ((duration.inDays % 365) / 30).floor();

    return Scaffold(
      backgroundColor: Color(0xFFF1F3F8),
      body: KeyboardActions(
        config: KeyboardActionsConfig(
          keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
          nextFocus: false,
          actions: [
            KeyboardActionsItem(focusNode: ratingNode),
            ...descriptionNode.map((e) {
              return KeyboardActionsItem(focusNode: e);
            }),
          ],
        ),
        child: Container(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.paddingOf(context).bottom,
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    color: Colors.white,
                    padding: EdgeInsets.only(
                      top: MediaQuery.paddingOf(context).top + 8.25.h,
                      bottom: 16.49.h,
                    ),
                    child: Center(
                      child: SizedBox(
                        width: 354.w,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: Container(
                                alignment: Alignment.center,
                                margin: EdgeInsets.only(left: 20.w),
                                width: 33.w,
                                height: 33.h,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xFFF4F3FF),
                                ),
                                child: SvgPicture.asset(
                                  "assets/icons/arrow_back.svg",
                                ),
                              ),
                            ),
                            Text(
                              "Employee card",
                              style: GoogleFonts.inter(
                                fontSize: 18.55.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(width: 33.w),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 366.w,
                    margin: EdgeInsets.symmetric(vertical: 25.h),
                    padding: EdgeInsets.symmetric(vertical: 9.h),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(12.r)),
                      color: Colors.white,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 235.w,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Name: ${employee.fullName}",
                                style: textStyle,
                              ),
                              SizedBox(height: 8.h),
                              Text(
                                "Job Title: ${employee.jobTitle}",
                                style: textStyle,
                              ),
                              SizedBox(height: 8.h),
                              Text(
                                "In the company: $years years $months months",
                                style: textStyle,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 106.w,
                          height: 100.h,
                          decoration: BoxDecoration(
                            color: Color(0xFFF4F3FF),
                            image: DecorationImage(
                              fit: BoxFit.fill,
                              image: MemoryImage(employee.imageProfile),
                            ),
                            borderRadius: BorderRadius.all(
                              Radius.circular(8.r),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Далее используйте employee.totalKpi, employee.meetingGoals и другие поля
                  Column(
                    children: [
                      Text(
                        "Key indicators",
                        style: GoogleFonts.inter(
                          fontSize: 18.55.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 17.h),
                      SizedBox(
                        height: 196.h,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: 366.w,
                              padding: EdgeInsets.symmetric(
                                horizontal: 12.w,
                                vertical: 12.h,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(12.r),
                                ),
                                color: Colors.white,
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      SvgPicture.asset(
                                        "assets/icons/kpi_icon.svg",
                                      ),
                                      SizedBox(width: 6.w),
                                      Text(
                                        "Total KPI",
                                        style: GoogleFonts.inter(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Spacer(),
                                      Text(
                                        "${employee.totalKpi}%",
                                        style: GoogleFonts.inter(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF7A5AF8),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 16.h),
                                  Container(
                                    width: 334.14.w,
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
                                        width:
                                            334.14.w * employee.totalKpi / 100,
                                        height: 4.13.h,
                                        decoration: BoxDecoration(
                                          color: Color(0xFF7A5AF8),
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
                            Container(
                              width: 366.w,
                              padding: EdgeInsets.all(15.w),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(12.r),
                                ),
                                color: Colors.white,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Meeting goals",
                                    style: GoogleFonts.roboto(
                                      fontSize: 14.43.sp,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFF475467),
                                    ),
                                  ),
                                  Text(
                                    "${employee.meetingGoals}/${employee.currentGoal.length}",
                                    style: GoogleFonts.roboto(
                                      fontSize: 14.43.sp,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF7A5AF8),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: 366.w,
                              padding: EdgeInsets.all(15.w),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(12.r),
                                ),
                                color: Colors.white,
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    "Colleagues' rating",
                                    style: GoogleFonts.roboto(
                                      fontSize: 14.43.sp,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFF475467),
                                    ),
                                  ),
                                  Expanded(
                                    child: TextField(
                                      focusNode: ratingNode,
                                      controller: ratingController,
                                      decoration: InputDecoration(
                                        isDense: true,
                                        border: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                        hintStyle: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          color: Color(0xFF98A2B3),
                                          fontSize: 14.43.sp,
                                        ),
                                      ),
                                      textAlign: TextAlign.end,
                                      keyboardType:
                                          TextInputType.numberWithOptions(
                                            decimal: true,
                                          ),
                                      cursorColor: Colors.black,
                                      style: TextStyle(
                                        color: Color(0xFF7A5AF8),
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14.43.sp,
                                      ),
                                      onChanged: (text) {
                                        _onRatingChanged();
                                      },
                                    ),
                                  ),
                                  Text(
                                    "/5",
                                    style: GoogleFonts.roboto(
                                      fontSize: 14.43.sp,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF7A5AF8),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 27.h),
                      SizedBox(
                        width: 366.w,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(width: 53.w),
                                Text(
                                  "Current goal",
                                  style: GoogleFonts.inter(
                                    fontSize: 18.55.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: _addNewGoal,
                                  child: Container(
                                    width: 53.w,
                                    padding: EdgeInsets.symmetric(
                                      vertical: 4.h,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Color(
                                        0xFF8CF85A,
                                      ).withValues(alpha: 0.4),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(100.r),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(
                                          "assets/icons/add.svg",
                                        ),
                                        SizedBox(width: 5.w),
                                        Text(
                                          "Add",
                                          style: GoogleFonts.inter(
                                            color: Color(0xFF48A700),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 27.h),
                            ...employee.currentGoal.map(
                              (e) => GoalWidget(
                                elem: e,
                                onTap: (p0) {
                                  setState(() {
                                    e.isComleted = p0;
                                    if (p0) {
                                      employee.meetingGoals += 1;
                                    } else {
                                      employee.meetingGoals -= 1;
                                    }
                                    employee.totalKpi =
                                        ((employee.meetingGoals /
                                                    employee
                                                        .currentGoal
                                                        .length) *
                                                100)
                                            .toInt();
                                    box.putAt(widget.indexBox, employee);
                                  });
                                },
                              ),
                            ),
                            SizedBox(height: 15.h),
                            Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(width: 53.w),
                                    Text(
                                      "Last feedback",
                                      style: GoogleFonts.inter(
                                        fontSize: 18.55.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          final newController =
                                              TextEditingController();
                                          newController.addListener(
                                            _saveLastFeedback,
                                          );
                                          descriptionController.add(
                                            newController,
                                          );
                                          descriptionNode.add(FocusNode());
                                        });
                                      },
                                      child: Container(
                                        width: 53.w,
                                        padding: EdgeInsets.symmetric(
                                          vertical: 4.h,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Color(
                                            0xFF8CF85A,
                                          ).withValues(alpha: 0.4),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(100.r),
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            SvgPicture.asset(
                                              "assets/icons/add.svg",
                                            ),
                                            SizedBox(width: 5.w),
                                            Text(
                                              "Add",
                                              style: GoogleFonts.inter(
                                                color: Color(0xFF48A700),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 27.h),
                                for (
                                  int i = 0;
                                  i < descriptionController.length;
                                  i++
                                )
                                  Container(
                                    alignment: Alignment.center,
                                    width: 366.w,
                                    margin: EdgeInsets.only(bottom: 10.h),
                                    padding: EdgeInsets.all(15.w),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(12.r),
                                      ),
                                      color: Colors.white,
                                    ),
                                    child: SizedBox(
                                      width: 334.w,
                                      child: TextField(
                                        maxLines: null,
                                        focusNode: descriptionNode[i],
                                        controller: descriptionController[i],
                                        decoration: InputDecoration(
                                          isDense: true,
                                          border: InputBorder.none,
                                          focusedBorder: InputBorder.none,

                                          hintStyle: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            color: Color(0xFF98A2B3),
                                            fontSize: 14.43.sp,
                                          ),
                                        ),

                                        keyboardType: TextInputType.multiline,
                                        cursorColor: Colors.black,
                                        style: GoogleFonts.roboto(
                                          color: Color(0xFF475467),
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14.43.sp,
                                        ),
                                        onChanged: (text) {},
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            // Circular checkbox
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class GoalWidget extends StatelessWidget {
  GoalWidget({super.key, required this.onTap, required this.elem});
  Function(bool) onTap;
  GoanModel elem;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 366.w,
      padding: EdgeInsets.all(15.w),
      margin: EdgeInsets.only(bottom: 10.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(12.r)),
        color: Colors.white,
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => onTap(!elem.isComleted),

            child: Container(
              width: 22.47.w,
              height: 22.47.h,
              decoration: BoxDecoration(
                border:
                    elem.isComleted
                        ? null
                        : Border.all(color: Colors.grey, width: 2),
                borderRadius: BorderRadius.circular(4),
                color: elem.isComleted ? Color(0xFF6335E1) : Colors.transparent,
              ),
              child:
                  elem.isComleted
                      ? Icon(Icons.check, size: 18, color: Colors.white)
                      : null,
            ),
          ),
          SizedBox(width: 12.53.w),
          Text(
            elem.goalName,
            style: GoogleFonts.roboto(
              fontSize: 14.43.sp,
              fontWeight: FontWeight.w400,
              color: Color(0xFF475467),
            ),
          ),
        ],
      ),
    );
  }
}
