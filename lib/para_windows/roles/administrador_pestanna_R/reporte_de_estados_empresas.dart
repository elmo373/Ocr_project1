import 'package:flutter/material.dart';
import 'package:postgre_flutter/Encriptacion.dart';
import 'package:postgre_flutter/para_windows/base_de_datos_control.dart';
import 'package:postgres/postgres.dart';

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
  final Map<String, int> countByEstado = {'Registro activo': 0, 'Registro anulado': 0, 'Registro caducado': 0};
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
    cargarUsuarios();
  }

  void actualizarEstadoDeEmpresas() async {
    final connection = PostgreSQLConnection(
      base_de_datos_control.Coneccion,
      5432,
      'ocrdb',
      username: 'emanuel',
      password: 'emi77',
    );

    try {
      await connection.open();
      final result = await connection.query('SELECT * FROM documento_de_registro');

      for (var row in result) {
        final fechaEmision = DateTime.parse(AESCrypt.desencriptar(row[3].toString()));
        final nombreEmpresa = AESCrypt.desencriptar(row[2].toString());

        String nuevoEstado;
        String razon;
        if (DateTime.now().difference(fechaEmision).inDays > 365 * 2) {
          nuevoEstado = 'Registro caducado';
          razon = 'El registro caduco';
        } else {
          // Consiguiendo el último documento de inspección
          final inspecciones = await connection.query(
            'SELECT * FROM documento_de_inspeccion WHERE nombre_empresa = @nombre ORDER BY fecha_de_emision DESC LIMIT 1',
            substitutionValues: {'nombre': AESCrypt.encriptar(nombreEmpresa)},
          );
          if (inspecciones.isNotEmpty && AESCrypt.desencriptar(inspecciones.first[6].toString()) == 'No') {
            nuevoEstado = 'Registro anulado';
            razon = 'La última inspección no fue exitosa';
          } else {
            nuevoEstado = 'Registro activo';
            razon = 'Cumplió con todo';
          }
        }

        await connection.query('UPDATE estado_empresa SET estado_de_la_empresa = @estado, razon = @razon WHERE nombre = @nombre',
            substitutionValues: {
              'nombre': AESCrypt.encriptar(nombreEmpresa),
              'estado': AESCrypt.encriptar(nuevoEstado),
              'razon': AESCrypt.encriptar(razon)
            });

        countByEstado[nuevoEstado] = (countByEstado[nuevoEstado] ?? 0) + 1;
      }

      print('Estado de las empresas actualizado correctamente');
    } catch (e) {
      print('Error en la conexión a PostgreSQL: $e');
    } finally {
      await connection.close();
    }

    if (mounted) {
      setState(() {});
    }
  }

  void cargarUsuarios() async {
    final connection = PostgreSQLConnection(
      base_de_datos_control.Coneccion,
      5432,
      'ocrdb',
      username: 'emanuel',
      password: 'emi77',
    );

    try {
      await connection.open();
      final result = await connection.query('SELECT * FROM estado_empresa');

      for (var row in result) {
        _data.add({
          'id_empresa': AESCrypt.desencriptar(row[0].toString()),
          'estado_de_la_empresa': AESCrypt.desencriptar(row[1].toString()),
          'nombre': AESCrypt.desencriptar(row[2].toString()),
          'razon': AESCrypt.desencriptar(row[3].toString()),
        });
      }
    } catch (e) {
      print('Error en la conexión a PostgreSQL: $e');
    } finally {
      await connection.close();
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
