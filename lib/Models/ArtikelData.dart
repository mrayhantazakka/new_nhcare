// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ArtikelData.g.dart';

@JsonSerializable()
class ArtikelData {
  final String judulArtikel;
  final String deskripsiArtikel;
  final String gambarArtikel;

  ArtikelData({
    required this.judulArtikel,
    required this.deskripsiArtikel,
    required this.gambarArtikel,
  });
  factory ArtikelData.fromJson(Map<String, dynamic> json) =>
      _$ArtikelDataFromJson(json);
  Map<String, dynamic> toJson() => _$ArtikelDataToJson(this);
}
