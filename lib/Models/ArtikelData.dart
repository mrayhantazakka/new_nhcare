// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ArtikelData.g.dart';

@JsonSerializable()
class ArtikelData {
  final String judul_artikel;
  final String deskripsi_artikel;
  final String gambar_artikel;

  ArtikelData({
    required this.judul_artikel,
    required this.deskripsi_artikel,
    required this.gambar_artikel,
  });
  factory ArtikelData.fromJson(Map<String, dynamic> json) =>
      _$ArtikelDataFromJson(json);
  Map<String, dynamic> toJson() => _$ArtikelDataToJson(this);
}
