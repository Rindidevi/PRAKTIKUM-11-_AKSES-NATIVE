// Import library yang diperlukan
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:url_launcher/url_launcher.dart';

// Fungsi utama
void main() async {
  // Menjalankan aplikasi Flutter
  runApp(const MyApp());
}

// Kelas MyApp, merupakan stateless widget yang akan menampilkan tata letak dasar aplikasi
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // Metode build untuk membangun tampilan aplikasi
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Judul aplikasi
      title: 'Read Contact App',
      // Tema aplikasi
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // Halaman beranda aplikasi
      home: const MyHomePage(),
      // Menyembunyikan banner debug
      debugShowCheckedModeBanner: false,
    );
  }
}

// Kelas MyHomePage, merupakan StatefulWidget yang akan menampilkan daftar kontak
class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  // Membuat state untuk MyHomePage
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

// State dari MyHomePage
class _MyHomePageState extends State<MyHomePage> {
  // List untuk menyimpan kontak
  List<Contact>? contacts;

  // Metode initState, dipanggil saat widget pertama kali dibuat
  @override
  void initState() {
    super.initState();
    // Memanggil fungsi getContact untuk mendapatkan daftar kontak
    getContact();
  }

  // Fungsi untuk mendapatkan daftar kontak
  void getContact() async {
    // Meminta izin untuk mengakses kontak
    if (await FlutterContacts.requestPermission()) {
      // Mendapatkan daftar kontak dengan foto dan properti
      contacts = await FlutterContacts.getContacts(
        withProperties: true,
        withPhoto: true,
      );
      // Memperbarui tampilan
      setState(() {});
    }
  }

  // Metode build untuk membangun tampilan widget
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar
      appBar: AppBar(
        // Judul AppBar
        title: const Text(
          "Read Contact App",
          style: TextStyle(color: Colors.blue),
        ),
        // Pusatkan judul AppBar
        centerTitle: true,
        // Warna latar belakang transparan
        backgroundColor: Colors.transparent,
        // Tidak ada bayangan (elevation) pada AppBar
        elevation: 0,
      ),
      // Tubuh (body) dari aplikasi
      body: (contacts) == null
          // Jika kontak masih belum tersedia, tampilkan indikator loading
          ? const Center(child: CircularProgressIndicator())
          // Jika kontak sudah tersedia, tampilkan daftar kontak menggunakan ListView.builder
          : ListView.builder(
              // Jumlah item adalah panjang dari daftar kontak
              itemCount: contacts!.length,
              // Membangun setiap item daftar kontak
              itemBuilder: (BuildContext context, int index) {
                // Ambil foto dari kontak (jika ada)
                Uint8List? image = contacts![index].photo;
                // Ambil nomor telepon dari kontak (jika ada)
                String num = (contacts![index].phones.isNotEmpty)
                    ? (contacts![index].phones.first.number)
                    : "--";
                // Tampilkan ListTile untuk setiap kontak
                return ListTile(
                  // Avatar kontak (jika tidak ada foto, gunakan ikon default)
                  leading: (contacts![index].photo == null)
                      ? const CircleAvatar(child: Icon(Icons.person))
                      : CircleAvatar(backgroundImage: MemoryImage(image!)),
                  // Judul kontak (nama depan dan belakang)
                  title: Text(
                      "${contacts![index].name.first} ${contacts![index].name.last}"),
                  // Subjudul kontak (nomor telepon)
                  subtitle: Text(num),
                  // Aksi saat item daftar diklik (lakukan panggilan jika nomor telepon tersedia)
                  onTap: () {
                    if (contacts![index].phones.isNotEmpty) {
                      launch('tel: $num');
                    }
                  },
                );
              },
            ),
    );
  }
}
