import 'dart:math';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hr/hive/hive_boxes.dart';
import 'package:hr/hive/meeting/emloyee_model.dart';
import 'package:hr/hive/meeting/goan_model.dart';
import 'package:hr/my_text_field.dart';

// ignore: must_be_immutable
class AddAnGoalPage extends StatefulWidget {
  AddAnGoalPage({super.key, required this.name});
  String name;
  @override
  State<AddAnGoalPage> createState() => _AddAnGoalPageState();
}

class _AddAnGoalPageState extends State<AddAnGoalPage> {
  late MenuElem membersElem;
  String hint = "Select an employee";
  bool isValid() {
    return goalNameController.text.isNotEmpty &&
        membersElem.selectedElem.isNotEmpty;
  }

  TextEditingController goalNameController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    membersElem = MenuElem(
      isOpen: false,
      selectedElem: widget.name,
      listElements:
          Hive.box<EmloyeeModel>(HiveBoxes.emloyeeModel).values.map((
            toElement,
          ) {
            return toElement.fullName;
          }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF1F3F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: Center(
          child: Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(left: 20.w),
            width: 33.w,
            height: 33.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFFF4F3FF),
            ),
            child: SvgPicture.asset("assets/icons/arrow_back.svg"),
          ),
        ),
        title: Text(
          "Add an goal",
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            fontSize: 18.55.sp,
          ),
        ),
      ),
      body: SizedBox(
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16.h),
                child: _buildDropdownSection(
                  title: "Employee",
                  menu: membersElem,
                  hint: hint,
                ),
              ),

              MyTextField.textFieldIcon(
                "Goal name",
                344.28.w,
                goalNameController,
                hint: "Enter the feedback about the employee ",
                SvgPicture.asset("assets/icons/name.svg"),
                onChange: (p0) {
                  setState(() {});
                },
              ),
            ],
          ),
        ),
      ),
      // Добавьте обработчик нажатия на кнопку "Create"

      // В нижней панели замените Container на GestureDetector
      bottomNavigationBar: Container(
        color: Colors.white,
        height: 103.08.h,
        child: Center(
          child: GestureDetector(
            onTap: _onCreate,
            child: Container(
              width: 365.w,
              height: 50.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(103.08.r)),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF8862F2).withValues(alpha: isValid() ? 1 : 0.4),
                    Color(0xFF7544FC).withValues(alpha: isValid() ? 1 : 0.4),
                    Color(0xFF5B2ED4).withValues(alpha: isValid() ? 1 : 0.4),
                  ],
                  stops: [0, 0.29, 1],
                ),
              ),
              child: Center(
                child: Text(
                  "Create",
                  style: GoogleFonts.roboto(
                    color: Colors.white,
                    fontSize: 14.43.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onCreate() {
    if (isValid()) {
      final newGoal = GoanModel(
        selectAnEmployee: membersElem.selectedElem,
        goalName: goalNameController.text.trim(),
        isComleted: false,
      );
      final box = Hive.box<EmloyeeModel>(HiveBoxes.emloyeeModel);
      int index = box.values.toList().indexWhere(
        (employee) => employee.fullName == membersElem.selectedElem,
      );
      box.putAt(
        index,
        EmloyeeModel(
          colleaguesRating: box.getAt(index)!.colleaguesRating,
          imageProfile: box.getAt(index)!.imageProfile,
          fullName: box.getAt(index)!.fullName,
          jobTitle: box.getAt(index)!.jobTitle,
          hireDate: box.getAt(index)!.hireDate,
          totalKpi: box.getAt(index)!.totalKpi,
          meetingGoals: (box.getAt(index)!.meetingGoals),
          currentGoal: [...box.getAt(index)!.currentGoal, newGoal],
          lastFeedback: box.getAt(index)!.lastFeedback,
        ),
      );
      Navigator.pop(context, newGoal);
    } else {
      // Можно показать сообщение об ошибке
    }
  }

  Widget _buildDropdownSection({
    required String title,
    required MenuElem menu,
    TextEditingController? controller,
    required String hint,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 344.28.w,
          child: Text(
            title,
            style: TextStyle(
              fontSize: 12.37.sp,
              color: Color(0xFF475467),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        SizedBox(height: 4.h),
        _buildDropdown(
          menu: menu,
          controller: controller,
          hint: "Select an employee",
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required MenuElem menu,
    TextEditingController? controller,
    required String hint,
  }) {
    return Container(
      height: 46.h,
      width: 344.w,
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.all(Radius.circular(8.r)),
        border: Border.all(color: Color(0xFF98A2B3), width: 1.w),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton2(
          onChanged: (value) {
            setState(() {
              if (controller != null) {
                controller.text = value.toString();
              }
              menu.selectedElem = value.toString();
            });
          },
          onMenuStateChange: (isOpen) {
            setState(() {
              menu.isOpen = isOpen;
            });
          },
          customButton: Row(
            children: [
              SvgPicture.asset("assets/icons/name.svg"),
              SizedBox(width: 10.w),
              menu.selectedElem.isEmpty
                  ? Expanded(
                    child: Text(
                      hint,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF98A2B3),
                      ),
                    ),
                  )
                  : Expanded(
                    child: Text(
                      menu.selectedElem,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF475467),
                      ),
                    ),
                  ),

              menu.isOpen
                  ? Transform.rotate(
                    angle: pi,
                    child: SvgPicture.asset(
                      "assets/icons/arrow-down.svg",
                      width: 30.h,
                    ),
                  )
                  : SvgPicture.asset(
                    "assets/icons/arrow-down.svg",
                    width: 30.h,
                  ),
            ],
          ),
          items:
              menu.listElements.map((item) {
                return DropdownMenuItem(
                  value: item,
                  child: SizedBox(
                    width: 355.w,
                    height: 50.h,
                    child: Center(
                      child: Text(
                        item,
                        style: TextStyle(color: Colors.black, fontSize: 16.sp),
                      ),
                    ),
                  ),
                );
              }).toList(),
          dropdownStyleData: DropdownStyleData(
            width: 361.w,
            maxHeight: 300.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: Colors.white,
            ),
            offset: Offset(-15.w, 0),
          ),
          menuItemStyleData: MenuItemStyleData(
            customHeights: List.filled(menu.listElements.length, 50.h),
            padding: EdgeInsets.only(top: 5.h, left: 10.w, right: 10.w),
          ),
        ),
      ),
    );
  }
}

class MenuElem {
  bool isOpen;
  String selectedElem;
  List<String> listElements;

  MenuElem({
    required this.isOpen,
    required this.selectedElem,
    required this.listElements,
  });
}
