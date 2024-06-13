import 'package:json_annotation/json_annotation.dart';
import 'package:nhcoree/Models/PrestasiAnakAsuh.dart';

part 'AnakData.g.dart';

@JsonSerializable()
class AnakData {
  final String nama;
  final String kelas;
  final String tingkat;
  final String cabang;
  final String img_anak;
  List<PrestasiAnakAsuh>? prestasi;

  AnakData({
    required this.nama,
    required this.kelas,
    required this.tingkat,
    required this.cabang,
    required this.img_anak,
    required this.prestasi,
  });
  factory AnakData.fromJson(Map<String, dynamic> json) =>
      _$AnakDataFromJson(json);
  Map<String, dynamic> toJson() => _$AnakDataToJson(this);
}
