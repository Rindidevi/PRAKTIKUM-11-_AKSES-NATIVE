import 'package:flutter/material.dart';
import 'package:kab_riau/helpers/dbhelper.dart';
import 'package:kab_riau/models/kabupaten.dart';
import 'package:sqflite/sqflite.dart';
import 'entryform.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _count = 0;
  List<Kabupaten> _kabupatenList = [];

  @override
  void initState() {
    super.initState();
    updateListView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Kabupaten/Kota di Riau'),
        backgroundColor: Colors.orange, // Ubah warna appbar menjadi oranye
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0), // Atur padding pada ListView
        child: createListView(),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        tooltip: 'Tambah Kabupaten/Kota',
        backgroundColor: Colors.orange, // Ubah warna button tambah menjadi oranye
        onPressed: () async {
          var kabupaten = await navigateToEntryForm(context, Kabupaten("", "", "", "", 0, 0, 0, 0, 0, ""));
          if (kabupaten != null) addKabupaten(kabupaten);
        },
      ),
    );
  }

  Future<Kabupaten> navigateToEntryForm(BuildContext context, Kabupaten kabupaten) async {
    var result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) {
          return EntryForm(kabupaten);
        },
      ),
    );
    return result;
  }

  ListView createListView() {
    return ListView.builder(
      itemCount: _count,
      itemBuilder: (BuildContext context, int index) {
        return Card(
          elevation: 2.0,
          color: Colors.orange, // Ubah warna latar belakang list menjadi oranye
          child: Padding(
            padding: const EdgeInsets.all(8.0), // Atur padding pada ListTile
            child: ListTile(
              contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0), // Atur padding content ListTile
              leading: Image.network(_kabupatenList[index].logo),
              title: Text(
                _kabupatenList[index].name,
                style: TextStyle(color: Colors.white), // Ubah warna teks menjadi putih
              ),
              subtitle: Text(
                _kabupatenList[index].pusatPemerintahan,
                style: TextStyle(color: Colors.white), // Ubah warna teks menjadi putih
              ),
              trailing: GestureDetector(
                child: Icon(
                  Icons.delete,
                  color: Colors.white, // Ubah warna icon menjadi putih
                ),
                onTap: () {
                  deleteKabupaten(_kabupatenList[index].id!);
                },
              ),
              onTap: () async {
                var kabupaten = await navigateToEntryForm(context, _kabupatenList[index]);
                if (kabupaten != null) editKabupaten(kabupaten);
              },
            ),
          ),
        );
      },
    );
  }

  void addKabupaten(Kabupaten kabupaten) async {
    int result = await DbHelper.insert(kabupaten);
    if (result > 0) {
      updateListView();
    }
  }

  void editKabupaten(Kabupaten kabupaten) async {
    int result = await DbHelper.update(kabupaten);
    if (result > 0) {
      updateListView();
    }
  }

  void deleteKabupaten(int id) async {
    int result = await DbHelper.delete(id);
    if (result > 0) {
      updateListView();
    }
  }

  void updateListView() async {
    final Future<Database> dbFuture = DbHelper.db();
    dbFuture.then((database) {
      Future<List<Kabupaten>> kabupatenListFuture = DbHelper.getKabupatenList();
      kabupatenListFuture.then((kabupatenList) {
        setState(() {
          _kabupatenList = kabupatenList;
          _count = kabupatenList.length;
        });
      });
    });
  }
}
