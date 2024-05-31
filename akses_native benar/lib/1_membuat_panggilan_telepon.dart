import 'dart:async'; // Mengimpor pustaka Dart untuk operasi asinkron (Future, Stream, dll.)
import 'package:flutter/material.dart'; // Mengimpor pustaka Flutter untuk membangun UI
import 'package:url_launcher/url_launcher.dart'; // Mengimpor pustaka url_launcher untuk membuka URL

void main() {
  runApp(const MyApp()); // Menjalankan aplikasi Flutter dengan widget MyApp sebagai root
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'URL Launcher', // Menentukan judul aplikasi
      theme: ThemeData(
        primarySwatch: Colors.blue, // Menentukan tema aplikasi dengan warna utama biru
      ),
      home: const MyHomePage(title: 'URL Launcher'), // Menentukan widget home sebagai MyHomePage
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title; // Properti untuk menyimpan judul halaman

  @override
  _MyHomePageState createState() => _MyHomePageState(); // Membuat state untuk widget MyHomePage
}

class _MyHomePageState extends State<MyHomePage> {
  bool _hasCallSupport = false; // Menyimpan status dukungan panggilan telepon
  Future<void>? _launched; // Menyimpan status peluncuran URL
  String _phone = ''; // Menyimpan nomor telepon yang akan dipanggil

  @override
  void initState() {
    super.initState();
    // Memeriksa dukungan untuk panggilan telepon
    canLaunch('tel:123').then((bool result) {
      setState(() {
        _hasCallSupport = result; // Mengupdate status dukungan panggilan
      });
    });
  }

  // Fungsi untuk melakukan panggilan telepon
  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel', // Skema URI untuk panggilan telepon
      path: phoneNumber, // Nomor telepon yang akan dipanggil
    );
    await launch(launchUri.toString()); // Meluncurkan URI
  }

  // Fungsi untuk membuka URL di browser
  Future<void> _launchInBrowser(String url) async {
    if (!await launch(
      url,
      forceSafariVC: false, // Tidak memaksa menggunakan Safari View Controller (untuk iOS)
      forceWebView: false, // Tidak memaksa menggunakan WebView
      headers: <String, String>{'my_header_key': 'my_header_value'}, // Header tambahan
    )) {
      throw 'Could not launch $url'; // Melempar kesalahan jika URL tidak dapat dibuka
    }
  }

  // Fungsi untuk menampilkan status peluncuran URL
  Widget _launchStatus(BuildContext context, AsyncSnapshot<void> snapshot) {
    if (snapshot.hasError) {
      return Text('Error: ${snapshot.error}'); // Menampilkan kesalahan jika ada
    } else {
      return const Text(''); // Menampilkan teks kosong jika tidak ada kesalahan
    }
  }

  @override
  Widget build(BuildContext context) {
    const String toLaunch = 'https://www.polbeng.ac.id/'; // URL yang akan dibuka

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title), // Menampilkan judul halaman pada AppBar
      ),
      body: ListView(
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16.0), // Memberikan padding di sekitar TextField
                child: TextField(
                  onChanged: (String text) => _phone = text, // Mengupdate nomor telepon saat diubah
                  decoration: const InputDecoration(
                    hintText: 'Input the phone number to launch' // Placeholder pada TextField
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: _hasCallSupport
                  ? () => setState(
                      () {
                        _launched = _makePhoneCall(_phone); // Memanggil fungsi panggilan telepon jika didukung
                      },
                    )
                  : null, // Jika tidak didukung, tombol dinonaktifkan
                child: _hasCallSupport
                  ? const Text('Make phone call') // Teks tombol jika panggilan didukung
                  : const Text('Calling not supported'), // Teks tombol jika panggilan tidak didukung
              ),
              const Padding(
                padding: EdgeInsets.all(16.0), // Memberikan padding di sekitar teks
                child: Text(toLaunch), // Menampilkan URL yang akan dibuka
              ),
              ElevatedButton(
                onPressed: () => setState(
                  () {
                    _launched = _launchInBrowser(toLaunch); // Memanggil fungsi untuk membuka URL di browser
                  },
                ),
                child: const Text('Launch in browser'), // Teks pada tombol untuk membuka URL
              ),
              const Padding(padding: EdgeInsets.all(16.0)), // Padding tambahan
              FutureBuilder<void>(
                future: _launched, // Membangun widget berdasarkan status Future _launched
                builder: _launchStatus, // Fungsi builder untuk menampilkan status peluncuran
              ),
            ],
          ),
        ],
      ),
    );
  }
}
