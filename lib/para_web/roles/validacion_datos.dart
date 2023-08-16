List<String>? validarUsuarios(List<Map<String, dynamic>> usuarios) {
  var emailPattern = r'^[^@]+@[^@]+\.[^@]+';
  var emailRegex = RegExp(emailPattern);
  List<String> errores = [];

  usuarios.forEach((usuario) {
    // Validar C.I.
    if(usuario['C.I.'] == null || usuario['C.I.'].length < 8 || usuario['C.I.'].length > 10 || !isNumeric(usuario['C.I.'])) {
      errores.add('Alerta: C.I. inválido para el usuario ${usuario['Nombre']}\n');
    }

    // Validar Nombre
    if(usuario['Nombre'] == null || hasNumeric(usuario['Nombre'])) {
      errores.add('Alerta: Nombre inválido para el usuario ${usuario['Nombre']}\n');
    }

    // Validar Contraseña
    if(usuario['Contraseña'] == null || usuario['Contraseña'].length < 8 || !hasUpperCase(usuario['Contraseña']) || !hasLowerCase(usuario['Contraseña'])) {
      errores.add('Alerta: Contraseña inválida para el usuario ${usuario['Nombre']}\n');
      errores.add('La contraseña debe tener mínimo 8 caracteres\n');
      errores.add('además de tener letras mayúsculas y minúsculas\n');
    }

    // Validar Correo Electrónico
    if(usuario['Correo Electrónico'] == null || !emailRegex.hasMatch(usuario['Correo Electrónico'])) {
      errores.add('Alerta: Correo Electrónico inválido para el usuario ${usuario['Nombre']}\n');
    }

    // Validar Numero de Telefono
    if(usuario['Numero de Telefono'] == null || !isNumeric(usuario['Numero de Telefono'])) {
      errores.add('Alerta: Número de teléfono inválido para el usuario ${usuario['Nombre']}\n');
    }
  });

  return errores.isEmpty ? null : errores;
}

bool isNumeric(String s) {
  if(s == null) {
    return false;
  }
  return double.tryParse(s) != null;
}

bool hasNumeric(String s) {
  if(s == null) {
    return false;
  }
  return s.contains(RegExp(r'[0-9]'));
}

bool hasUpperCase(String s) {
  if(s == null) {
    return false;
  }
  return s != s.toLowerCase();
}

bool hasLowerCase(String s) {
  if(s == null) {
    return false;
  }
  return s != s.toUpperCase();
}
