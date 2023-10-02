import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:postgre_flutter/para_app/Ocr_app/funciones_ocr.dart';
import 'package:postgre_flutter/para_app/Ocr_app/pdf_registro.dart';

class PantallaResultado extends StatefulWidget {
  final String texto;
  final Map<String, dynamic> datos;
  final File archivo;

  PantallaResultado({required this.texto, required this.datos, required this.archivo});

  @override
  _PantallaResultadoState createState() => _PantallaResultadoState();
}

class _PantallaResultadoState extends State<PantallaResultado> {
  final llaves = [
    'Número Certificado',
    'Nombre Empresa',
    'RUC',
    'Fecha de Emisión',
    'Director Material Bélico',
    'Director General Logística',
    'Representante Legal',
    'Actividad Principal',
    'Nombre Propietario',
  ];

  late Map<String, TextEditingController> _controladores;
  final _llaveFormulario = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _controladores = {for (var llave in llaves) llave: TextEditingController()};
  }

  @override
  void dispose() {
    _controladores.values.forEach((controlador) => controlador.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var datosExtraidos = ExtractorDatos.extraerDatos(widget.texto);

    if (datosExtraidos.isNotEmpty) {
      for (var llave in llaves) {
        _controladores[llave]?.text = datosExtraidos[0][llave] ?? '';
      }
    }


    return Scaffold(
      appBar: AppBar(
        title: Text('Información obtenida'),
        backgroundColor: Color.fromRGBO(3, 72, 128, 1),
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Form(
          key: _llaveFormulario,
          child: ListView(
            children: <Widget>[
              ...llaves.map((llave) {
                  return Card(
                    color: Colors.white,
                    child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          campoTexto(_controladores[llave]!, llave),
                        ],
                      ),
                    ),
                  );
              }).toList(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Color.fromRGBO(3, 72, 128, 1)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          )
                      ),
                    ),
                    child: Text('Cancelar', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Color.fromRGBO(3, 72, 128, 1)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          )
                      ),
                    ),
                    child: Text('Siguiente', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    onPressed: () {
                      if (_llaveFormulario.currentState!.validate()) {
                        for (var llave in llaves) {
                          datosExtraidos[0][llave] = _controladores[llave]!.text;
                        }

                        print(datosExtraidos);

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Pdf_registro(texto: widget.texto, datos: widget.datos, file: widget.archivo, resultados: datosExtraidos),
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  TextFormField campoTexto(TextEditingController controlador, String etiqueta) {
    String extra = "";
    if (etiqueta == "Fecha de Emisión"){
      extra = "(Ej. "+_obtenerFechaActual()+")";
    }
    return TextFormField(
      controller: controlador,
      decoration: InputDecoration(
        labelText: etiqueta + extra,
        labelStyle: TextStyle(color: Color.fromRGBO(3, 72, 128, 1), fontSize: 16.0, fontWeight: FontWeight.bold),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Color.fromRGBO(3, 72, 128, 1)),
        ),
      ),
      style: TextStyle(color: Color.fromRGBO(3, 72, 128, 1)),
      validator: (valor) {
        if (valor!.isEmpty) {
          return 'Por favor ingrese un valor';
        }
        if (etiqueta == 'Número Certificado' && valor.contains(RegExp(r'[^\d]'))) {
          return 'Por favor ingrese solo números';
        }
        if (['Director Material Bélico', 'Director General Logística', 'Representante Legal', 'Actividad Principal', 'Nombre Propietario'].contains(etiqueta) &&
            valor.contains(RegExp(r'[^a-zA-ZñÑáéíóúÁÉÍÓÚ. ]'))){
          return 'Por favor ingrese solo letras, puntos y espacios';
        }
        return null;
      },
    );
  }
  String _obtenerFechaActual() {
    final ahora = DateTime.now();
    final formateador = DateFormat('yyyy-MM-dd');
    return formateador.format(ahora);
  }
}
