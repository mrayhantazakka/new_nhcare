// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ProgramData.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProgramData _$ProgramDataFromJson(Map<String, dynamic> json) => ProgramData(
      judul: json['judul'] as String,
      deskripsi: json['deskripsi'] as String,
      img_program: json['img_program'] as String,
      id_user: json['id_user'] as String,
    );

Map<String, dynamic> _$ProgramDataToJson(ProgramData instance) =>
    <String, dynamic>{
      'judul': instance.judul,
      'deskripsi': instance.deskripsi,
      'img_program': instance.img_program,
      'id_user': instance.id_user,
    };
