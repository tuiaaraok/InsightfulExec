import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hr/hive/meeting/goan_model.dart';
part 'emloyee_model.g.dart';

@HiveType(typeId: 1)
class EmloyeeModel {
  @HiveField(0)
  Uint8List imageProfile;
  @HiveField(1)
  String fullName;
  @HiveField(2)
  String jobTitle;
  @HiveField(3)
  DateTime hireDate;
  @HiveField(4)
  int totalKpi;
  @HiveField(5)
  int meetingGoals;
  @HiveField(6)
  String colleaguesRating;
  @HiveField(7)
  List<GoanModel> currentGoal;
  @HiveField(8)
  List<String> lastFeedback;
  EmloyeeModel({
    required this.imageProfile,
    required this.fullName,
    required this.jobTitle,
    required this.hireDate,
    required this.totalKpi,
    required this.meetingGoals,
    required this.colleaguesRating,
    required this.currentGoal,
    required this.lastFeedback,
  });
}
