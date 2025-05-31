import 'package:hive_flutter/hive_flutter.dart';
part 'goan_model.g.dart';

@HiveType(typeId: 2)
class GoanModel {
  @HiveField(0)
  String selectAnEmployee;
  @HiveField(1)
  String goalName;
  @HiveField(2)
  bool isComleted;
  GoanModel({
    required this.selectAnEmployee,
    required this.goalName,
    required this.isComleted,
  });
}
