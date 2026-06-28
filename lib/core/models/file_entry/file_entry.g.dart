// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'file_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FileEntry _$FileEntryFromJson(Map<String, dynamic> json) => _FileEntry(
  name: json['name'] as String,
  isDirectory: json['isDirectory'] as bool,
  size: (json['size'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$FileEntryToJson(_FileEntry instance) =>
    <String, dynamic>{
      'name': instance.name,
      'isDirectory': instance.isDirectory,
      'size': instance.size,
    };
