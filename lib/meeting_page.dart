import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hr/add_meeting_page.dart';
import 'package:hr/hive/hive_boxes.dart';
import 'package:hr/hive/meeting/meeting_model.dart';
import 'package:intl/intl.dart';

class MeetingPage extends StatefulWidget {
  const MeetingPage({super.key});

  @override
  State<MeetingPage> createState() => _MeetingPageState();
}

class _MeetingPageState extends State<MeetingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder: (BuildContext context) => const AddMeetingPage(),
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
            Hive.box<MeetingModel>(HiveBoxes.meetingModel).listenable(),
        builder: (context, Box<MeetingModel> box, _) {
          List<MeetingModel> todayList =
              Hive.box<MeetingModel>(HiveBoxes.meetingModel).values.where((
                element,
              ) {
                return DateFormat('dd/MM/yyyy').format(element.date) ==
                    DateFormat('dd/MM/yyyy').format(DateTime.now());
              }).toList();
          List<MeetingModel> upcomingList =
              Hive.box<MeetingModel>(HiveBoxes.meetingModel).values.where((
                element,
              ) {
                return element.date.isAfter(DateTime.now());
              }).toList();
          return SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Today's meetings header
                    Container(
                      width: 366.w,
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(12.r)),
                      ),
                      child: Column(
                        children: [
                          _buildSectionHeader(
                            'Today Meeting',
                            todayList.length.toString(),
                            'Your schedule for the day',
                          ),

                          // Today's meetings
                          ...todayList.map((e) {
                            return _buildMeetingCard(
                              title: e.agenda,
                              time: e.startEndTime,
                              participant: e.emloyee,
                            );
                          }),

                          // SizedBox(height: 12.h),
                        ],
                      ),
                    ),
                    SizedBox(height: 32.h),

                    // Upcoming meetings header
                    Container(
                      width: 366.w,
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(12.r)),
                      ),
                      child: Column(
                        children: [
                          _buildSectionHeader(
                            'Upcoming meetings',
                            upcomingList.length.toString(),
                            'Your schedule for the upcoming days',
                          ),

                          // Upcoming meetings
                          ...upcomingList.map((e) {
                            return _buildMeetingCard(
                              title: e.agenda,
                              time: e.startEndTime,
                              participant: e.emloyee,
                              date: DateFormat('d MMMM').format(e.date),
                            );
                          }),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(String title, String count, String subtitle) {
    return SizedBox(
      width: 334.w,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              SizedBox(width: 4.w),
              Container(
                padding: EdgeInsets.only(
                  top: 2.h,
                  bottom: 3.h,
                  left: 6.w,
                  right: 6.w,
                ),
                decoration: BoxDecoration(
                  color: Color(0xFFEBE9FE),
                  borderRadius: BorderRadius.all(Radius.circular(4.r)),
                ),
                child: Text(
                  count,
                  style: GoogleFonts.inter(
                    color: Color(0xFF7A5AF8),
                    fontSize: 12.sp,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 4.h),
          Text(
            subtitle,
            style: GoogleFonts.inter(
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              color: Color(0xFF475467),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMeetingCard({
    required String title,
    required String time,
    required String participant,
    String? date,
  }) {
    return Container(
      width: 334.w,
      padding: EdgeInsets.all(16.w),
      margin: EdgeInsets.only(top: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFEAECF0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                ),
              ),

              Row(
                children: [
                  Icon(
                    Icons.access_time,
                    size: 16.sp,
                    color: const Color(0xFF667085),
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    time,
                    style: GoogleFonts.inter(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF667085),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                participant,
                style: GoogleFonts.roboto(
                  fontSize: 14.43.sp,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF667085),
                ),
              ),
              if (date != null) ...[
                SizedBox(height: 8.h),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(100.r)),
                    color: Color(0xFFEBE9FE),
                  ),
                  child: Row(
                    children: [
                      SvgPicture.asset("assets/icons/meeting_caledar.svg"),
                      SizedBox(width: 4.w),
                      Text(
                        date,
                        style: GoogleFonts.inter(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
