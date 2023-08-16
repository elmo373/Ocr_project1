import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pdfWidgets;
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:postgre_flutter/para_app/api_controlMobile.dart';

class Pdf_inspeccion extends StatelessWidget {
  final String texto;
  final Map<String, dynamic> datos;
  final File file;
  final List<Map<String, String>> resultados;

  Pdf_inspeccion({required this.texto, required this.datos, required this.file, required this.resultados});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crear PDF'),
        backgroundColor: Color.fromRGBO(3, 72, 128, 1),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Color.fromRGBO(3, 72, 128, 1), // background color
          ),
          child: Text(
            'Seleccionar Imágenes y Crear PDF',
            style: TextStyle(fontSize: 18),
          ),
          onPressed: () async {
            await _crearPDF(context);
          },
        ),
      ),
    );
  }

  Future<void> _crearPDF(BuildContext context) async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();

    final pdf = pdfWidgets.Document();
    final Uint8List fileImage = await file.readAsBytes();
    final pdfImgFile = pdfWidgets.MemoryImage(fileImage);

    pdf.addPage(pdfWidgets.Page(
      build: (pdfWidgets.Context context) => pdfWidgets.Image(pdfImgFile),
    ));

    final ImagePicker seleccionador = ImagePicker();
    for (int i = 0; i < 2; i++) {
      final pickedFile = await seleccionador.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        final File archivo = File(pickedFile.path);
        final Uint8List? imagenComprimida = await FlutterImageCompress.compressWithFile(
          archivo.absolute.path,
          minWidth: 1080,
          minHeight: 1920,
          quality: 80,
        );

        if (imagenComprimida != null) {
          final pdfImg = pdfWidgets.MemoryImage(imagenComprimida);
          pdf.addPage(
            pdfWidgets.Page(
              build: (pdfWidgets.Context context) => pdfWidgets.Image(pdfImg),
            ),
          );
        }
      }
    }

    final output = await getTemporaryDirectory();
    final pdfFile = File('${output.path}/ejemplo.pdf');
    await pdfFile.writeAsBytes(await pdf.save());

    // Mostrar el archivo PDF
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PdfViewerScreen(
          path: pdfFile.path,
          subirAFirebaseStorage: () async {
            await subirAFirebaseStorage(pdfFile, datos, resultados);
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  Future<void> subirAFirebaseStorage(File archivo, Map<String, dynamic> datos, List<Map<String, String>> resultados) async {
    FirebaseStorage almacenamiento = FirebaseStorage.instance;
    final ahora = DateTime.now();
    final formateador = DateFormat('yyyy-MM-dd HH:mm:ss');
    final fechaHoraFormateada = formateador.format(ahora);

    TaskSnapshot captura = await almacenamiento.ref('"$fechaHoraFormateada"ins.pdf').putFile(archivo);
    final String urlDescarga = await captura.ref.getDownloadURL();

    Map<String, dynamic> subir = {
      'id_doc': (resultados[0]['Número de Registro'] ?? '') + (datos['C.I.'] ?? '') + (resultados[0]['Fecha de Emisión'] ?? ''),
      'id_registro': resultados[0]['Número de Registro'],
      'id_usuario': datos['C.I.'],
      'nombre_empresa': resultados[0]['Nombre Empresa'],
      'fecha_de_emision': resultados[0]['Fecha de Emisión'],
      'representante_legal': resultados[0]['Representante Legal'],
      'nombre_propietario': resultados[0]['Nombre Propietario'],
      'cumple': resultados[0]['Cumple'],
      'ubicacion_deposito': resultados[0]['Ubicación Depósito'],
      'pdf': urlDescarga,
    };

    api_control.agregarInspeccion(subir);
  }
}

class PdfViewerScreen extends StatelessWidget {
  final String path;
  final Function subirAFirebaseStorage;

  PdfViewerScreen({required this.path, required this.subirAFirebaseStorage});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vista Previa PDF'),
        backgroundColor: Color.fromRGBO(3, 72, 128, 1),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.cloud_upload),
            onPressed: () async {
              await subirAFirebaseStorage();
            },
          ),
        ],
      ),
      body: PDFView(
        filePath: path,
      ),
    );
  }
}