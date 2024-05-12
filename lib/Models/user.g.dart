// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      id: (json['id'] as num?)?.toInt() ?? 0,
      fullname: json['fullname'] as String?,
      username: json['username'] as String?,
      password: json['password'] as String?,
      confirmpassword: json['confirmpassword'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      question: json['question'] as String?,
      answer: json['answer'] as String?,
      token: json['token'] as String?,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'fullname': instance.fullname,
      'username': instance.username,
      'password': instance.password,
      'confirmpassword': instance.confirmpassword,
      'email': instance.email,
      'phone': instance.phone,
      'question': instance.question,
      'answer': instance.answer,
      'token': instance.token,
    };
