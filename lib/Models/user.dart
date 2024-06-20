import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  late String? id_donatur;
  late String? nama_donatur;
  late String? nomor_handphone;
  late String? alamat;
  late String? email;
  late String? password;
  late String? confirmpassword;
  late String? pertanyaan;
  late String? jawaban;
  late String? jenis_kelamin;
  late String? foto_donatur;
  late String? token;

  User({
    required this.id_donatur, 
    required this.nama_donatur,
    required this.alamat,
    required this.password,
    required this.confirmpassword,
    required this.email,
    required this.nomor_handphone,
    required this.pertanyaan,
    required this.jawaban,
    required this.jenis_kelamin,
    required this.foto_donatur,
    required this.token,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}
