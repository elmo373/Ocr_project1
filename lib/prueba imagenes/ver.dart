import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:postgres/postgres.dart';

void main(){
  runApp(ImageScreen());
}

class ImageScreen extends StatelessWidget {
  final String imageName = "prueba.png";

  Future<Uint8List> getImageData() async {
    final connection = PostgreSQLConnection(
      'localhost',
      5432,
      'ocrdb',
      username: 'emanuel',
      password: 'Emi77',
    );

    await connection.open();

    List<List<dynamic>> results = await connection.query('''
      SELECT image_data FROM images WHERE image_name = @name
    ''', substitutionValues: {
      'name': imageName,
    });

    await connection.close();

    if (results.length > 0) {
      // Decoding base64 is not necessary because the image was not encoded to base64 when saving to the database
      List<int> imageBytes = results[0][0].cast<int>();
      return Uint8List.fromList(imageBytes);
    } else {
      return Uint8List(0);  // We return an empty list if there are no results.
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text(imageName),
        ),
        body: Center(
          child: FutureBuilder<Uint8List>(
            future: getImageData(),
            builder: (BuildContext context, AsyncSnapshot<Uint8List> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else {
                if (snapshot.error != null) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  // We check if the size of the image data is greater than 0 before trying to display it
                  return snapshot.data!.lengthInBytes > 0 ? Image.memory(snapshot.data!) : Text('No image found');
                }
              }
            },
          ),
        ),
      ),
    );
  }
}
