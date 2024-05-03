import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  late int id;
  late String fullname;
  late String username;
  late String password;
  late String confirmpassword;
  late String email;
  late String phone;
  late String question;
  late String answer;

  User({
    this.id = 0, // Make id optional with a default value
    required this.fullname,
    required this.username,
    required this.password,
    required this.confirmpassword,
    required this.email,
    required this.phone,
    required this.question,
    required this.answer,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}
