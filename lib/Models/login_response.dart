import 'dart:convert';

class LoginResponse {
  bool? status;
  String? message;
  String? token;

  LoginResponse({this.status, this.message, this.token});

  factory LoginResponse.fromMap(Map<String, dynamic> data) => LoginResponse(
        status: data['status'] as bool?,
        message: data['message'] as String?,
        token: data['token'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'status': status,
        'message': message,
        'token': token,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [LoginResponse].
  factory LoginResponse.fromJson(String data) {
    return LoginResponse.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [LoginResponse] to a JSON string.
  String toJson() => json.encode(toMap());
}
