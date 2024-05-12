import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:json_annotation/json_annotation.dart';

part 'AnakData.g.dart';

@JsonSerializable()
class AnakData {
  final String nama;
  final String nama_sekolah;
  final String kelas;
  final String deskripsi;
  final String img_anak;

  AnakData({
    required this.nama,
    required this.nama_sekolah,
    required this.kelas,
    required this.deskripsi,
    required this.img_anak,
  });
  factory AnakData.fromJson(Map<String, dynamic> json) =>
      _$AnakDataFromJson(json);
  Map<String, dynamic> toJson() => _$AnakDataToJson(this);
}
