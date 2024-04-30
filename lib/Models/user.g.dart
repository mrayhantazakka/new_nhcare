part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      fullname: json['fullname'] as String,
      username: json['username'] as String,
      password: json['password'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
    )..id = json['id'] as int;

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'fullname': instance.fullname,
      'username': instance.username,
      'password': instance.password,
      'email': instance.email,
      'phone': instance.phone,
    };
