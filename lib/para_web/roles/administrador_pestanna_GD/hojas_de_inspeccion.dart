import 'package:flutter/material.dart';
import 'package:postgre_flutter/para_web/api_control.dart';
import 'package:url_launcher/url_launcher.dart';

class hojas_de_inspeccion extends StatefulWidget {
  @override
  _hojas_de_inspeccionState createState() => _hojas_de_inspeccionState();
}

class _hojas_de_inspeccionState extends State<hojas_de_inspeccion> {
  List<Map<String, dynamic>> hojas = [];
  String consultaBusqueda = '';
  String nombreTabla = 'documento_de_registro';
  final ScrollController controlScroll = ScrollController();

  Map<String, String> titulosColumnas = {
    'Documento': 'Documento',
    'Registro': 'Registro',
    'Usuario': 'Usuario',
    'Nombre Empresa': 'Nombre Empresa',
    'Nombre Propietario': 'Nombre Propietario',
    'Representante Legal': 'Representante Legal',
    'Cumple': 'Cumple',
    'Ubicación Depósito': 'Ubicación Depósito',
    'Fecha Emisión': 'Fecha Emisión',
    'PDF': 'PDF',
  };

  @override
  void initState() {
    super.initState();
    cargarUsuarios();
  }

  void abrirEnlace(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'No se pudo abrir $url';
    }
  }

  void cargarUsuarios() async {
    hojas = await api_control.obtenerDatosinspeccion();
    setState(() {});
  }

  List<Map<String, dynamic>> obtenerUsuariosFiltrados() {
    if (consultaBusqueda.isEmpty) {
      return hojas;
    } else {
      return hojas.where((hoja) {
        return hoja.values.any((value) => value.toString().toLowerCase().contains(consultaBusqueda.toLowerCase()));
      }).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    final usuariosFiltrados = obtenerUsuariosFiltrados();

    return Scaffold(
      body: Container(
        color: Color.fromRGBO(3, 72, 128, 1),
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Text(
              'Hojas de inspección',
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4),
            Container(
              width: MediaQuery.of(context).size.width * 0.4,
              color: Color.fromRGBO(3, 72, 128, 1),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.search),
                    color: Colors.white,
                    onPressed: () {},
                  ),
                  Text(
                    'Buscar:',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      onChanged: (value) => setState(() => consultaBusqueda = value),
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Scrollbar(
                isAlwaysShown: true,
                controller: controlScroll,
                child: SingleChildScrollView(
                  controller: controlScroll,
                  scrollDirection: Axis.horizontal,
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Directionality(
                        textDirection: TextDirection.ltr,
                        child: Theme(
                          data: ThemeData(
                            dividerColor: Colors.white,
                          ),
                          child: usuariosFiltrados.isNotEmpty
                              ? DataTable(
                            columns: titulosColumnas.keys.map(
                                  (String key) => DataColumn(
                                label: Text(
                                  titulosColumnas[key]!,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ).toList(),
                            rows: usuariosFiltrados.map(
                                  (Map<String, dynamic> documento) {
                                return DataRow(
                                  color: MaterialStateProperty.resolveWith<Color>(
                                        (Set<MaterialState> estados) {
                                      return Colors.grey[350]!;
                                    },
                                  ),
                                  cells: documento.keys.map(
                                        (String key) {
                                      if (key == 'PDF') {
                                        return DataCell(
                                          ElevatedButton(
                                            child: Text('Abrir PDF'),
                                            onPressed: () => abrirEnlace(documento[key].toString()),
                                          ),
                                          showEditIcon: false,
                                        );
                                      }
                                      return DataCell(
                                        Text(
                                          documento[key].toString(),
                                          style: TextStyle(color: Colors.black),
                                        ),
                                        showEditIcon: false,
                                      );
                                    },
                                  ).toList(),
                                );
                              },
                            ).toList(),
                            dividerThickness: 1.0,
                            horizontalMargin: 10.0,
                            columnSpacing: 10.0,
                            dataRowHeight: 45.0,
                            headingRowColor: MaterialStateProperty.resolveWith<Color>(
                                  (Set<MaterialState> states) {
                                return Color.fromRGBO(53, 122, 178, 1);
                              },
                            ),
                          )
                              : Container(),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
