// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      id: (json['id'] as num?)?.toInt() ?? 0,
      nama_donatur: json['nama_donatur'] as String?,
      alamat: json['alamat'] as String?,
      password: json['password'] as String?,
      confirmpassword: json['confirmpassword'] as String?,
      email: json['email'] as String?,
      nomor_handphone: json['nomor_handphone'] as String?,
      pertanyaan: json['pertanyaan'] as String?,
      jawaban: json['jawaban'] as String?,
      jenis_kelamin: json['jenis_kelamin'] as String?,
      token: json['token'] as String?,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'nama_donatur': instance.nama_donatur,
      'nomor_handphone': instance.nomor_handphone,
      'alamat': instance.alamat,
      'email': instance.email,
      'password': instance.password,
      'confirmpassword': instance.confirmpassword,
      'pertanyaan': instance.pertanyaan,
      'jawaban': instance.jawaban,
      'jenis_kelamin': instance.jenis_kelamin,
      'token': instance.token,
    };
