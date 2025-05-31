import 'dart:math';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hr/hive/hive_boxes.dart';
import 'package:hr/hive/meeting/emloyee_model.dart';
import 'package:hr/hive/meeting/meeting_model.dart';
import 'package:hr/my_text_field.dart';
import 'package:intl/intl.dart';

class AddMeetingPage extends StatefulWidget {
  const AddMeetingPage({super.key});

  @override
  State<AddMeetingPage> createState() => _AddMeetingPageState();
}

class _AddMeetingPageState extends State<AddMeetingPage> {
  late MenuElem membersElem;
  String hint = "Select an employee";
  String previousText = '';
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController agendaController = TextEditingController();

  bool isValid() {
    return agendaController.text.isNotEmpty &&
        dateController.text.isNotEmpty &&
        timeController.text.isNotEmpty &&
        membersElem.selectedElem.isNotEmpty;
  }

  @override
  void initState() {
    super.initState();
    membersElem = MenuElem(
      isOpen: false,
      selectedElem: "",
      listElements:
          Hive.box<EmloyeeModel>(
            HiveBoxes.emloyeeModel,
          ).values.map((e) => e.fullName).toList(),
    );
  }

  @override
  void dispose() {
    dateController.dispose();
    timeController.dispose();
    agendaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F3F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: Center(
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(left: 20.w),
              width: 33.w,
              height: 33.h,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFF4F3FF),
              ),
              child: SvgPicture.asset("assets/icons/arrow_back.svg"),
            ),
          ),
        ),
        title: Text(
          "Add a meeting",
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
                "Date",
                344.28.w,
                dateController,
                hint: "Enter date",
                SvgPicture.asset("assets/icons/date.svg"),
                onChange: (p0) => validDate(p0, dateController),
              ),
              SizedBox(height: 16.h),
              MyTextField.textFieldIcon(
                "Start-End Time",
                344.28.w,
                timeController,
                hint: "Enter time",
                SvgPicture.asset("assets/icons/name.svg"),
                onChange: (p0) => setState(() {}),
              ),
              SizedBox(height: 16.h),
              MyTextField.textFieldIcon(
                "Agenda",
                344.28.w,
                agendaController, // Исправлено: было timeController
                hint: "Enter the name of the meeting agenda",
                SvgPicture.asset("assets/icons/job.svg"),
                onChange: (p0) => setState(() {}),
              ),
              SizedBox(height: 32.h),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        height: 103.08.h,
        child: Center(
          child: GestureDetector(
            onTap: isValid() ? _createMeeting : null,
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
                  stops: const [0, 0.29, 1],
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

  void _createMeeting() {
    // Здесь должна быть логика сохранения встречи

    final meeting = MeetingModel(
      emloyee: membersElem.selectedElem,
      date: DateFormat(
        'dd/MM/yyyy',
      ).parse(dateController.text), // Нужно парсить из dateController
      startEndTime: timeController.text,
      agenda: agendaController.text,
    );
    Hive.box<MeetingModel>(HiveBoxes.meetingModel).add(meeting);

    Navigator.pop(context);
  }

  void validDate(String text, TextEditingController controller) {
    String sanitizedText = text.replaceAll(RegExp(r'[^0-9]'), '');
    String formattedText = '';

    for (int i = 0; i < sanitizedText.length && i < 8; i++) {
      formattedText += sanitizedText[i];
      if (previousText.length > text.length) {
        if (sanitizedText.length > 2 && i == 1) {
          formattedText += '/';
        }
        if (sanitizedText.length > 4 && i == 3) {
          formattedText += '/';
        }
      } else {
        if ((i == 1 || i == 3) && i < sanitizedText.length - 1) {
          formattedText += '/';
        }
      }
    }

    // Валидация дня и месяца
    List<String> parts = formattedText.split('/');
    if (parts.isNotEmpty && parts[0].isNotEmpty) {
      int? day = int.tryParse(parts[0]);
      if (day != null && day > 31) {
        formattedText = formattedText.substring(0, 2);
      }
    }
    if (parts.length > 1 && parts[1].isNotEmpty) {
      int? month = int.tryParse(parts[1]);
      if (month != null && month > 12) {
        formattedText =
            '${parts[0]}/12${parts.length > 2 ? '/${parts[2]}' : ''}';
      }
    }

    controller.value = TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
    previousText = controller.text;
    setState(() {});
  }

  Widget _buildDropdownSection({
    required String title,
    required MenuElem menu,
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
              color: const Color(0xFF475467),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        SizedBox(height: 4.h),
        _buildDropdown(menu: menu, hint: hint),
      ],
    );
  }

  Widget _buildDropdown({required MenuElem menu, required String hint}) {
    return Container(
      height: 46.h,
      width: 344.w,
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(8.r)),
        border: Border.all(color: const Color(0xFF98A2B3), width: 1.w),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton2(
          onChanged: (value) {
            setState(() {
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
                        color: const Color(0xFF98A2B3),
                      ),
                    ),
                  )
                  : Expanded(
                    child: Text(
                      menu.selectedElem,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF475467),
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
