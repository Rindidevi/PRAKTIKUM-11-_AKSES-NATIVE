class Kabupaten {
  int? id;
  late String logo;
  late String name;
  late String pusatPemerintahan;
  late String bupatiWalikota;
  late double luasWilayah;
  late int jumlahPenduduk;
  late int jumlahKecamatan;
  late int jumlahKelurahan;
  late int jumlahDesa;
  late String link;

  Kabupaten(
    this.logo,
    this.name,
    this.pusatPemerintahan,
    this.bupatiWalikota,
    this.luasWilayah,
    this.jumlahPenduduk,
    this.jumlahKecamatan,
    this.jumlahKelurahan,
    this.jumlahDesa,
    this.link,
  );

  Kabupaten.forMap(Map<String, dynamic> map) {
    id = map['id'];
    logo = map['logo'];
    name = map['name'];
    pusatPemerintahan = map['pusatPemerintahan'];
    bupatiWalikota = map['bupatiWalikota'];
    luasWilayah = map['luasWilayah'];
    jumlahPenduduk = map['jumlahPenduduk'];
    jumlahKecamatan = map['jumlahKecamatan'];
    jumlahKelurahan = map['jumlahKelurahan'];
    jumlahDesa = map['jumlahDesa'];
    link = map['link'];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'logo': logo,
      'name': name,
      'pusatPemerintahan': pusatPemerintahan,
      'bupatiWalikota': bupatiWalikota,
      'luasWilayah': luasWilayah,
      'jumlahPenduduk': jumlahPenduduk,
      'jumlahKecamatan': jumlahKecamatan,
      'jumlahKelurahan': jumlahKelurahan,
      'jumlahDesa': jumlahDesa,
      'link': link,
    };
  }

  @override
  String toString() {
    return 'Kabupaten{id: $id, logo: $logo, name: $name, pusatPemerintahan: $pusatPemerintahan, bupatiWalikota: $bupatiWalikota, luasWilayah: $luasWilayah, jumlahPenduduk: $jumlahPenduduk, jumlahKecamatan: $jumlahKecamatan, jumlahKelurahan: $jumlahKelurahan, jumlahDesa: $jumlahDesa, link: $link}';
  }
}
