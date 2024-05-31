import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

void main() {
  runApp(const MyApp());
}

// Ini adalah kelas utama aplikasi Flutter.
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Judul aplikasi.
      title: 'Pick an Image',

      // Tema aplikasi.
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),

      // Halaman awal aplikasi.
      home: const Home(),

      // Menyembunyikan banner debug di sudut kanan atas.
      debugShowCheckedModeBanner: false,
    );
  }
}

// Kelas Home merupakan stateful widget yang akan menangani akses kamera dan
// menampilkan gambar yang dipilih.
class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // Variabel untuk menyimpan file gambar yang dipilih.
  File? _image;

  // Objek ImagePicker untuk mengambil gambar dari kamera.
  final ImagePicker _picker = ImagePicker();

  // Metode untuk mengambil gambar dari kamera.
  Future getImage() async {
    XFile? image = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 100,
      preferredCameraDevice: CameraDevice.front,
    );
    setState(() {
      if (image != null) {
        // Jika gambar berhasil dipilih, simpan ke dalam variabel _image.
        _image = File(image.path);
      } else {
        // Jika tidak ada gambar yang dipilih, tampilkan pesan.
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // App Bar dengan judul "Demo Akses Kamera".
      appBar: AppBar(
        title: const Text('Demo Akses Kamera'),
      ),

      // Body utama aplikasi.
      body: Container(
        margin: const EdgeInsets.only(top: 20.0),
        alignment: Alignment.topCenter,
        child: _image == null
            // Jika tidak ada gambar yang dipilih, tampilkan pesan.
            ? const Text('Tidak ada gambar')
            // Jika ada gambar yang dipilih, tampilkan gambar tersebut.
            : Image.file(
                _image!,
                width: 300.0,
                fit: BoxFit.fitHeight,
              ),
      ),

      // Floating Action Button untuk mengambil foto dari kamera.
      floatingActionButton: FloatingActionButton(
        onPressed: getImage,
        tooltip: 'Ambil Foto',
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}
