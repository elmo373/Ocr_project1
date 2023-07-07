import 'package:flutter/material.dart';
import 'package:postgre_flutter/para_windows/roles/main_administrador_windows.dart';

void main() {
  runApp(WindowsPestannas());
}

class WindowsPestannas extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: WindowsHomePage(),
    );
  }
}

class WindowsHomePage extends StatefulWidget {
  @override
  _WindowsHomePageState createState() => _WindowsHomePageState();
}

class _WindowsHomePageState extends State<WindowsHomePage> {
  int _selectedIndex = 0;

  static const List<String> _tabTitles = [
    'Gestión de usuarios',
    'Pestaña 1',
    'Pestaña 2',
    'Pestaña 3',
    'Pestaña 4',
  ];

  Widget _buildTabContent(int index) {
    switch (index) {
      case 0:
        return WindowsAdministradorMain();
      default:
        return Container(
          color: Color.fromRGBO(3, 72, 128, 1),
          child: Center(
            child: Text(
              'Contenido de ${_tabTitles[index]}',
              style: TextStyle(color: Color.fromRGBO(3, 72, 128, 1)),
            ),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width, // Establece el ancho máximo disponible
            height: 90,
            color: Colors.white,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Image.asset(
                    'lib/imagenes/minlogo.png', // Ruta de la imagen
                    width: 300,
                    height: 90,
                  ),
                ),
                SingleChildScrollView( // Utiliza SingleChildScrollView para el desplazamiento horizontal
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _tabTitles.map((title) {
                      final index = _tabTitles.indexOf(title);
                      return InkWell(
                        onTap: () {
                          setState(() {
                            _selectedIndex = index;
                          });
                        },
                        child: Container(
                          color: _selectedIndex == index ? Color.fromRGBO(3, 72, 128, 1) : Colors.white,
                          height: 91,
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          alignment: Alignment.center,
                          child: Text(
                            title,
                            style: TextStyle(
                              color: _selectedIndex == index ? Colors.white : Color.fromRGBO(3, 72, 128, 1),
                              fontSize: _selectedIndex == index ? 22 : 21,
                              fontWeight: _selectedIndex == index ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _buildTabContent(_selectedIndex),
          ),
        ],
      ),
    );
  }
}
