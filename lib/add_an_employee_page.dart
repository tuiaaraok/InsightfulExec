import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hr/hive/hive_boxes.dart';
import 'package:hr/hive/meeting/emloyee_model.dart';
import 'package:hr/my_text_field.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class AddAnEmployeePage extends StatefulWidget {
  const AddAnEmployeePage({super.key});

  @override
  State<AddAnEmployeePage> createState() => _AddAnEmployeePageState();
}

class _AddAnEmployeePageState extends State<AddAnEmployeePage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController jobController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  String previousText = '';
  Uint8List? _image;
  Future getLostData() async {
    XFile? picker = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picker == null) return;
    List<int> imageBytes = await picker.readAsBytes();
    _image = Uint8List.fromList(imageBytes);
    setState(() {});
  }

  bool isValid() {
    return nameController.text.isNotEmpty &&
        dateController.text.isNotEmpty &&
        jobController.text.isNotEmpty &&
        _image != null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: Center(
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
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
        ),
        title: Text(
          "Add an employee",
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            fontSize: 18.55.sp,
          ),
        ),
      ),
      body: Container(
        alignment: Alignment.topCenter,
        color: Color(0xFFF1F3F8),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 17.h),
              Text(
                "Upload a photo",
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                "Format should be in .pdf .jpeg .png less than 5MB",
                style: GoogleFonts.inter(
                  color: Color(0xFF667085),
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16.h),
                child:
                    _image == null
                        ? DottedBorder(
                          color: Color(0xFFBDB4FE),
                          strokeWidth: 1,
                          dashPattern: [6, 3],
                          borderType: BorderType.RRect,
                          radius: Radius.circular(12),
                          padding: EdgeInsets.all(6),
                          child: GestureDetector(
                            onTap: () {
                              getLostData();
                            },
                            child: Container(
                              width: 106.w,
                              height: 100.h,
                              decoration: BoxDecoration(
                                color: Color(0xFFF4F3FF),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8.r),
                                ),
                              ),
                              child: Center(
                                child: SvgPicture.asset(
                                  "assets/icons/add_photo.svg",
                                ),
                              ),
                            ),
                          ),
                        )
                        : Container(
                          width: 106.w,
                          height: 100.h,
                          decoration: BoxDecoration(
                            color: Color(0xFFF4F3FF),
                            borderRadius: BorderRadius.all(
                              Radius.circular(8.r),
                            ),
                            border: Border.all(
                              color: Color(0xFF7A5AF8),
                              width: 1.w,
                            ),
                            image: DecorationImage(
                              image: MemoryImage(_image!),
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
              ),
              MyTextField.textFieldIcon(
                "Full name",
                344.28.w,
                nameController,
                hint: "Enter employee's full name",
                SvgPicture.asset("assets/icons/name.svg"),
                onChange: (p0) {
                  setState(() {});
                },
              ),
              SizedBox(height: 16.h),
              MyTextField.textFieldIcon(
                "Job title",
                344.28.w,
                jobController,
                hint: "Enter job title",
                SvgPicture.asset("assets/icons/job.svg"),
                onChange: (p0) {
                  setState(() {});
                },
              ),
              SizedBox(height: 16.h),
              MyTextField.textFieldIcon(
                "Hire date",
                344.28.w,
                dateController,
                hint: "Enter date",
                SvgPicture.asset("assets/icons/date.svg"),
                onChange: (p0) {
                  validDate(p0, dateController);
                  setState(() {});
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: GestureDetector(
        onTap: () {
          if (isValid()) {
            Box<EmloyeeModel> emloyeeBox = Hive.box<EmloyeeModel>(
              HiveBoxes.emloyeeModel,
            );
            emloyeeBox.add(
              EmloyeeModel(
                imageProfile: _image!,
                fullName: nameController.text,
                jobTitle: jobController.text,
                hireDate: DateFormat('dd/MM/yyyy').parse(dateController.text),
                totalKpi: 0,
                meetingGoals: 0,
                colleaguesRating: "",
                currentGoal: [],
                lastFeedback: [],
              ),
            );
            Navigator.pop(context);
          }
        },
        child: Container(
          color: Colors.white,
          height: 103.08.h,
          child: Center(
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

                  stops: [0, 29, 100],
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

  void validDate(text, TextEditingController dateController) {
    String sanitizedText = text.replaceAll(RegExp(r'[^0-9]'), '');
    String formattedText = '';
    for (int i = 0; i < sanitizedText.length && i < 8; i++) {
      formattedText += sanitizedText[i];
      if (previousText.length > text.length) {
        if (sanitizedText.length > 2) {
          if (i == 1) {
            formattedText += '/';
          }
        }
        if (sanitizedText.length > 4) {
          if (i == 3) {
            formattedText += '/';
          }
        }
      } else {
        if (i == 1 || i == 3) {
          formattedText += '/';
        }
      }
    }

    List<String> parts = formattedText.split('/');
    if (parts.isNotEmpty && parts[0].isNotEmpty) {
      int? day = int.tryParse(parts[0]);
      if (day != null && day > 31) {
        formattedText = formattedText.substring(0, 2);
      }
    }
    if (parts.isNotEmpty && parts.length > 1 && parts[1].isNotEmpty) {
      int? mouth = int.tryParse(parts[1]);
      if (mouth != null && mouth > 12) {
        formattedText = formattedText.substring(0, 2);
      }
    }
    dateController.value = TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
    previousText = dateController.text;
  }
}
