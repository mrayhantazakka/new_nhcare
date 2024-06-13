// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'AnakData.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AnakData _$AnakDataFromJson(Map<String, dynamic> json) => AnakData(
      nama: json['nama'] as String,
      kelas: json['kelas'] as String,
      tingkat: json['tingkat'] as String,
      cabang: json['cabang'] as String,
      img_anak: json['img_anak'] as String,
      prestasi: (json['prestasi'] as List<dynamic>?)
          ?.map((e) => PrestasiAnakAsuh.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$AnakDataToJson(AnakData instance) => <String, dynamic>{
      'nama': instance.nama,
      'kelas': instance.kelas,
      'tingkat': instance.tingkat,
      'cabang': instance.cabang,
      'img_anak': instance.img_anak,
      'prestasi': instance.prestasi,
    };
