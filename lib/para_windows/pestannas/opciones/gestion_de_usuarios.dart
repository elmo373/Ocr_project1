import 'package:flutter/material.dart';
import 'package:postgre_flutter/para_windows/main_windows.dart';
import 'package:postgre_flutter/para_windows/pestannas/Eleccion_por_rol_Win.dart';
import 'package:postgre_flutter/para_windows/pestannas/opciones/gestion_de_usuario_eleccion.dart';

class gestion_de_usuario extends StatelessWidget {

  gestion_de_usuario();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: WindowsHomePage(),
    );
  }
}

class WindowsHomePage extends StatefulWidget {

  WindowsHomePage();

  @override
  _WindowsHomePageState createState() => _WindowsHomePageState();
}

class _WindowsHomePageState extends State<WindowsHomePage> {
  int _selectedIndex = 0;

  List<String> _getTabTitles =
    [
      'Lista de usuarios',
      'Edición de usuarios',
      'Creación de usuarios',
      'Estado de usuarios',
    ];

  @override
  Widget build(BuildContext context) {
    final tabTitles = _getTabTitles;
    return Scaffold(
      body: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: 90,
            color: Colors.white,
            child: Row(
              children: [
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
              ],
            ),
          ),
          Expanded(
            child: gestion_de_usaurio_eleccion(_selectedIndex),
          ),
        ],
      ),
    );
  }
}
