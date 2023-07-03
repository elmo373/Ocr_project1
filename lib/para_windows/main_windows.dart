import 'package:flutter/material.dart';
import 'package:postgre_flutter/para_windows/roles/main_administrador_windows.dart';

void main() {
  runApp(WindowsApp());
}

class WindowsApp extends StatelessWidget {
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
          color: Colors.indigo[900],
          child: Center(
            child: Text(
              'Contenido de ${_tabTitles[index]}',
              style: TextStyle(color: Colors.indigo[900]),
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
            height: 48,
            color: Colors.lightGreenAccent[700],
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _tabTitles.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    setState(() {
                      _selectedIndex = index;
                    });
                  },
                  child: Container(
                    height: 48,
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: _selectedIndex == index ? Colors.indigo[900]! : Colors.transparent,
                          width: 2,
                        ),
                      ),
                    ),
                    child: Text(
                      _tabTitles[index],
                      style: TextStyle(
                        color: _selectedIndex == index ? Colors.indigo[900] : Colors.indigo[900],
                        fontSize: _selectedIndex == index ? 22 : 21,
                        fontWeight: _selectedIndex == index ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              },
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
