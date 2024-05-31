// Definisi kelas Contact
class Contact {
  // Properti id yang opsional (nullable)
  int? id;
  // Properti name dan phone yang harus diinisialisasi
  late String name;
  late String phone;

  // Konstruktor utama untuk menginisialisasi name dan phone
  Contact(this.name, this.phone);

  // Konstruktor bernama forMap untuk membuat objek Contact dari Map
  Contact.forMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    phone = map['phone'];
  }

  // Metode untuk mengonversi objek Contact ke Map
  // Kunci dari Map harus sesuai dengan nama kolom dalam database
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
    };
  }

  // Implementasi metode toString untuk memudahkan melihat informasi tentang
  // setiap contact saat menggunakan pernyataan print
  @override
  String toString() {
    return 'Contact{id: $id, name: $name, phone: $phone}';
  }
}
