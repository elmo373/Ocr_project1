import 'package:flutter/material.dart';
import 'package:postgre_flutter/para_web/main_web.dart';
import 'package:postgre_flutter/para_web/pestannas/Eleccion_por_rol_Web.dart';
void main(){
  runApp(WindowsPestannas(rol: 'Administrador'));
}
class WindowsPestannas extends StatelessWidget {
  final String rol;

  WindowsPestannas({required this.rol});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: WindowsHomePage(rol: rol),
    );
  }
}

class WindowsHomePage extends StatefulWidget {
  final String rol;

  WindowsHomePage({required this.rol});

  @override
  _WindowsHomePageState createState() => _WindowsHomePageState();
}

class _WindowsHomePageState extends State<WindowsHomePage> {
  int _selectedIndex = 0;

  List<String> _getTabTitles() {
    switch (widget.rol) {
      case 'Administrador':
        return [
          'Gestión de usuarios',
          'Reportes sobre usuarios',
          'Gestion de Documentos',
          'OCR',
          'Solicitudes de registro',
          'Rol de guardia',
        ];
      case 'Personal':
        return [
          'Lista de usuarios',
          'Lista de Documentos',
          'Rol de guardia',
          'OCR',
        ];
      case 'Técnico':
        return [
          'Lista de usuarios',
          'Lista de Documentos',
          'Rol de guardia',
          'OCR',
        ];
      case 'En Trámite para el Registro':
        return [
          'Solicitud de registro',
          'Fecha de transporte',
        ];
      default:
        return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final tabTitles = _getTabTitles();
    return Scaffold(
      body: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: 90,
            color: Colors.white,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Image.asset(
                    'lib/imagenes/minlogo.png',
                    width: 300,
                    height: 90,
                  ),
                ),
                Expanded(
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: tabTitles.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            setState(() {
                              _selectedIndex = index;
                            });
                          },
                          child: Container(
                            color: _selectedIndex == index ? Color.fromRGBO(3, 72, 128, 1) : Colors.white,
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            alignment: Alignment.center,
                            child: Text(
                              tabTitles[index],
                              style: TextStyle(
                                color: _selectedIndex == index ? Colors.white : Color.fromRGBO(3, 72, 128, 1),
                                fontSize: _selectedIndex == index ? 22 : 21,
                                fontWeight: _selectedIndex == index ? FontWeight.bold : FontWeight.normal,
                              ),
                            ),
                          ),
                        );
                      },
                    )

                ),
                Container(
                  color: Color.fromRGBO(3, 72, 128, 1),
                  width: 90,
                  height: 90,
                  child: IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 32,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => WebApp()),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: buildTabContent(_selectedIndex, widget.rol),
          ),
        ],
      ),
    );
  }
}
