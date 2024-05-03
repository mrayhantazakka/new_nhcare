import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ProgramData.g.dart';

@JsonSerializable()
class ProgramData {
  final String judul;
  final String deskripsi;
  final String img_program;
  final String id_user;

  ProgramData({
    required this.judul,
    required this.deskripsi,
    required this.img_program,
    required this.id_user,
  });
  factory ProgramData.fromJson(Map<String, dynamic> json) => _$ProgramDataFromJson(json);
Map<String, dynamic> toJson() => _$ProgramDataToJson(this);
}
