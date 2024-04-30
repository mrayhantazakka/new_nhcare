import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  late int id;
  late String fullname;
  late String username;
  late String password;
  late String email;
  late String phone;

  User({
    required this.fullname,
    required this.username,
    required this.password,
    required this.email,
    required this.phone,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}