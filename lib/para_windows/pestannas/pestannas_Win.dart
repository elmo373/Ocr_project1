import 'package:flutter/material.dart';
import 'package:postgre_flutter/para_windows/main_windows.dart';
import 'package:postgre_flutter/para_windows/pestannas/Eleccion_por_rol_Win.dart';

class WindowsPestannas extends StatelessWidget {
  final Map<String, dynamic> datos;

  WindowsPestannas({required this.datos});

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
  int _selectedIndex = 0;

  List<String> _getTabTitles() {
    switch (widget.datos['Rol']) {
      case 'Administrador':
        return [
          'Gestión de usuarios',
          'Gestión de Documentos',
          'Seguimiento',
          'Reportes',
        ];
      case 'Personal':
        return [
          'Lista de usuarios',
          'Lista de Documentos',
        ];
      case 'Técnico':
        return [
          'Lista de usuarios',
          'Lista de Documentos',
          'Reportes',
        ];
      case 'Empresa':
        return [
          'Estado de registro',
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
                      Icons.person,
                      color: Colors.white,
                      size: 32,
                    ),
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
                                            style: TextStyle(color: Color.fromRGBO(53, 122, 178, 1)),
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
                                      builder: (context) => WindowsApp(),
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
                ),
              ],
            ),
          ),
          Expanded(
            child: buildTabContent(_selectedIndex, widget.datos),
          ),
        ],
      ),
    );
  }
}
