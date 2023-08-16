import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:postgre_flutter/para_web/api_control.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';


class documentos_de_registro extends StatefulWidget {
  @override
  _documentos_de_registroState createState() => _documentos_de_registroState();
}

class _documentos_de_registroState extends State<documentos_de_registro> {
  List<Map<String, dynamic>> hojas = [];
  String consultaBusqueda = '';
  String nombreTabla = 'documento_de_registro';
  final ScrollController controlScroll = ScrollController();
  Map<String, String> titulosColumnas = {
    'Documento': 'Documento',
    'Usuario': 'Usuario',
    'Nombre Empresa': 'Nombre Empresa',
    'Fecha Emisión': 'Fecha Emisión',
    'Director Material Bélico': 'Director Material Bélico',
    'Director General de Logística': 'Director General de Logística',
    'RUC': 'RUC',
    'Representante Legal': 'Representante Legal',
    'Actividad Principal': 'Actividad Principal',
    'Nombre Propietario': 'Nombre Propietario',
    'PDF': 'PDF',
  };

  @override
  void initState() {
    super.initState();
    cargarUsuarios();
  }

  Future<void> abrirEnlace(String url) async {
    print("Intentando abrir: $url");

    var request = await HttpClient().getUrl(Uri.parse(url));
    var response = await request.close();
    var bytes = await consolidateHttpClientResponseBytes(response);

    String dir = (await getApplicationDocumentsDirectory()).path;
    String path = '$dir/temp.pdf';
    File file = File(path);
    await file.writeAsBytes(bytes);

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PDFScreen(path)
        )
    );
  }

  void cargarUsuarios() async {
    hojas = await api_control.obtenerDatosregistro();
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
              'Documentos de registro',
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4),
            Container(
              color: Color.fromRGBO(3, 72, 128, 1),
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
                            dividerColor: Color.fromRGBO(3, 72, 128, 1),
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
                                  (Map<String, dynamic> usuario) {
                                return DataRow(
                                  color: MaterialStateProperty.resolveWith<Color>(
                                        (Set<MaterialState> estados) {
                                      return Colors.grey[350]!;
                                    },
                                  ),
                                  cells: usuario.keys.map(
                                        (String clave) {
                                      if (clave == 'PDF') {
                                        return DataCell(
                                          ElevatedButton(
                                            child: Text('Abrir PDF'),
                                            onPressed: () => abrirEnlace(usuario[clave].toString()),
                                          ),
                                          showEditIcon: false,
                                        );
                                      }
                                      return DataCell(
                                        Text(
                                          usuario[clave].toString(),
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
class PDFScreen extends StatelessWidget {
  final String path;

  PDFScreen(this.path);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Documento de Registro"),
        backgroundColor: Color.fromRGBO(3, 72, 128, 1),
      ),
      body: Container(
        color: Color.fromRGBO(3, 72, 128, 1),
        child: PDFView(
          filePath: path,
        ),
      ),
    );
  }

}
