import 'dart:convert';
import 'dart:math';

import 'package:http/http.dart' as http;

import '../modelos/estado_animo.dart';
import '../modelos/pelicula.dart';

class TmdbException implements Exception {
  final String mensaje;
  TmdbException(this.mensaje);

  @override
  String toString() => mensaje;
}

class TmdbServicio {
  final String apiKey;
  final http.Client cliente;
  final Random _azar;

  TmdbServicio({
    required this.apiKey,
    http.Client? cliente,
    Random? azar,
  })  : cliente = cliente ?? http.Client(),
        _azar = azar ?? Random();

  Uri construirUrl(EstadoAnimo animo) {
    final parametros = <String, String>{
      'api_key': apiKey,
      'language': 'es-MX',
    };

    if (animo.generoId == null) {
      return Uri.https(
          'api.themoviedb.org', '/3/trending/movie/week', parametros);
    }

    parametros['with_genres'] = '${animo.generoId}';
    parametros['sort_by'] = 'popularity.desc';
    return Uri.https('api.themoviedb.org', '/3/discover/movie', parametros);
  }

  Future<List<Pelicula>> obtenerPeliculas(EstadoAnimo animo) async {
    final http.Response respuesta;
    try {
      respuesta = await cliente.get(construirUrl(animo));
    } catch (_) {
      throw TmdbException('No hay conexión a internet');
    }

    if (respuesta.statusCode == 401) {
      throw TmdbException('API key inválida');
    }
    if (respuesta.statusCode != 200) {
      throw TmdbException('Error del servidor (${respuesta.statusCode})');
    }

    final datos = jsonDecode(respuesta.body) as Map<String, dynamic>;
    final resultados = datos['results'] as List<dynamic>;
    return resultados
        .map((j) => Pelicula.fromJson(j as Map<String, dynamic>))
        .toList();
  }

  Future<Pelicula> peliculaAlAzar(EstadoAnimo animo) async {
    final lista = await obtenerPeliculas(animo);
    if (lista.isEmpty) {
      throw TmdbException('No se encontraron películas');
    }
    return lista[_azar.nextInt(lista.length)];
  }
}