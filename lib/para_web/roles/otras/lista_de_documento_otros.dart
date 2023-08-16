import 'package:flutter/material.dart';
import 'package:postgre_flutter/para_web/roles/administrador_pestanna_GD/documentos_de_registro.dart';
import 'package:postgre_flutter/para_web/roles/administrador_pestanna_GD/hojas_de_inspeccion.dart';

class lista_de_documentos_otros extends StatelessWidget {
  lista_de_documentos_otros();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DocumentosHomePage(),
    );
  }
}

class DocumentosHomePage extends StatefulWidget {
  DocumentosHomePage();

  @override
  _DocumentosHomePageState createState() => _DocumentosHomePageState();
}

class _DocumentosHomePageState extends State<DocumentosHomePage> {
  int _selectedIndex = 0;

  List<String> _getTabTitles = [
    'Documentos de registro',
    'Hojas de inspección',
  ];

  @override
  Widget build(BuildContext context) {
    final tabTitles = _getTabTitles;
    return Scaffold(
      body: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: 60,
            color: Colors.white60,
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
                    color: _selectedIndex == index
                        ? Color.fromRGBO(53, 122, 178, 1)
                        : Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    alignment: Alignment.center,
                    child: Text(
                      tabTitles[index],
                      style: TextStyle(

                        color: _selectedIndex == index
                            ? Colors.white
                            : Color.fromRGBO(53, 122, 178, 1),
                        fontSize: _selectedIndex == index ? 16 : 15,
                        fontWeight: _selectedIndex == index
                            ? FontWeight.bold
                            : FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: _selectContentByIndex(_selectedIndex),
          ),
        ],
      ),
    );
  }
  Widget _selectContentByIndex(int index) {
    switch (index) {
      case 0:
        return documentos_de_registro();
      case 1:
        return hojas_de_inspeccion();
      default:
        return Container(
          color: Color.fromRGBO(3, 72, 128, 1),
          child: Center(
            child: Text(
              'Contenido de error',
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
    }
  }
}
