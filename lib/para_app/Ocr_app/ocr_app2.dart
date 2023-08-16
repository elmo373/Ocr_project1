import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker/image_picker.dart';
import 'package:postgre_flutter/para_app/Ocr_app/estado_del_ocr2.dart';

import 'estado_del_ocr.dart';

class TextScanner2 extends StatefulWidget {
  final Map<String, dynamic> datos;

  const TextScanner2({Key? key, required this.datos}) : super(key: key);

  @override
  State<TextScanner2> createState() => _TextScanner2State();
}


class _TextScanner2State extends State<TextScanner2> with WidgetsBindingObserver {
  bool isPermissionGranted = false;
  late final Future<void> future;
  final ImagePicker picker = ImagePicker();

  //For controlling camera
  CameraController? cameraController;
  final textDetector = GoogleMlKit.vision.textRecognizer();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    future = requestCameraPermission();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    stopCamera();
    textDetector.close();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (cameraController == null || !cameraController!.value.isInitialized) {
      return;
    }
    if (state == AppLifecycleState.inactive) {
      stopCamera();
    } else if (state == AppLifecycleState.resumed &&
        cameraController != null &&
        cameraController!.value.isInitialized) {
      startCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Digitalizar Hoja de inspección'),
          backgroundColor: Color.fromRGBO(3, 72, 128, 1),
        ),
        body: Directionality(
          textDirection: TextDirection.ltr,
          child: FutureBuilder(
            future: future,
            builder: (context, snapshot) {
              return Stack(
                children: [
                  if (isPermissionGranted)
                    FutureBuilder<List<CameraDescription>>(
                      future: availableCameras(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          initCameraController(snapshot.data!);
                          return Center(
                            child: CameraPreview(cameraController!),
                          );
                        } else {
                          return LinearProgressIndicator(
                            backgroundColor: Color.fromRGBO(3, 72, 128, 1),
                          );
                        }
                      },
                    ),
                  Scaffold(
                    backgroundColor: isPermissionGranted ? Colors.transparent : null,
                    body: isPermissionGranted
                        ? Column(
                      children: [
                        Expanded(child: Container()),
                        Container(
                          padding: EdgeInsets.only(bottom: 30),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              ElevatedButton(
                                onPressed: (){
                                  scanImage();
                                },
                                child: Text('Tomar foto'),
                                style: ElevatedButton.styleFrom(
                                  primary: Color.fromRGBO(3, 72, 128, 1),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: (){
                                  pickImage();
                                },
                                child: Text('Seleccionar imagen'),
                                style: ElevatedButton.styleFrom(
                                  primary: Color.fromRGBO(3, 72, 128, 1),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                        : Center(
                      child: Container(
                        padding: const EdgeInsets.only(left: 24.0, right: 24.0),
                        child: const Text(
                          'Camera Permission Denied',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color.fromRGBO(3, 72, 128, 1),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Future<void> requestCameraPermission() async {
    final status = await Permission.camera.request();
    isPermissionGranted = status == PermissionStatus.granted;
  }

  void initCameraController(List<CameraDescription> cameras) {
    if (cameraController != null) {
      return;
    }
    CameraDescription? camera;
    for (var a = 0; a < cameras.length; a++) {
      final CameraDescription current = cameras[a];
      if (current.lensDirection == CameraLensDirection.back) {
        camera = current;
        break;
      }
    }
    if (camera != null) {
      cameraSelected(camera);
    }
  }

  Future<void> cameraSelected(CameraDescription camera) async {
    cameraController =
        CameraController(camera, ResolutionPreset.max, enableAudio: false);
    await cameraController?.initialize();
    if (!mounted) {
      return;
    }
    setState(() {});
  }

  void startCamera() {
    if (cameraController != null) {
      cameraSelected(cameraController!.description);
    }
  }

  void stopCamera() {
    if (cameraController != null) {
      cameraController?.dispose();
    }
  }

  Future<void> scanImage() async {
    if (cameraController == null) {
      return;
    }
    final navigator = Navigator.of(context);
    try {
      final pictureFile = await cameraController!.takePicture();
      processImage(File(pictureFile.path));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('An error occurred when scanning text'),
        ),
      );
    }
  }

  Future<void> pickImage() async {
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      processImage(File(pickedFile.path));
    }
  }

  Future<void> processImage(File file) async {
    final navigator = Navigator.of(context);
    final inputImage = InputImage.fromFile(file);
    final recognizedText = await textDetector.processImage(inputImage);
    await navigator.push(
      MaterialPageRoute(
        builder: (context) => PantallaResultado2(texto: recognizedText.text, datos: widget.datos, archivo: file),
      ),
    );
  }

}
