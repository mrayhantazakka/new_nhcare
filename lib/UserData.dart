// Class untuk menyimpan data pengguna
class UserData {
  final String fullname;
  final String username;
  final String email;
  final String phone;
  final String alamat;
  final String agama;
  final String gender;
  final String password;
  final String konfirmasiPassword;

//construktor
  UserData({
    required this.fullname,
    required this.username,
    required this.email,
    required this.phone,
    required this.alamat,
    required this.agama,
    required this.gender,
    required this.password,
    required this.konfirmasiPassword,
  });
}
