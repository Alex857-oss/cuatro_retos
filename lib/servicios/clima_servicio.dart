import 'dart:convert';

import 'package:http/http.dart' as http;

import '../modelos/clima.dart';

class ClimaException implements Exception {
  final String mensaje;
  ClimaException(this.mensaje);

  @override
  String toString() => mensaje;
}

class ClimaServicio {
  final String apiKey;
  final http.Client cliente;

  ClimaServicio({required this.apiKey, http.Client? cliente})
      : cliente = cliente ?? http.Client();

  Uri construirUrl(String ciudad) {
    return Uri.https('api.openweathermap.org', '/data/2.5/weather', {
      'q': ciudad.trim(),
      'appid': apiKey,
      'units': 'metric',
      'lang': 'es',
    });
  }

  Future<Clima> obtenerClima(String ciudad) async {
    if (ciudad.trim().isEmpty) {
      throw ClimaException('Escribe el nombre de una ciudad');
    }

    final http.Response respuesta;
    try {
      respuesta = await cliente.get(construirUrl(ciudad));
    } catch (_) {
      throw ClimaException('No hay conexión a internet');
    }

    if (respuesta.statusCode == 401) {
      throw ClimaException('API key inválida o aún no activada');
    }
    if (respuesta.statusCode == 404) {
      throw ClimaException('No encontramos esa ciudad');
    }
    if (respuesta.statusCode != 200) {
      throw ClimaException('Error del servidor (${respuesta.statusCode})');
    }

    final datos = jsonDecode(respuesta.body) as Map<String, dynamic>;
    return Clima.fromJson(datos);
  }
}