

class AcaraData{
  final DateTime tanggalAcara;
  final String judul;
  final String deskripsi;

  AcaraData({
    required this.tanggalAcara,
    required this.judul,
    required this.deskripsi,
  });

  factory AcaraData.fromJson(Map<String, dynamic> json) {
    return AcaraData(
      tanggalAcara: DateTime.parse(json['tanggal_acara']),
      judul: json['judul'],
      deskripsi: json['deskripsi'],
    );
  }
}