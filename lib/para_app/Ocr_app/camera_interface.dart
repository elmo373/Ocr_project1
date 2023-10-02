import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class CameraInterface extends StatefulWidget {
  @override
  _CameraInterfaceState createState() => _CameraInterfaceState();
}

class _CameraInterfaceState extends State<CameraInterface> {
  late CameraController _cameraController;
  bool _isCameraInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;
    _cameraController = CameraController(firstCamera, ResolutionPreset.max);
    await _cameraController.initialize();
    if (mounted) {
      setState(() {
        _isCameraInitialized = true;
      });
    }
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isCameraInitialized) {
      // Muestra un indicador de carga mientras se inicializa la cámara
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(3, 72, 128, 1),
        title: Text('Interfaz de Cámara'),
      ),
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            child: CameraPreview(_cameraController), // Ocupa toda la pantalla
          ),
          Positioned(
            bottom: 16.0,
            left: 0,
            right: 0,
            child: Center(
              child: ElevatedButton(
                onPressed: () async {
                  if (_cameraController.value.isInitialized) {
                    try {
                      final pictureFile = await _cameraController.takePicture();
                      if (pictureFile != null) {
                        Navigator.pop(context, pictureFile); // Regresa con la imagen como resultado
                      }
                    } catch (e) {
                      print('Error al tomar la foto: $e');
                    }
                  }
                },
                child: Text('Tomar foto'),
                style: ElevatedButton.styleFrom(
                  primary: Color.fromRGBO(3, 72, 128, 1), // Cambia el color del botón aquí
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
