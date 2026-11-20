import '../modelos/filtro_gato.dart';

class CataasServicio {
  const CataasServicio();

  Uri construirUrl({
    String texto = '',
    FiltroGato filtro = FiltroGato.ninguno,
    int tamanoFuente = 40,
    int? semilla,
  }) {
    final frase = texto.trim();
    final parametros = <String, String>{};

    if (filtro.valorApi != null) {
      parametros['filter'] = filtro.valorApi!;
    }
    if (frase.isNotEmpty) {
      parametros['fontSize'] = '$tamanoFuente';
    }
    // Cataas devuelve un gato distinto en cada petición. Este parámetro
    // evita que Flutter reutilice la imagen guardada de la vez anterior.
    if (semilla != null) {
      parametros['t'] = '$semilla';
    }

    return Uri(
      scheme: 'https',
      host: 'cataas.com',
      pathSegments: frase.isEmpty ? ['cat'] : ['cat', 'says', frase],
      queryParameters: parametros.isEmpty ? null : parametros,
    );
  }
}