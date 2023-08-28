import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: UsuariosPage(),
    );
  }
}

class UsuariosPage extends StatefulWidget {
  @override
  _UsuariosPageState createState() => _UsuariosPageState();
}

class _UsuariosPageState extends State<UsuariosPage> {
  final Map<String, String> titulosColumnas = {
    'C.I.': 'C.I.',
    'Nombre': 'Nombre',
    'Contraseña': 'Contraseña',
    'Correo Electrónico': 'Correo Electrónico',
    'Rol': 'Rol',
    'Fecha de Registro': 'Fecha de Registro',
    'Numero de Telefono': 'Número de Teléfono'
  };

  List<Map<String, dynamic>> obtenerUsuariosFiltrados() {
    // Aquí puedes retornar una lista filtrada de usuarios. Por ahora, retornaremos una lista ficticia:
    return [
      {
        'C.I.': '12345678',
        'Nombre': 'Juan Perez',
        'Contraseña': '****',
        'Correo Electrónico': 'juan@email.com',
        'Rol': 'Admin',
        'Fecha de Registro': '2023-01-01',
        'Numero de Telefono': '123456789'
      },
      {
        'C.I.': '12345678',
        'Nombre': 'Juan Perez',
        'Contraseña': '****',
        'Correo Electrónico': 'juan@email.com',
        'Rol': 'Admin',
        'Fecha de Registro': '2023-01-01',
        'Numero de Telefono': '123456789'
      },
      {
        'C.I.': '12345678',
        'Nombre': 'Juan Perez',
        'Contraseña': '****',
        'Correo Electrónico': 'juan@email.com',
        'Rol': 'Admin',
        'Fecha de Registro': '2023-01-01',
        'Numero de Telefono': '123456789'
      },
      {
        'C.I.': '12345678',
        'Nombre': 'Juan Perez',
        'Contraseña': '****',
        'Correo Electrónico': 'juan@email.com',
        'Rol': 'Admin',
        'Fecha de Registro': '2023-01-01',
        'Numero de Telefono': '123456789'
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    final usuariosFiltrados = obtenerUsuariosFiltrados();

    // Anchuras de las columnas
    final Map<String, double> columnWidths = {
      'C.I.': 100.0,
      'Nombre': 150.0,
      'Contraseña': 200.0,
      'Correo Electrónico': 250.0,
      'Rol': 120.0,
      'Fecha de Registro': 180.0,
      'Numero de Telefono': 200.0
    };

    return Scaffold(
      body: Container(
        color: Color.fromRGBO(3, 72, 128, 1),
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            SizedBox(height: 20),
            Text(
              'Lista de usuarios',
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ConstrainedBox(
                constraints: BoxConstraints(minWidth: 1000),
                child: usuariosFiltrados.isNotEmpty
                    ? Theme(
                  data: Theme.of(context).copyWith(
                    dividerColor: Colors.black,
                    canvasColor: Color.fromRGBO(53, 122, 178, 1),
                  ),
                  child: DataTable(
                    columns: titulosColumnas.keys.map(
                          (String key) {
                        final width = columnWidths[key];
                        return DataColumn(
                          label: Container(
                            width: width,
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
                        );
                      },
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
                    horizontalMargin: 0.0,
                    columnSpacing: 0.0,
                    dataRowHeight: 45.0,
                    headingRowColor: MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                        return Color.fromRGBO(53, 122, 178, 1);
                      },
                    ),
                  ),
                )
                    : Container(
                  child: Center(
                    child: Text(
                      "No hay usuarios disponibles",
                      style: TextStyle(color: Colors.white, fontSize: 20),
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
