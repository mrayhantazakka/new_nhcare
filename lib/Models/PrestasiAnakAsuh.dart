import 'package:json_annotation/json_annotation.dart';

part 'PrestasiAnakAsuh.g.dart';

@JsonSerializable()
class PrestasiAnakAsuh {
  @JsonKey(name: 'id_anakasuh')
  final String id_anakasuh;
  final String nama_prestasi;

  PrestasiAnakAsuh({
    required this.id_anakasuh,
    required this.nama_prestasi,
  });
  factory PrestasiAnakAsuh.fromJson(Map<String, dynamic> json) =>
      _$PrestasiAnakAsuhFromJson(json);
  Map<String, dynamic> toJson() => _$PrestasiAnakAsuhToJson(this);
}
