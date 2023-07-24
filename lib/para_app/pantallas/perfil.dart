import 'package:flutter/material.dart';
import 'package:postgre_flutter/para_app/main_app.dart';

class Perfil extends StatelessWidget {
  final Map<String, dynamic> datos;

  Perfil({required this.datos});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
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
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('Perfil'),
      ),
      body: Center(child: Text('Página de Perfil')),
    );
  }
}
