// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'AcaraData.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AcaraData _$AcaraDataFromJson(Map<String, dynamic> json) => AcaraData(
      namaAcara: json['namaAcara'] as String,
      deskripsiAcara: json['deskripsiAcara'] as String,
      gambarAcara: json['gambarAcara'] as String,
      tanggalAcara: DateTime.parse(json['tanggalAcara'] as String),
    );

Map<String, dynamic> _$AcaraDataToJson(AcaraData instance) => <String, dynamic>{
      'namaAcara': instance.namaAcara,
      'deskripsiAcara': instance.deskripsiAcara,
      'gambarAcara': instance.gambarAcara,
      'tanggalAcara': instance.tanggalAcara.toIso8601String(),
    };
