import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:postgres/postgres.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final String imageName = "prueba.png";
  final String imagePath = 'C:\Users\milto\OneDrive\Desktop\Nueva carpeta\prueba.png';

  Future<void> checkAndSaveImage() async {
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

    if (results.isEmpty) {
      final imageFile = File(imagePath);

      if (await imageFile.exists()) {
        List<int> imageBytes = imageFile.readAsBytesSync();

        await connection.query('''
          INSERT INTO images(image_name, image_data) VALUES(@name, @data)
        ''', substitutionValues: {
          'name': imageName,
          'data': imageBytes,
        });
      } else {
        throw Exception('File does not exist');
      }
    }

    await connection.close();
  }

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
      // We cast the data to Uint8List which Flutter can use to display the image
      Uint8List imageBytes = Uint8List.fromList(results[0][0].cast<int>());
      return imageBytes;
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
          child: FutureBuilder(
            future: Future.wait([
              checkAndSaveImage(),
              getImageData(),
            ]),
            builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else {
                if (snapshot.error != null) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  // We check if the size of the image data is greater than 0 before trying to display it
                  Uint8List imageData = snapshot.data![1];
                  return imageData.lengthInBytes > 0 ? Image.memory(imageData) : Text('No image found');
                }
              }
            },
          ),
        ),
      ),
    );
  }
}
