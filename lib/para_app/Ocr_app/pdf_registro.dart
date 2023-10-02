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
import 'package:flutter/cupertino.dart';
import 'camera_interface.dart';

class Pdf_registro extends StatefulWidget {
  final String texto;
  final Map<String, dynamic> datos;
  final File file;
  final List<Map<String, String>> resultados;

  Pdf_registro({
    required this.texto,
    required this.datos,
    required this.file,
    required this.resultados,
  });

  @override
  _Pdf_registroState createState() => _Pdf_registroState();
}

class _Pdf_registroState extends State<Pdf_registro> with WidgetsBindingObserver {
  late final Future<void> future;
  List<String> imageTitles = [
    "Segunda hoja del Certificado de registro",
    "Solicitud dirigida al Ministro",
    "Testimonio de constitución",
    "Poder del representante legal",
    "Cedula de identidad",
    "Certificado de antecedentes (FELCC, FELCV)",
    "Certificado de antecedentes emitido por la interpol",
    "Certificado de antecedentes REJAP",
    "Licencia de funcionamiento",
    "Número de identificación tributaria (NIT)",
    "Fundempresa",
    "Croquis del polvorín",
    "Boleta de depósito",
    "Póliza de responsabilidad civil"
  ];

  List<File?> selectedImages = List.generate(14, (_) => null);
  bool allImagesUploaded = false;

  @override
  void initState() {
    super.initState();
    print(widget.datos);
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color.fromRGBO(3, 72, 128, 1),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Crear PDF'),
          backgroundColor: Color.fromRGBO(3, 72, 128, 1),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: 14,
                  itemBuilder: (context, index) {
                    final hasImage = selectedImages[index] != null; // Verifica si hay una imagen seleccionada en esta posición
                    return Card(
                      color: Colors.white,
                      child: Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            ImageTitleWithButtons(
                              title: "${index + 1}. ${imageTitles[index]}",
                              onSelectImage: () {
                                _selectImage(index);
                              },
                              onTakePhoto: () {
                                _takePhoto(index);
                              },
                              hasImage: hasImage, // Pasa el valor de hasImage
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Color.fromRGBO(3, 72, 128, 1),
                  ),
                  child: Text(
                    'Crear PDF',
                    style: TextStyle(fontSize: 18),
                  ),
                  onPressed: allImagesUploaded
                      ? () async {
                    await _createPDF();
                  }
                      : null, // Deshabilitar el botón si no se han subido todas las imágenes
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _takePhoto(int index) async {
    final pickedFile = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CameraInterface(),
      ),
    );

    if (pickedFile != null) {
      setState(() {
        selectedImages[index] = File(pickedFile.path);
        _checkAllImagesUploaded();
      });
    }
  }

  void _checkAllImagesUploaded() {
    // Verificar si todas las imágenes están cargadas
    bool allUploaded = true;
    for (int i = 0; i < 14; i++) {
      if (selectedImages[i] == null) {
        allUploaded = false;
        break;
      }
    }
    setState(() {
      allImagesUploaded = allUploaded;
    });
  }

  Future<void> _createPDF() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();

    final pdf = pdfWidgets.Document();
    final Uint8List fileImage = await widget.file.readAsBytes();
    final pdfImgFile = pdfWidgets.MemoryImage(fileImage);

    pdf.addPage(pdfWidgets.Page(
      build: (pdfWidgets.Context context) => pdfWidgets.Image(pdfImgFile),
    ));

    final ImagePicker seleccionador = ImagePicker();
    for (int i = 0; i < 14; i++) {
      final File? pickedFile = selectedImages[i];
      if (pickedFile != null) {
        final Uint8List? imagenComprimida = await FlutterImageCompress.compressWithFile(
          pickedFile.absolute.path,
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
            await subirAFirebaseStorage(pdfFile, widget.datos, widget.resultados);
            Navigator.pop(context);
          },
          allImagesUploaded: allImagesUploaded, // Pasa el valor aquí
        ),
      ),
    );
  }

  Future<void> subirAFirebaseStorage(File archivo, Map<String, dynamic> datos,
      List<Map<String, String>> resultados) async {
    FirebaseStorage almacenamiento = FirebaseStorage.instance;
    final ahora = DateTime.now();
    final formateador = DateFormat('yyyy-MM-dd HH:mm:ss');
    final fechaHoraFormateada = formateador.format(ahora);

    TaskSnapshot captura = await almacenamiento.ref('$fechaHoraFormateada.pdf').putFile(archivo);
    final String urlDescarga = await captura.ref.getDownloadURL();

    print("Aqui");
    print(resultados[0]['Número Certificado']);

    Map<String, dynamic> subir = {
      'id_doc': resultados[0]['Número Certificado'],
      'id_usuario': datos['C.I.'],
      'nombre_empresa': resultados[0]['Nombre Empresa'],
      'fecha_de_emision': resultados[0]['Fecha de Emisión'],
      'id_director_material_belico': resultados[0]['Director Material Bélico'],
      'id_director_general_de_logistica': resultados[0]['Director General Logística'],
      'ruc': resultados[0]['RUC'],
      'representante_legal': resultados[0]['Representante Legal'],
      'actividad_principal': resultados[0]['Actividad Principal'],
      'nombre_propietario': resultados[0]['Nombre Propietario'],
      'pdf': urlDescarga,
    };

    api_control.agregarRegistro(subir);
  }

  Future<void> _selectImage(int index) async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        selectedImages[index] = File(pickedFile.path);
        _checkAllImagesUploaded();
      });
    }
  }
}

class PdfViewerScreen extends StatelessWidget {
  final String path;
  final Function subirAFirebaseStorage;
  final bool allImagesUploaded; // Agrega la variable aquí

  PdfViewerScreen({
    required this.path,
    required this.subirAFirebaseStorage,
    required this.allImagesUploaded, // Agrega la variable al constructor
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vista Previa PDF'),
        backgroundColor: Color.fromRGBO(3, 72, 128, 1),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.cloud_upload),
            onPressed: allImagesUploaded
                ? () async {
              await subirAFirebaseStorage();
            }
                : null, // Deshabilitar el botón si no se han subido todas las imágenes
          ),
        ],
      ),
      body: PDFView(
        filePath: path,
      ),
    );
  }
}


class ImageTitleWithButtons extends StatelessWidget {
  final String title;
  final Function() onSelectImage;
  final Function() onTakePhoto;
  final bool hasImage; // Variable que indica si hay una imagen seleccionada

  ImageTitleWithButtons({
    required this.title,
    required this.onSelectImage,
    required this.onTakePhoto,
    required this.hasImage, // Recibe el valor de hasImage como parámetro
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20),
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                color: Color.fromRGBO(3, 72, 128, 1),
              ),
            ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton(
              onPressed: onSelectImage,
              child: Text('Seleccionar imagen'),
              style: ElevatedButton.styleFrom(
                primary: Color.fromRGBO(3, 72, 128, 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: onTakePhoto,
              child: Text('Tomar foto'),
              style: ElevatedButton.styleFrom(
                primary: Color.fromRGBO(3, 72, 128, 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ),
              ),
            ),
            Icon(
              hasImage ? Icons.check : Icons.check_box_outline_blank, // Usa el icono condicionalmente
              color: hasImage ? Color.fromRGBO(3, 72, 128, 1) : null, // Cambia el color del icono si hay imagen
            ),
          ],
        ),
      ],
    );
  }
}
