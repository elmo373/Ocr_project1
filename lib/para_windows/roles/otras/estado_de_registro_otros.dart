import 'package:flutter/material.dart';
import 'package:postgre_flutter/Encriptacion.dart';
import 'package:postgres/postgres.dart';

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
    final connection = PostgreSQLConnection(
      '35.225.248.224',
      5432,
      'ocrdb',
      username: 'emanuel',
      password: 'emi77',
    );

    try {
      await connection.open();
      final ci = widget.datos['C.I.'];
      final eci = AESCrypt.encriptar(ci);
      print(eci);
      final result = await connection.query(
          'SELECT * FROM estado_empresa WHERE "id_empresa" = @eci',
          substitutionValues: {
            'eci': eci
          }
      );

      for (var row in result) {
        _data.add({
          'id_empresa': AESCrypt.desencriptar(row[0].toString()),
          'estado_de_la_empresa': AESCrypt.desencriptar(row[1].toString()),
          'nombre': AESCrypt.desencriptar(row[2].toString()),
          'razon': AESCrypt.desencriptar(row[3].toString()),
        });
      }
      print("Resultados de la base de datos: $result");
    } catch (e) {
      print('Error en la conexión a PostgreSQL: $e');
    } finally {
      await connection.close();
    }

    if (mounted) {
      setState(() {});
    }
  }

  DataTable buildDataTable() {
    return DataTable(
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
      rows: _data.map((Map<String, dynamic> usuario) {
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
                Text(
                  valorCelda,
                  style: TextStyle(color: Colors.black),
                ),
                showEditIcon: false,
              );
            },
          ).toList(),
        );
      }).toList(),
      dividerThickness: 1.0,
      horizontalMargin: 10.0,
      columnSpacing: 10.0,
      dataRowHeight: 45.0,
      headingRowColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
          return Color.fromRGBO(53, 122, 178, 1);
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
                data: Theme.of(context).copyWith(dividerColor: Colors.white),
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
