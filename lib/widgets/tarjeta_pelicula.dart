import 'package:flutter/material.dart';

import '../modelos/pelicula.dart';

class TarjetaPelicula extends StatelessWidget {
  final Pelicula pelicula;

  const TarjetaPelicula({super.key, required this.pelicula});

  @override
  Widget build(BuildContext context) {
    final url = pelicula.urlPoster;

    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (url != null)
            Image.network(
              url,
              height: 400,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const SizedBox(
                height: 200,
                child: Center(child: Icon(Icons.broken_image, size: 64)),
              ),
            )
          else
            const SizedBox(
              height: 200,
              child: Center(child: Icon(Icons.movie, size: 64)),
            ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  pelicula.titulo,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 20),
                    const SizedBox(width: 4),
                    Text(pelicula.calificacion.toStringAsFixed(1)),
                    const SizedBox(width: 16),
                    Text(pelicula.fechaEstreno),
                  ],
                ),
                const SizedBox(height: 12),
                Text(pelicula.sinopsis.isEmpty
                    ? 'Sin sinopsis disponible.'
                    : pelicula.sinopsis),
              ],
            ),
          ),
        ],
      ),
    );
  }
}