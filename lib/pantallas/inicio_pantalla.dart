import 'package:flutter/material.dart';

import '../modelos/estado_animo.dart';
import '../modelos/pelicula.dart';
import '../servicios/tmdb_servicio.dart';
import '../widgets/tarjeta_pelicula.dart';

enum Estado { inicial, cargando, exito, error }

class InicioPantalla extends StatefulWidget {
  final TmdbServicio servicio;

  const InicioPantalla({super.key, required this.servicio});

  @override
  State<InicioPantalla> createState() => _InicioPantallaState();
}

class _InicioPantallaState extends State<InicioPantalla> {
  EstadoAnimo _animo = EstadoAnimo.feliz;
  Estado _estado = Estado.inicial;
  Pelicula? _pelicula;
  String _mensajeError = '';

  Future<void> _recomendar() async {
    setState(() => _estado = Estado.cargando);
    try {
      final pelicula = await widget.servicio.peliculaAlAzar(_animo);
      if (!mounted) return;
      setState(() {
        _pelicula = pelicula;
        _estado = Estado.exito;
      });
    } on TmdbException catch (e) {
      if (!mounted) return;
      setState(() {
        _mensajeError = e.mensaje;
        _estado = Estado.error;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _mensajeError = 'Respuesta inesperada del servidor';
        _estado = Estado.error;
      });
    }
  }

  Widget _resultado() {
    switch (_estado) {
      case Estado.inicial:
        return const Text('Elige tu estado de ánimo y toca el botón.');
      case Estado.cargando:
        return const Center(child: CircularProgressIndicator());
      case Estado.exito:
        return TarjetaPelicula(pelicula: _pelicula!);
      case Estado.error:
        return Text(
          _mensajeError,
          style: const TextStyle(color: Colors.red),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('🎬 Recomendador de Películas')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('¿Cómo te sientes hoy?',
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              for (final animo in EstadoAnimo.values)
                ChoiceChip(
                  label: Text('${animo.emoji} ${animo.nombre}'),
                  selected: _animo == animo,
                  onSelected: (_) => setState(() => _animo = animo),
                ),
            ],
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: _estado == Estado.cargando ? null : _recomendar,
            icon: const Icon(Icons.movie_filter),
            label: const Text('Recomiéndame'),
          ),
          const SizedBox(height: 16),
          _resultado(),
        ],
      ),
    );
  }
}