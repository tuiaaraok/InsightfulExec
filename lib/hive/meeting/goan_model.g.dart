// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goan_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GoanModelAdapter extends TypeAdapter<GoanModel> {
  @override
  final int typeId = 2;

  @override
  GoanModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GoanModel(
      selectAnEmployee: fields[0] as String,
      goalName: fields[1] as String,
      isComleted: fields[2] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, GoanModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.selectAnEmployee)
      ..writeByte(1)
      ..write(obj.goalName)
      ..writeByte(2)
      ..write(obj.isComleted);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GoanModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
