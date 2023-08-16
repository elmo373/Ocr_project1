import 'package:flutter/material.dart';
import 'package:postgre_flutter/para_windows/pestannas/opciones/reportes_eleccion.dart';

class gestion_de_reportes extends StatelessWidget {
  gestion_de_reportes();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ReportesHomePage(),
    );
  }
}

class ReportesHomePage extends StatefulWidget {
  ReportesHomePage();

  @override
  _ReportesHomePageState createState() => _ReportesHomePageState();
}

class _ReportesHomePageState extends State<ReportesHomePage> {
  int _selectedIndex = 0;

  final List<String> _tabTitles = [
    'Reporte de Usuarios',
    'Reporte de Empresas',
    'Grafica de Empresas',
    'Depósitos por departamentos',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: 60,
            color: Colors.white60,
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
                    color: _selectedIndex == index ? Color.fromRGBO(53, 122, 178, 1) : Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    alignment: Alignment.center,
                    child: Text(
                      _tabTitles[index],
                      style: TextStyle(
                        color: _selectedIndex == index ? Colors.white : Color.fromRGBO(53, 122, 178, 1),
                        fontSize: _selectedIndex == index ? 16 : 15,
                        fontWeight: _selectedIndex == index ? FontWeight.bold : FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: gestion_de_reportes_eleccion(_selectedIndex),
          ),
        ],
      ),
    );
  }
}
