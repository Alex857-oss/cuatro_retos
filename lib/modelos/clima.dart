class Clima {
  final String ciudad;
  final String pais;
  final double temperatura;
  final double sensacionTermica;
  final int humedad;
  final double viento;
  final String descripcion;
  final String codigoIcono;

  const Clima({
    required this.ciudad,
    required this.pais,
    required this.temperatura,
    required this.sensacionTermica,
    required this.humedad,
    required this.viento,
    required this.descripcion,
    required this.codigoIcono,
  });

  factory Clima.fromJson(Map<String, dynamic> json) {
    final principal =
        (json['main'] as Map<String, dynamic>?) ?? <String, dynamic>{};
    final sistema =
        (json['sys'] as Map<String, dynamic>?) ?? <String, dynamic>{};
    final vientoJson =
        (json['wind'] as Map<String, dynamic>?) ?? <String, dynamic>{};
    final lista = (json['weather'] as List<dynamic>?) ?? <dynamic>[];
    final detalle = lista.isNotEmpty
        ? lista.first as Map<String, dynamic>
        : <String, dynamic>{};

    return Clima(
      ciudad: (json['name'] ?? '') as String,
      pais: (sistema['country'] ?? '') as String,
      temperatura: (principal['temp'] as num?)?.toDouble() ?? 0.0,
      sensacionTermica: (principal['feels_like'] as num?)?.toDouble() ?? 0.0,
      humedad: (principal['humidity'] as num?)?.toInt() ?? 0,
      viento: (vientoJson['speed'] as num?)?.toDouble() ?? 0.0,
      descripcion: (detalle['description'] ?? '') as String,
      codigoIcono: (detalle['icon'] ?? '') as String,
    );
  }

  String get descripcionCapitalizada => descripcion.isEmpty
      ? ''
      : descripcion[0].toUpperCase() + descripcion.substring(1);

  /// OpenWeatherMap manda un código como "01d" (día) o "01n" (noche).
  String get emoji {
    if (codigoIcono.length < 2) return '🌡️';
    final noche = codigoIcono.endsWith('n');

    switch (codigoIcono.substring(0, 2)) {
      case '01':
        return noche ? '🌙' : '☀️';
      case '02':
        return noche ? '☁️' : '⛅';
      case '03':
      case '04':
        return '☁️';
      case '09':
      case '10':
        return '🌧️';
      case '11':
        return '⛈️';
      case '13':
        return '❄️';
      case '50':
        return '🌫️';
      default:
        return '🌡️';
    }
  }
}