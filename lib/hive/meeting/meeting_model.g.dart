// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meeting_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MeetingModelAdapter extends TypeAdapter<MeetingModel> {
  @override
  final int typeId = 3;

  @override
  MeetingModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MeetingModel(
      emloyee: fields[0] as String,
      date: fields[1] as DateTime,
      startEndTime: fields[2] as String,
      agenda: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, MeetingModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.emloyee)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.startEndTime)
      ..writeByte(3)
      ..write(obj.agenda);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MeetingModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
