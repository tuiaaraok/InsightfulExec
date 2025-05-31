import 'package:hive_flutter/hive_flutter.dart';
part 'meeting_model.g.dart';

@HiveType(typeId: 3)
class MeetingModel {
  @HiveField(0)
  String emloyee;
  @HiveField(1)
  DateTime date;
  @HiveField(2)
  String startEndTime;
  @HiveField(3)
  String agenda;
  MeetingModel({
    required this.emloyee,
    required this.date,
    required this.startEndTime,
    required this.agenda,
  });
}
