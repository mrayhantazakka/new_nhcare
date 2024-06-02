import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ProgramData.g.dart';

@JsonSerializable()
class ProgramData {
  final String namaProgram;
  final String deskripsiProgram;
  final String gambarProgram;

  ProgramData({
    required this.namaProgram,
    required this.deskripsiProgram,
    required this.gambarProgram,
  });
  factory ProgramData.fromJson(Map<String, dynamic> json) =>_$ProgramDataFromJson(json);
  Map<String, dynamic> toJson() => _$ProgramDataToJson(this);
}
