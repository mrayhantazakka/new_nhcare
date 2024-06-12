// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
import 'package:json_annotation/json_annotation.dart';

part 'AcaraData.g.dart';

@JsonSerializable()
class AcaraData {
  final String namaAcara;
  final String deskripsiAcara;
  final String gambarAcara;
  final DateTime tanggalAcara;

  AcaraData({
    required this.namaAcara,
    required this.deskripsiAcara,
    required this.gambarAcara,
    required this.tanggalAcara
  });
  factory AcaraData.fromJson(Map<String, dynamic> json) =>
      _$AcaraDataFromJson(json);
  Map<String, dynamic> toJson() => _$AcaraDataToJson(this);
}
