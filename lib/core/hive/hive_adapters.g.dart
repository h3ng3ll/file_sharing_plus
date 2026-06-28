// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_adapters.dart';

// **************************************************************************
// AdaptersGenerator
// **************************************************************************

class TransferRecordAdapter extends TypeAdapter<TransferRecord> {
  @override
  final typeId = 0;

  @override
  TransferRecord read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TransferRecord(
      fileName: fields[0] as String,
      direction: fields[1] as TransferDirection,
      success: fields[2] as bool,
      timestamp: fields[3] as DateTime,
      savedPath: fields[4] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, TransferRecord obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.fileName)
      ..writeByte(1)
      ..write(obj.direction)
      ..writeByte(2)
      ..write(obj.success)
      ..writeByte(3)
      ..write(obj.timestamp)
      ..writeByte(4)
      ..write(obj.savedPath);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TransferRecordAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TransferDirectionAdapter extends TypeAdapter<TransferDirection> {
  @override
  final typeId = 1;

  @override
  TransferDirection read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return TransferDirection.download;
      case 1:
        return TransferDirection.upload;
      default:
        return TransferDirection.download;
    }
  }

  @override
  void write(BinaryWriter writer, TransferDirection obj) {
    switch (obj) {
      case TransferDirection.download:
        writer.writeByte(0);
      case TransferDirection.upload:
        writer.writeByte(1);
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TransferDirectionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SharedFolderAdapter extends TypeAdapter<SharedFolder> {
  @override
  final typeId = 2;

  @override
  SharedFolder read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SharedFolder(path: fields[0] as String);
  }

  @override
  void write(BinaryWriter writer, SharedFolder obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.path);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SharedFolderAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ServerSettingsAdapter extends TypeAdapter<ServerSettings> {
  @override
  final typeId = 3;

  @override
  ServerSettings read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ServerSettings(port: (fields[0] as num).toInt());
  }

  @override
  void write(BinaryWriter writer, ServerSettings obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.port);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ServerSettingsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
