import 'package:akses_sqlite/helpers/dbhelper.dart'; // Mengimpor helper untuk akses database SQLite
import 'package:akses_sqlite/models/contact.dart'; // Mengimpor model Contact yang merepresentasikan data kontak
import 'package:flutter/material.dart'; // Mengimpor package Flutter untuk membuat UI
import 'package:sqflite/sqflite.dart'; // Mengimpor package sqflite untuk operasi database SQLite
import 'entryform.dart'; // Mengimpor file entryform.dart yang mungkin berisi form untuk menginput kontak

// Kelas utama yang merupakan StatefulWidget
class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);
  @override
  _HomeState createState() => _HomeState();
}

// State untuk widget Home
class _HomeState extends State<Home> {
  int _count = 0; // Variabel untuk menyimpan jumlah kontak
  List<Contact> _contactList = []; // List untuk menyimpan data kontak

  @override
  void initState() {
    super.initState();
    updateListView(); // Memperbarui tampilan list view saat state diinisialisasi
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Coba Akses SQLite'), // Judul AppBar
      ),
      body: createListView(), // Membuat tampilan list view
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add), // Ikon untuk floating action button
          tooltip: 'Tambah Contact', // Tooltip untuk button
          onPressed: () async {
            var contact = await navigateToEntryForm(
                context,
                Contact("",
                    "")); // Navigasi ke form entry untuk menambahkan kontak baru
            addContact(contact); // Menambahkan kontak baru ke database
          }),
    );
  }

  // Fungsi untuk navigasi ke form entry dan mengembalikan data kontak
  Future<Contact> navigateToEntryForm(
      BuildContext context, Contact contact) async {
    var result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) {
          return EntryForm(contact); // Menampilkan form entry
        },
      ),
    );
    return result;
  }

  // Fungsi untuk membuat ListView dari data kontak
  ListView createListView() {
    return ListView.builder(
      itemCount: _count, // Jumlah item dalam list
      itemBuilder: (BuildContext context, int index) {
        return Card(
          elevation: 2.0,
          child: ListTile(
            leading: const CircleAvatar(
              backgroundColor: Colors.red,
              child: Icon(Icons.people),
            ),
            title: Text(
              _contactList[index].name, // Menampilkan nama kontak
            ),
            subtitle: Text(
              _contactList[index]
                  .phone
                  .toString(), // Menampilkan nomor telepon kontak
            ),
            trailing: GestureDetector(
              child: const Icon(Icons.delete),
              onTap: () {
                deleteContact(_contactList[index]
                    .id!); // Menghapus kontak ketika ikon delete ditekan
              },
            ),
            onTap: () async {
              var contact = await navigateToEntryForm(
                  context,
                  _contactList[
                      index]); // Navigasi ke form entry untuk mengedit kontak
              editContact(contact); // Mengedit kontak yang ada di database
            },
          ),
        );
      },
    );
  }

  // Fungsi untuk menambahkan kontak baru ke database
  void addContact(Contact contact) async {
    int result =
        await DbHelper.insert(contact); // Menyisipkan data kontak ke database
    if (result > 0) {
      updateListView(); // Memperbarui tampilan list view jika penambahan berhasil
    }
  }

  // Fungsi untuk mengedit kontak yang ada di database
  void editContact(Contact contact) async {
    int result =
        await DbHelper.update(contact); // Memperbarui data kontak di database
    if (result > 0) {
      updateListView(); // Memperbarui tampilan list view jika pengeditan berhasil
    }
  }

  // Fungsi untuk menghapus kontak dari database
  void deleteContact(int id) async {
    int result =
        await DbHelper.delete(id); // Menghapus data kontak dari database
    if (result > 0) {
      updateListView(); // Memperbarui tampilan list view jika penghapusan berhasil
    }
  }

  // Fungsi untuk memperbarui tampilan list view dengan mengambil data terbaru dari database
  void updateListView() {
    final Future<Database> dbFuture =
        DbHelper.db(); // Mendapatkan instance database
    dbFuture.then((database) {
      Future<List<Contact>> contactListFuture =
          DbHelper.getContactList(); // Mendapatkan list kontak dari database
      contactListFuture.then((contactList) {
        setState(() {
          _contactList = contactList; // Menyimpan list kontak ke variabel state
          _count = contactList.length; // Mengupdate jumlah kontak
        });
      });
    });
  }
}
