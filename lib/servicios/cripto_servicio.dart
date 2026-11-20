import 'dart:convert';

import 'package:http/http.dart' as http;

import '../modelos/precio_cripto.dart';

class CriptoException implements Exception {
  final String mensaje;
  CriptoException(this.mensaje);

  @override
  String toString() => mensaje;
}

class CriptoServicio {
  final http.Client cliente;

  CriptoServicio({http.Client? cliente}) : cliente = cliente ?? http.Client();

  Uri construirUrl() {
    return Uri.https('api.coingecko.com', '/api/v3/simple/price', {
      'ids': Cripto.values.map((c) => c.id).join(','),
      'vs_currencies': 'usd',
    });
  }

  Future<List<PrecioCripto>> obtenerPrecios() async {
    final http.Response respuesta;
    try {
      respuesta = await cliente.get(construirUrl());
    } catch (_) {
      throw CriptoException('No hay conexión a internet');
    }

    if (respuesta.statusCode == 429) {
      throw CriptoException(
          'Demasiadas consultas a CoinGecko. Espera un minuto e intenta de nuevo');
    }
    if (respuesta.statusCode != 200) {
      throw CriptoException('Error del servidor (${respuesta.statusCode})');
    }

    final datos = jsonDecode(respuesta.body) as Map<String, dynamic>;
    final precios = <PrecioCripto>[];

    for (final cripto in Cripto.values) {
      final dato = datos[cripto.id] as Map<String, dynamic>?;
      final usd = dato?['usd'] as num?;
      if (usd != null) {
        precios.add(PrecioCripto(cripto: cripto, precioUsd: usd.toDouble()));
      }
    }

    if (precios.isEmpty) {
      throw CriptoException('No se recibieron precios');
    }
    return precios;
  }
}