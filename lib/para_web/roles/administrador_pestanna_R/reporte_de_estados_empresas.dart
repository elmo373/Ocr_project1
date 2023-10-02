import 'package:flutter/material.dart';
import 'package:postgre_flutter/Encriptacion.dart';
import 'package:postgre_flutter/para_web/api_control.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:postgre_flutter/Base de datos/actualizacion_general.dart';

final String Link = api_control.BASE_URL;  // Asegúrate de que este enlace esté correcto
final String actualizarEstadoDeEmpresa = '$Link/query/EstadoDeEmpresas';

class reporte_estado_empresa extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: EstadoEmpresaPage(),
    );
  }
}

class EstadoEmpresaPage extends StatefulWidget {
  @override
  _EstadoEmpresaPageState createState() => _EstadoEmpresaPageState();
}

class _EstadoEmpresaPageState extends State<EstadoEmpresaPage> {
  List<Map<String, dynamic>> _data = [];
  String consultaBusqueda = '';

  final Map<String, String> titulosColumnas = {
    'id_empresa': 'ID Empresa',
    'estado_de_la_empresa': 'Estado de la Empresa',
    'nombre': 'Nombre',
    'razon': 'Razón',
  };

  @override
  void initState() {
    super.initState();
    actualizarEstadoDeEmpresas();
  }

  void actualizarEstadoDeEmpresas() async {
    await actualizacion_general.cambios();
    try {
      final response = await http.get(Uri.parse(actualizarEstadoDeEmpresa));

      if (response.statusCode == 200) {
        List<dynamic> rawList = json.decode(response.body);

        for (var rawItem in rawList) {
          _data.add({
            'id_empresa': AESCrypt.desencriptar(rawItem['id_empresa'].toString()),
            'estado_de_la_empresa': AESCrypt.desencriptar(rawItem['estado_de_la_empresa'].toString()),
            'nombre': AESCrypt.desencriptar(rawItem['nombre'].toString()),
            'razon': AESCrypt.desencriptar(rawItem['razon'].toString()),
          });
        }
      } else {
        print('Error en la solicitud: ${response.statusCode}');
      }
    } catch (e) {
      print('Error al hacer la solicitud: $e');
    }

    if (mounted) {
      setState(() {});
    }
  }

  List<Map<String, dynamic>> obtenerUsuariosFiltrados() {
    if (consultaBusqueda.isEmpty) {
      return _data;
    } else {
      return _data.where((registro) {
        return registro.values.any((value) => value.toString().toLowerCase().contains(consultaBusqueda.toLowerCase()));
      }).toList();
    }
  }

  Widget generarTablaConstrained() {
    final usuariosFiltrados = obtenerUsuariosFiltrados();

    final Map<String, double> columnWidths = {
      'id_empresa': 280.0,
      'estado_de_la_empresa': 280.0,
      'nombre': 280.0,
      'razon': 1000.0,

    };

    return ConstrainedBox(
      constraints: BoxConstraints(minWidth: 1000),
      child: DataTable(
        columns: [
          ...titulosColumnas.keys.map(
                (String key) => DataColumn(
              label: Container(
                width: columnWidths[key],
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                  border: Border(
                    right: BorderSide(color: Colors.black, width: 1.0),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    titulosColumnas[key]!,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
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
                  final valorCelda = '${usuario[clave]}';
                  return DataCell(
                    Container(
                      width: columnWidths[clave],
                      alignment: Alignment.centerLeft,
                      decoration: BoxDecoration(
                        border: Border(
                          right: BorderSide(color: Colors.black, width: 1.0),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          valorCelda,
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(3, 72, 128, 1),
      body: Container(
        padding: const EdgeInsets.all(8.0),
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Text(
              'Estado de las empresas',
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
              child: Theme(
                data: Theme.of(context).copyWith(dividerColor: Colors.white),
                child: SingleChildScrollView(
                  child: generarTablaConstrained(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
