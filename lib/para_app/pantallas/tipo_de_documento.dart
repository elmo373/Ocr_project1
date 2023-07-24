import 'package:flutter/material.dart';
import 'package:postgre_flutter/para_app/Ocr_app/ocr_app.dart';
import 'package:postgre_flutter/para_app/pantallas/perfil.dart';

import '../main_app.dart';

class tipo_de_documento extends StatelessWidget {
  final Map<String, dynamic> datos;


  // Constructor
  tipo_de_documento({required this.datos});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WindowsHomePage(datos: datos),
    );
  }
}

class WindowsHomePage extends StatelessWidget {
  final Map<String, dynamic> datos;

  // Constructor
  WindowsHomePage({required this.datos});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        toolbarHeight: 72,
        title: SizedBox(
          width: 240,
          height: 72,
          child: Image.asset(
            'lib/imagenes/minlogo.png',
            fit: BoxFit.contain,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.person,
              color: Color.fromRGBO(3, 72, 128, 1),
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Datos del Usuario'),
                    content: SingleChildScrollView(
                      child: ListBody(
                        children: datos.entries.map((entry) {
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
      body: Container(
        color: Color.fromRGBO(3, 72, 128, 1),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Elige una opción',
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Implementar funcionalidad del botón de 'Certificado de Registro' aquí
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TextScanner(),
                    ),
                  );
                },
                child: Text(
                  'Certificado de Registro',
                  style: TextStyle(
                    color: Color.fromRGBO(3, 72, 128, 1),
                    fontSize: 20,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MaterialApp(home: TextScanner()),
                    ),
                  );
                },
                child: Text(
                  'Hoja de Inspección',
                  style: TextStyle(
                    color: Color.fromRGBO(3, 72, 128, 1),
                    fontSize: 20,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
