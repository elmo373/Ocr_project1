import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  final String text;

  ResultScreen({required this.text});

  String removeDots(String text) {
    return text.replaceAll('.', '');
  }

  List<Map<String, String>> extraerDatos(String texto) {
    var regexNumeroCertificado1 = RegExp(r"N° (\d+/\d+)");
    var regexNombreEmpresa1 = RegExp(r"Nombre o Razón Social: (.+)");
    var regexRUC1 = RegExp(r"Registro Único de Contribuyentes R.U.C.: (\d+)");
    var regexFechaEmision1 = RegExp(r"La Paz, (\d+ de [a-zA-Z]+ de \d+)");
    var regexDirectorMaterialBelico1 = RegExp(r"Director de Material Bélico\s+Sr\. (.+?)\s{2,}");
    var regexDirectorGeneralLogistica1 = RegExp(r"Director General de Logística\s+Sr\. (.+)");
    var regexRepresentanteLegal1 = RegExp(r"Representante legal: (.+)");
    var regexActividadPrincipal1 = RegExp(r"Actividad Principal: (.+)");
    var regexNombrePropietario1 = RegExp(r"Nombre del Propietario, Gerente, Director: (.+)");

    var regexNumeroCertificado2 = RegExp(r"N[°|º]\s*(\d+(/\d+)?)");
    var regexNombreEmpresa2 = RegExp(r"Nombre\s*o\s*Raz[ó|o]n\s*Social\s*:\s*(.+)");
    var regexRUC2 = RegExp(r"Registro\s*[U|ú]nico\s*de\s*Contribuyentes\s*R[\.|\. ]?U[\.|\. ]?C[\.|\. ]?:\s*(\d+)");
    var regexFechaEmision2 = RegExp(r"Fecha\s*de\s*Escritura\s*de\s*Constituci[ó|o]n\s*Social\s*:\s*(\d+)");
    var regexDirectorMaterialBelico2 = RegExp(r"Matr[í|i]cula\s*RENAREC\s*:\s*(.+)");
    var regexDirectorGeneralLogistica2 = RegExp(r"Licencia\s*de\s*funcionamiento\s*Municipal\s*:\s*(.+)");
    var regexRepresentanteLegal2 = RegExp(r"Representante\s*Legal\s*:\s*(.+)");
    var regexActividadPrincipal2 = RegExp(r"Actividad\s*Principal\s*:\s*(.+)");
    var regexNombrePropietario2 = RegExp(r"Nombre\s*del\s*Propietario,\s*Gerente,\s*Director:\s*(.+)");

    var matchesNumeroCertificado = regexNumeroCertificado1.allMatches(texto);
    var matchesNombreEmpresa = regexNombreEmpresa1.allMatches(texto);
    var matchesRUC = regexRUC1.allMatches(texto);
    var matchesFechaEmision = regexFechaEmision1.allMatches(texto);
    var matchesDirectorMaterialBelico = regexDirectorMaterialBelico1.allMatches(texto);
    var matchesDirectorGeneralLogistica = regexDirectorGeneralLogistica1.allMatches(texto);
    var matchesRepresentanteLegal = regexRepresentanteLegal1.allMatches(texto);
    var matchesActividadPrincipal = regexActividadPrincipal1.allMatches(texto);
    var matchesNombrePropietario = regexNombrePropietario1.allMatches(texto);

    if (matchesNumeroCertificado.isEmpty) {
      matchesNumeroCertificado = regexNumeroCertificado2.allMatches(texto);
    }
    if (matchesNombreEmpresa.isEmpty) {
      matchesNombreEmpresa = regexNombreEmpresa2.allMatches(texto);
    }
    if (matchesRUC.isEmpty) {
      matchesRUC = regexRUC2.allMatches(texto);
    }
    if (matchesFechaEmision.isEmpty) {
      matchesFechaEmision = regexFechaEmision2.allMatches(texto);
    }
    if (matchesDirectorMaterialBelico.isEmpty) {
      matchesDirectorMaterialBelico = regexDirectorMaterialBelico2.allMatches(texto);
    }
    if (matchesDirectorGeneralLogistica.isEmpty) {
      matchesDirectorGeneralLogistica = regexDirectorGeneralLogistica2.allMatches(texto);
    }
    if (matchesRepresentanteLegal.isEmpty) {
      matchesRepresentanteLegal = regexRepresentanteLegal2.allMatches(texto);
    }
    if (matchesActividadPrincipal.isEmpty) {
      matchesActividadPrincipal = regexActividadPrincipal2.allMatches(texto);
    }
    if (matchesNombrePropietario.isEmpty) {
      matchesNombrePropietario = regexNombrePropietario2.allMatches(texto);
    }

    List<Map<String, String>> resultados = [
      {
        "NumeroCertificado": "",
        "NombreEmpresa": "",
        "RUC": "",
        "FechaEmision": "",
        "DirectorMaterialBelico": "",
        "DirectorGeneralLogistica": "",
        "RepresentanteLegal": "",
        "ActividadPrincipal": "",
        "NombrePropietario": ""
      }
    ];

    for (var i = 0; i < matchesNumeroCertificado.length; i++) {
      var numeroCertificado = matchesNumeroCertificado.length > i ? matchesNumeroCertificado.elementAt(i).group(1) ?? "" : "";
      var nombreEmpresa = matchesNombreEmpresa.length > i ? matchesNombreEmpresa.elementAt(i).group(1) ?? "" : "";
      var ruc = matchesRUC.length > i ? matchesRUC.elementAt(i).group(1) ?? "" : "";
      var fechaEmision = matchesFechaEmision.length > i ? matchesFechaEmision.elementAt(i).group(1) ?? "" : "";
      var directorMaterialBelico = matchesDirectorMaterialBelico.length > i ? matchesDirectorMaterialBelico.elementAt(i).group(1) ?? "" : "";
      var directorGeneralLogistica = matchesDirectorGeneralLogistica.length > i ? matchesDirectorGeneralLogistica.elementAt(i).group(1) ?? "" : "";
      var representanteLegal = matchesRepresentanteLegal.length > i ? matchesRepresentanteLegal.elementAt(i).group(1) ?? "" : "";
      var actividadPrincipal = matchesActividadPrincipal.length > i ? matchesActividadPrincipal.elementAt(i).group(1) ?? "" : "";
      var nombrePropietario = matchesNombrePropietario.length > i ? matchesNombrePropietario.elementAt(i).group(1) ?? "" : "";

      resultados.add({
        "NumeroCertificado": numeroCertificado,
        "NombreEmpresa": nombreEmpresa,
        "RUC": ruc,
        "FechaEmision": fechaEmision,
        "DirectorMaterialBelico": directorMaterialBelico,
        "DirectorGeneralLogistica": directorGeneralLogistica,
        "RepresentanteLegal": representanteLegal,
        "ActividadPrincipal": actividadPrincipal,
        "NombrePropietario": nombrePropietario
      });
    }

    return resultados;
  }

  @override
  Widget build(BuildContext context) {
    print(text);

    var datosExtraidos = extraerDatos(text);

    return Scaffold(
      appBar: AppBar(
        title: Text('Información obtenida'),
        backgroundColor: Color.fromRGBO(3, 72, 128, 1),
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: datosExtraidos.length,
          itemBuilder: (context, index) {
            return Card(
              color: Colors.white,
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // Aquí puedes agregar todos los campos que necesites de la misma forma
                    textFormField(datosExtraidos[index]['NumeroCertificado'] ?? '', 'Numero de Certificado'),
                    textFormField(datosExtraidos[index]['NombreEmpresa'] ?? '', 'Nombre de la Empresa'),
                    textFormField(datosExtraidos[index]['RUC'] ?? '', 'RUC'),
                    textFormField(datosExtraidos[index]['FechaEmision'] ?? '', 'Fecha de Emisión'),
                    textFormField(datosExtraidos[index]['DirectorMaterialBelico'] ?? '', 'Director de Material Bélico'),
                    textFormField(datosExtraidos[index]['DirectorGeneralLogistica'] ?? '', 'Director General de Logística'),
                    textFormField(datosExtraidos[index]['RepresentanteLegal'] ?? '', 'Representante Legal'),
                    textFormField(datosExtraidos[index]['ActividadPrincipal'] ?? '', 'Actividad Principal'),
                    textFormField(datosExtraidos[index]['NombrePropietario'] ?? '', 'Nombre del Propietario'),

                    // Botones de Subir y Cancelar
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
                          child: Text('Subir', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  TextFormField textFormField(String initialValue, String label) {
    return TextFormField(
      initialValue: initialValue,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Color.fromRGBO(3, 72, 128, 1), fontSize: 16.0, fontWeight: FontWeight.bold),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Color.fromRGBO(3, 72, 128, 1)),
        ),
      ),
      style: TextStyle(color: Color.fromRGBO(3, 72, 128, 1)),
    );
  }
}
