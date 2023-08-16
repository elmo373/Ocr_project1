import 'package:flutter/material.dart';
import 'package:postgre_flutter/para_windows/base_de_datos_control.dart';

class creacion_de_usaurios extends StatefulWidget {
  @override
  _creacion_de_usauriosState createState() => _creacion_de_usauriosState();
}

class _creacion_de_usauriosState extends State<creacion_de_usaurios> {
  final RegExp nombreRegExp = RegExp(r'^[a-zA-ZñÑáéíóúÁÉÍÓÚ\s]+$');
  final RegExp ciRegExp = RegExp(r'^[0-9]+$');
  final RegExp contrasenaRegExp = RegExp(r'^(?=.*[a-z])(?=.*[A-Z]).{8,}$');
  final RegExp correoElectronicoRegExp = RegExp(r'^[^@]+@[^@]+\.[a-zA-Z]{2,}$');
  final RegExp telefonoRegExp = RegExp(r'^[0-9]+$');

  final _formKey = GlobalKey<FormState>();
  bool _formularioValido = false;

  String nombreTabla = 'usuarios';

  Map<String, TextEditingController> controladores = {
    'C.I.': TextEditingController(),
    'Nombre': TextEditingController(),
    'Contraseña': TextEditingController(),
    'Correo Electrónico': TextEditingController(),
    'Rol': TextEditingController(),
    'Fecha de Registro': TextEditingController(),
    'Numero de Telefono': TextEditingController(),
  };

  List<Map<String, dynamic>> datosDeCreacion = [{}];

  String? _rolSeleccionado;
  List<String> _roles = ['Administrador', 'Personal', 'Técnico', 'Empresa'];

  void agregarUsuario(List<Map<String, dynamic>> dato) async {
    await base_de_datos_control.agregarDatos(nombreTabla, dato);
  }

  @override
  void initState() {
    super.initState();
    controladores.forEach((key, value) {
      datosDeCreacion[0][key] = '';
      controladores[key] = TextEditingController();
      controladores[key]!.addListener(() {
        setState(() {
          datosDeCreacion[0][key] = controladores[key]!.text;
          _formularioValido = _formKey.currentState?.validate() ?? false;
        });
      });
    });
  }

  @override
  void dispose() {
    controladores.forEach((key, value) {
      controladores[key]!.dispose();
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color.fromRGBO(3, 72, 128, 1), // Fondo de la página
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.4, // 80% del ancho de la pantalla
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Color.fromRGBO(53, 122, 178, 1),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Titulo añadido en la ubicación solicitada
                    Text(
                      "Creación de Usuarios", // Puedes cambiar este texto al título que desees
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20), // Espacio entre el título y el siguiente widget
                  ]..addAll(controladores.keys.map((llave) {
                    if (llave == 'Fecha de Registro') {
                      return SizedBox.shrink();
                    }

                    if (llave == 'Rol') {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            llave,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10),
                          // Divido los botones en 2 filas
                          for (int i = 0; i < _roles.length; i += 2) ...[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                for (int j = i; j < i + 2 && j < _roles.length; j++)
                                  Expanded(
                                    child: Container(
                                      margin: EdgeInsets.symmetric(horizontal: 4.0),
                                      decoration: BoxDecoration(
                                        color: _rolSeleccionado == _roles[j] ? Colors.orange : Colors.white,
                                        borderRadius: BorderRadius.circular(4.0),
                                      ),
                                      child: TextButton(
                                        onPressed: () {
                                          setState(() {
                                            _rolSeleccionado = _roles[j];
                                            datosDeCreacion[0][llave] = _rolSeleccionado;
                                          });
                                        },
                                        child: Text(
                                          _roles[j],
                                          style: TextStyle(
                                            color: _rolSeleccionado == _roles[j] ? Colors.white : Colors.orange,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            if(i + 2 < _roles.length) SizedBox(height: 10),
                          ]
                        ],
                      );
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          llave,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextFormField(
                          controller: controladores[llave],
                          style: TextStyle(
                            color: Color.fromRGBO(1, 20, 100, 1.0),
                            fontSize: 16, // Tamaño reducido en 2 puntos
                          ),
                          decoration: InputDecoration(
                            fillColor: Colors.grey,
                            filled: true,
                            hintStyle: TextStyle(
                              color: Color.fromRGBO(1, 20, 100, 1.0),
                              fontSize: 16, // Tamaño reducido en 2 puntos
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: BorderSide(
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          validator: (value) {
                            switch (llave) {
                              case 'Nombre':
                                if (!nombreRegExp.hasMatch(value ?? '')) {
                                  return 'Introduce un nombre válido';
                                }
                                break;
                              case 'C.I.':
                                if (!ciRegExp.hasMatch(value ?? '')) {
                                  return 'Introduce un C.I. válido';
                                }
                                break;
                              case 'Contraseña':
                                if (!contrasenaRegExp.hasMatch(value ?? '')) {
                                  return 'La contraseña debe tener al menos 8 caracteres, una letra mayúscula y una minúscula.';
                                }
                                break;
                              case 'Correo Electrónico':
                                if (!correoElectronicoRegExp.hasMatch(value ?? '')) {
                                  return 'Introduce un correo electrónico válido';
                                }
                                break;
                              case 'Numero de Telefono':
                                if (!telefonoRegExp.hasMatch(value ?? '')) {
                                  return 'Introduce un número de teléfono válido';
                                }
                                break;
                              default:
                                return null;
                            }
                            return null;
                          },

                        ),
                        SizedBox(height: 18),  // Espacio entre cada elemento
                      ],
                    );
                  })),
                ),
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add, color: Colors.white),
        onPressed: _formularioValido
            ? () {
          agregarUsuario(datosDeCreacion);
        }
            : null,
      ),
    );
  }

}
