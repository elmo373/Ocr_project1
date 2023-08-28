import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:postgre_flutter/Encriptacion.dart';
import 'package:postgre_flutter/para_web/api_control.dart';

class estado_de_registro_otros extends StatelessWidget {
  final Map<String, dynamic> datos;

  estado_de_registro_otros({required this.datos});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: EstadoEmpresaPage(datos: datos),
    );
  }
}

class EstadoEmpresaPage extends StatefulWidget {
  final Map<String, dynamic> datos;

  EstadoEmpresaPage({required this.datos});

  @override
  _EstadoEmpresaPageState createState() => _EstadoEmpresaPageState();
}

class _EstadoEmpresaPageState extends State<EstadoEmpresaPage> {
  List<Map<String, dynamic>> _data = [];
  final Map<String, String> titulosColumnas = {
    'id_empresa': 'ID Empresa',
    'estado_de_la_empresa': 'Estado de la Empresa',
    'nombre': 'Nombre',
    'razon': 'Razón',
  };

  @override
  void initState() {
    super.initState();
    cargarUsuarios();
  }

  void cargarUsuarios() async {
    final Link = api_control.BASE_URL;
    final url = '$Link/query/EstadoDeEmpresas'; // Usando la URL base de tu servidor.

    final ci = widget.datos['C.I.'];

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final List datosDeLaApi = json.decode(response.body);
        for (var row in datosDeLaApi) {
          // Desencriptamos el id_empresa para compararlo con ci
          final idEmpresaDesencriptado = AESCrypt.desencriptar(row['id_empresa']);

          // Solo agregamos al _data si el id_empresa coincide con ci
          if (idEmpresaDesencriptado == ci) {
            _data.add({
              'id_empresa': idEmpresaDesencriptado,
              'estado_de_la_empresa': AESCrypt.desencriptar(row['estado_de_la_empresa']),
              'nombre': AESCrypt.desencriptar(row['nombre']),
              'razon': AESCrypt.desencriptar(row['razon']),
            });
          }
        }
      } else {
        throw Exception('Error al cargar los datos');
      }
    } catch (e) {
      print('Error al llamar la API: $e');
    }

    if (mounted) {
      setState(() {});
    }
  }

  DataTable buildDataTable() {
    return DataTable(
      columns: titulosColumnas.keys.map(
            (String key) => DataColumn(
          label: Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              border: Border.symmetric(
                vertical: BorderSide(color: Colors.black),  // Línea vertical de la columna
              ),
            ),
            child: Text(
              titulosColumnas[key]!,
              style: TextStyle(
                color: Colors.white,  // Color del título de las columnas
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ).toList(),
      rows: _data.map((Map<String, dynamic> usuario) {
        return DataRow(
          color: MaterialStateProperty.resolveWith<Color>(
                (Set<MaterialState> estados) {
              return Colors.grey[350]!;  // Color de fondo de las celdas de las filas
            },
          ),
          cells: usuario.keys.map(
                (String clave) {
              final valorCelda = '${usuario[clave]}';
              return DataCell(
                Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    border: Border.symmetric(
                      vertical: BorderSide(color: Colors.black),  // Línea vertical de cada celda
                    ),
                  ),
                  child: Text(
                    valorCelda,
                    style: TextStyle(color: Colors.black),  // Color del texto dentro de las celdas
                  ),
                ),
                showEditIcon: false,
              );
            },
          ).toList(),
        );
      }).toList(),
      dividerThickness: 1.0,  // Grosor de las divisiones horizontales
      horizontalMargin: 10.0,  // Margen horizontal
      columnSpacing: 10.0,  // Espaciamiento entre columnas
      dataRowHeight: 45.0,  // Altura de las filas
      headingRowColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
          return Color.fromRGBO(53, 122, 178, 1);  // Color de fondo de la fila del encabezado
        },
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
            Expanded(
              child: Theme(
                data: Theme.of(context).copyWith(dividerColor: Colors.black),  // Cambiando el color del divisor a negro para mostrar las líneas horizontales.
                child: SingleChildScrollView(
                  child: buildDataTable(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
