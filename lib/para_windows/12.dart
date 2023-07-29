import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:googleapis/storage/v1.dart' as storage;
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: ElevatedButton(
            child: Text('Subir archivo'),
            onPressed: () async {
              final scopes = [storage.StorageApi.devstorageFullControlScope];
              var client = await auth.clientViaServiceAccount(
                  auth.ServiceAccountCredentials.fromJson(
                      jsonDecode(File('durable-path-393614-5d6dd291971f.json').readAsStringSync())),
                  scopes);
              var api = storage.StorageApi(client);

              // Leer el archivo desde la ruta especificada
              var file = File('C:\\Users\\milto\\OneDrive\\Desktop\\Nueva carpeta\\prueba.png');
              var fileBytes = await file.readAsBytes();

              // Subir el archivo a Google Cloud Storage
              var media = storage.Media(
                  Stream.fromIterable([fileBytes]), fileBytes.length);

              var response = await api.objects.insert(
                  storage.Object()..name = 'my-image.png',
                  'imagenesocr_registro',
                  uploadMedia: media);

              print('Response from GCS: ${response.toJson()}');
            },
          ),
        ),
      ),
    );
  }
}
