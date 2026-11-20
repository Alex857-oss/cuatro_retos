class Pelicula {
  final int id;
  final String titulo;
  final String sinopsis;
  final String? rutaPoster;
  final double calificacion;
  final String fechaEstreno;

  const Pelicula({
    required this.id,
    required this.titulo,
    required this.sinopsis,
    required this.rutaPoster,
    required this.calificacion,
    required this.fechaEstreno,
  });

  factory Pelicula.fromJson(Map<String, dynamic> json) {
    return Pelicula(
      id: json['id'] as int,
      titulo: (json['title'] ?? 'Sin título') as String,
      sinopsis: (json['overview'] ?? '') as String,
      rutaPoster: json['poster_path'] as String?,
      calificacion: (json['vote_average'] as num?)?.toDouble() ?? 0.0,
      fechaEstreno: (json['release_date'] ?? '') as String,
    );
  }

  String? get urlPoster => rutaPoster == null
      ? null
      : 'https://image.tmdb.org/t/p/w500$rutaPoster';
}