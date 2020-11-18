import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// API Tampil Data
Future<List<Pgw>> fetchPgwai(http.Client client) async {
  final response = await client
      .get('https://myflutteryofi.000webhostapp.com/readDatapegawai.php');

  // Use the compute function to run parsePegawai in a separate isolate.
  return compute(parsePegawai, response.body);
}

// A function that converts a response body into a List<Mhs>.
List<Pgw> parsePegawai(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<Pgw>((json) => Pgw.fromJson(json)).toList();
}

class Pgw {
  final String nip;
  // ignore: non_constant_identifier_names
  final String nama_pegawai;
  final String departemen;
  final String jabatan;
  // ignore: non_constant_identifier_names
  final String pendidikan_terakhir;

  Pgw(
      {this.nip,
      // ignore: non_constant_identifier_names
      this.nama_pegawai,
      this.departemen,
      this.jabatan,
      // ignore: non_constant_identifier_names
      this.pendidikan_terakhir});

  factory Pgw.fromJson(Map<String, dynamic> json) {
    return Pgw(
      nip: json['nip'] as String,
      nama_pegawai: json['nama_pegawai'] as String,
      departemen: json['departemen'] as String,
      jabatan: json['jabatan'] as String,
      pendidikan_terakhir: json['pendidikan_terakhir'] as String,
    );
  }
}

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appTitle = 'Data Pegawai';

    return MaterialApp(
      title: appTitle,
      home: MyHomePage(title: appTitle),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final String title;

  MyHomePage({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.home),
        title: Text(title),
      ),
      body: FutureBuilder<List<Pgw>>(
        future: fetchPgwai(http.Client()),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);

          return snapshot.hasData
              ? MhssList(mhsData: snapshot.data)
              : Center(child: CircularProgressIndicator());
        },
        
      ),
    );
  }
}

class MhssList extends StatelessWidget {
  final List<Pgw> mhsData;

  MhssList({Key key, this.mhsData}) : super(key: key);

  Widget viewData(var data, int index, BuildContext context) {
    return Container(
      width: 200,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        color: Colors.blueGrey[900],
        elevation: 10,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            //ClipRRect(
            //      borderRadius: BorderRadius.only(
            //      topLeft: Radius.circular(8.0),
            //    topRight: Radius.circular(8.0),
            // ),
            // child: Image.network(
            //    "https://avatars0.githubusercontent.com/u/74368872?s=400&v=4"
            //    width: 100,
            //   height: 50,
            //fit:BoxFit.fill

            // ),
            // ),

            ListTile(
              //leading: Image.network(
              //   "https://avatars0.githubusercontent.com/u/74368872?s=400&v=4",
              // ),
              title:
                  Text(data[index].nip, style: TextStyle(color: Colors.white)),
              subtitle: Text(data[index].nama_pegawai,
                  style: TextStyle(color: Colors.white)),
            ),
            ListTile(
           //leading: Image.network(
             //   "https://elearning.binadarma.ac.id/pluginfile.php/1/theme_lambda/logo/1602057627/ubd_logo.png",
             // ),
            title:
                  Text(data[index].departemen, style: TextStyle(color: Colors.white)),
            subtitle: Text(data[index].jabatan,
                  style: TextStyle(color: Colors.white)),
          ),
            // ignore: deprecated_member_use
            ButtonTheme.bar(
              child: ButtonBar(
                children: <Widget>[
                  OutlineButton(
                    child: const Text('Edit',
                        style: TextStyle(color: Colors.white)),
                    onPressed: () {},
                  ),
                  OutlineButton(
                    child: const Text('Delete',
                        style: TextStyle(color: Colors.white)),
                    splashColor: Colors.blueAccent,
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      itemCount: mhsData.length,
      itemBuilder: (context, index) {
        return viewData(mhsData, index, context);
      },
    );
  }
}