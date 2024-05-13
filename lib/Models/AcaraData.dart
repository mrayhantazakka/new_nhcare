import 'dart:convert';


class Acara {
  int? idAcara;
  String? judul;
  String? deskripsi;
  DateTime? tanggalAcara; 
  int? idUser;
  DateTime? createdAt;
  DateTime? updatedAt;

  Acara({
    this.idAcara,
    this.judul,
    this.deskripsi,
    this.tanggalAcara,
    this.idUser,
    this.createdAt,
    this.updatedAt,
  });

  factory Acara.fromMap(Map<String, dynamic> data) => Acara(
        idAcara: data['id_acara'] as int?,
        judul: data['judul'] as String?,
        deskripsi: data['deskripsi'] as String?,
        tanggalAcara: data['tanggal_acara'] == null
            ? null
            : DateTime.parse(data['tanggal_acara'] as String),
        idUser: data['id_user'] as int?,
        createdAt: data['created_at'] == null
            ? null
            : DateTime.parse(data['created_at'] as String),
        updatedAt: data['updated_at'] == null
            ? null
            : DateTime.parse(data['updated_at'] as String),
      );

  Map<String, dynamic> toMap() => {
        'id_acara': idAcara,
        'judul': judul,
        'deskripsi': deskripsi,
        'tanggal_acara': tanggalAcara?.toIso8601String(), 
        'id_user': idUser,
        'created_at': createdAt?.toIso8601String(),
        'updated_at': updatedAt?.toIso8601String(),
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Acara].
  factory Acara.fromJson(String data) {
    return Acara.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Acara] to a JSON string.
  String toJson() => json.encode(toMap());
}
