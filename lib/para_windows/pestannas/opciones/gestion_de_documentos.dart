import 'package:flutter/material.dart';
import 'package:postgre_flutter/para_windows/pestannas/opciones/gestion_de_documentos_eleccion.dart';

class gestion_de_documentos extends StatelessWidget {
  gestion_de_documentos();

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
    'Estado de documentos de registro',
    'Hojas de inspección',
    'Estado de hojas de inspección',
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
            child: gestion_de_documentos_eleccion(_selectedIndex),
          ),
        ],
      ),
    );
  }
}
