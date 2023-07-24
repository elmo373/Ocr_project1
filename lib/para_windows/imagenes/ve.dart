import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class Ver extends StatefulWidget {
  final String id;

  const Ver({Key? key, required this.id}) : super(key: key);

  @override
  _VerState createState() => _VerState();
}

class _VerState extends State<Ver> {
  late Future<String> imageUrlFuture;

  @override
  void initState() {
    super.initState();
    imageUrlFuture = downloadUrl(widget.id);
  }

  Future<String> downloadUrl(String id) async {
    final storage = FirebaseStorage.instance;
    final String downloadURL = await storage.ref().child(id).getDownloadURL();
    return downloadURL;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: imageUrlFuture,
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (snapshot.hasData) {
          return Image.network(snapshot.data!);
        } else if (snapshot.hasError) {
          return const Text('Error al cargar la imagen');
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}
