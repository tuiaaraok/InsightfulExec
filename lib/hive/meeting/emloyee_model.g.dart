// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'emloyee_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EmloyeeModelAdapter extends TypeAdapter<EmloyeeModel> {
  @override
  final int typeId = 1;

  @override
  EmloyeeModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return EmloyeeModel(
      imageProfile: fields[0] as Uint8List,
      fullName: fields[1] as String,
      jobTitle: fields[2] as String,
      hireDate: fields[3] as DateTime,
      totalKpi: fields[4] as int,
      meetingGoals: fields[5] as int,
      colleaguesRating: fields[6] as String,
      currentGoal: (fields[7] as List).cast<GoanModel>(),
      lastFeedback: (fields[8] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, EmloyeeModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.imageProfile)
      ..writeByte(1)
      ..write(obj.fullName)
      ..writeByte(2)
      ..write(obj.jobTitle)
      ..writeByte(3)
      ..write(obj.hireDate)
      ..writeByte(4)
      ..write(obj.totalKpi)
      ..writeByte(5)
      ..write(obj.meetingGoals)
      ..writeByte(6)
      ..write(obj.colleaguesRating)
      ..writeByte(7)
      ..write(obj.currentGoal)
      ..writeByte(8)
      ..write(obj.lastFeedback);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EmloyeeModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
