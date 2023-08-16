import 'package:flutter/material.dart';
import 'package:postgre_flutter/para_app/Ocr_app/ocr_app.dart';
import 'package:postgre_flutter/para_app/Ocr_app/ocr_app2.dart';
import 'package:postgre_flutter/para_app/pantallas/documentos_de_registro.dart';
import 'package:postgre_flutter/para_app/pantallas/hojas_de_inspeccion.dart';

import '../main_app.dart';

class tipo_de_documento extends StatelessWidget {
  final Map<String, dynamic> datos;

  tipo_de_documento({required this.datos});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WindowsHomePage(datos: datos),
    );
  }
}

class WindowsHomePage extends StatefulWidget {
  final Map<String, dynamic> datos;

  WindowsHomePage({required this.datos});

  @override
  _WindowsHomePageState createState() => _WindowsHomePageState();
}

class _WindowsHomePageState extends State<WindowsHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 100, // Puedes ajustar a tu necesidad
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Image.asset(
                      'lib/imagenes/minlogo.png',
                      height: 90,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ),
                Row(
                  children: [
                    PopupMenuButton<String>(
                      offset: Offset(110, 130),  // Esto desplazará el menú hacia abajo
                      icon: Icon(Icons.read_more, color: Color.fromRGBO(3, 72, 128, 1)),  // Cambia el ícono a tu color deseado
                      onSelected: (value) {
                        switch (value) {
                          case 'Digitalizar Registro':
                            setState(() {
                              _contentToDisplay = 'registro';
                            });
                            break;
                          case 'Digitalizar Hoja de inspección':
                            setState(() {
                              _contentToDisplay = 'inspeccion';
                            });
                            break;
                          case 'Ver documentos de registro':
                            setState(() {
                              _contentToDisplay = 'ver registro';
                            });
                            break;
                          case 'Ver hojas de inspección':
                            setState(() {
                              _contentToDisplay = 'ver inspeccion';
                            });
                            break;
                          default:
                            setState(() {
                              _contentToDisplay = 'registro';
                            });
                            break;
                        }
                      },
                      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                        PopupMenuItem<String>(
                          value: 'Digitalizar Registro',
                          child: Text('Digitalizar Registro', style: TextStyle(fontWeight: FontWeight.bold, color: Color.fromRGBO(3, 72, 128, 1))),
                        ),
                        PopupMenuItem<String>(
                          value: 'Digitalizar Hoja de inspección',
                          child: Text('Digitalizar Hoja de inspección', style: TextStyle(fontWeight: FontWeight.bold, color: Color.fromRGBO(3, 72, 128, 1))),
                        ),
                        PopupMenuItem<String>(
                          value: 'Ver documentos de registro',
                          child: Text('Ver documentos de registro', style: TextStyle(fontWeight: FontWeight.bold, color: Color.fromRGBO(3, 72, 128, 1))),
                        ),
                        PopupMenuItem<String>(
                          value: 'Ver hojas de inspección',
                          child: Text('Ver hojas de inspección', style: TextStyle(fontWeight: FontWeight.bold, color: Color.fromRGBO(3, 72, 128, 1))),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: Icon(Icons.person, color: Color.fromRGBO(3, 72, 128, 1), size: 32),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Datos del Usuario'),
                              content: SingleChildScrollView(
                                child: ListBody(
                                  children: widget.datos.entries.map((entry) {
                                    return Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text.rich(
                                        TextSpan(
                                          text: '${entry.key}:\n',
                                          style: TextStyle(fontWeight: FontWeight.bold, color: Color.fromRGBO(3, 72, 128, 1)),
                                          children: <TextSpan>[
                                            TextSpan(
                                              text: '${entry.value}',
                                              style: TextStyle(color: Color.fromRGBO(3, 72, 128, 1)),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text('Atrás', style: TextStyle(color: Colors.white)),
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(Color.fromRGBO(3, 72, 128, 1)),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => MobileApp(),
                                      ),
                                    );
                                  },
                                  child: Text('Cerrar sesión', style: TextStyle(color: Colors.white)),
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(Color.fromRGBO(3, 72, 128, 1)),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: _getContentToDisplay(),
          ),
        ],
      ),
    );
  }

  String _contentToDisplay = '';

  Widget _getContentToDisplay() {
    switch (_contentToDisplay) {
      case 'registro':
        return TextScanner(datos: widget.datos);
      case 'inspeccion':
        return TextScanner2(datos: widget.datos);
      case 'ver registro':
        return documentos_de_registro();
      case 'ver inspeccion':
        return hojas_de_inspeccion();
      default:
        return TextScanner(datos: widget.datos);
    }
  }


}
