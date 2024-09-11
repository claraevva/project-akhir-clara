class Lowongan {
  String key;
  String kategori;
  String posisi;
  String namaKantor;
  String kualifikasi;
  String persyaratan;
  String alamatKantor;
  String email;
  String tanggalExpired;
  String catatan;
  String whatsapp; // Tambahkan atribut catatan
  bool isExpanded;

  Lowongan({
    required this.key,
    required this.kategori,
    required this.posisi,
    required this.namaKantor,
    required this.kualifikasi,
    required this.persyaratan,
    required this.alamatKantor,
    required this.email,
    required this.tanggalExpired,
    required this.catatan, // Tambahkan catatan ke konstruktor
    required this.whatsapp,
    this.isExpanded = false,
  });

  factory Lowongan.fromJson(Map<dynamic, dynamic> json, String key) {
    return Lowongan(
      key: key,
      kategori: json['kategori'],
      posisi: json['posisi'],
      namaKantor: json['namaKantor'],
      kualifikasi: json['kualifikasi'],
      persyaratan: json['persyaratan'],
      alamatKantor: json['alamatKantor'],
      email: json['email'],
      tanggalExpired: json['tanggalExpired'] ?? '',
      catatan: json['catatan'] ?? '', // Ambil catatan dari JSON
      whatsapp: json['whatsapp'] ?? '',
    );
  }

  bool get isExpired {
    DateTime? expiredDate = DateTime.tryParse(tanggalExpired);
    if (expiredDate == null) return false;
    return expiredDate.isBefore(DateTime.now());
  }

  bool get isToday {
    DateTime? expiredDate = DateTime.tryParse(tanggalExpired);
    if (expiredDate == null) return false;
    return expiredDate.isAtSameMomentAs(DateTime.now());
  }

  bool get isFuture {
    DateTime? expiredDate = DateTime.tryParse(tanggalExpired);
    if (expiredDate == null) return false;
    return expiredDate.isAfter(DateTime.now());
  }
}
