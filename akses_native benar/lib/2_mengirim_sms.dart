import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Send SMS',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Send SMS'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _numController = TextEditingController();
  final TextEditingController _msgController = TextEditingController();
  String _message = "";

  Future<void> _sendSMS(String phoneNumber, String message) async {
    final Uri uri = Uri(
      scheme: 'sms',
      path: phoneNumber,
      queryParameters: <String, String>{
        'body': message,
      },
    );
    if (await canLaunch(uri.toString())) {
      await launch(uri.toString());
    } else {
      setState(() {
        _message = 'Could not launch SMS app';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: <Widget>[
              TextField(
                controller: _numController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  hintText: 'Masukan nomor handphone',
                ),
              ),
              const SizedBox(height: 30.0),
              TextField(
                controller: _msgController,
                maxLines: 5,
                decoration: const InputDecoration(
                  hintText: 'Pesan SMS',
                ),
              ),
              const SizedBox(height: 30.0),
              FloatingActionButton(
                tooltip: 'Kirim SMS',
                child: const Icon(Icons.sms),
                onPressed: () {
                  _sendSMS(_numController.text, _msgController.text);
                },
              ),
              const SizedBox(height: 20.0),
              Text(_message),
            ],
          ),
        ),
      ),
    );
  }
}
