import 'package:flutter/material.dart';

import '../modelos/filtro_gato.dart';
import '../servicios/cataas_servicio.dart';

typedef ConstructorImagen = Widget Function(String url);

class GatosPantalla extends StatefulWidget {
  final CataasServicio servicio;

  /// Solo se usa en las pruebas, para no descargar imágenes reales.
  final ConstructorImagen? constructorImagen;

  const GatosPantalla({
    super.key,
    this.servicio = const CataasServicio(),
    this.constructorImagen,
  });

  @override
  State<GatosPantalla> createState() => _GatosPantallaState();
}

class _GatosPantallaState extends State<GatosPantalla> {
  final _controlador = TextEditingController();
  FiltroGato _filtro = FiltroGato.ninguno;
  String? _url;

  @override
  void dispose() {
    _controlador.dispose();
    super.dispose();
  }

  void _generar() {
    setState(() {
      _url = widget.servicio
          .construirUrl(
            texto: _controlador.text,
            filtro: _filtro,
            semilla: DateTime.now().millisecondsSinceEpoch,
          )
          .toString();
    });
  }

  Widget _imagen(String url) {
    final constructor = widget.constructorImagen;
    if (constructor != null) {
      return constructor(url);
    }

    return Image.network(
      url,
      key: ValueKey(url),
      fit: BoxFit.contain,
      loadingBuilder: (context, child, progreso) {
        if (progreso == null) return child;
        return const SizedBox(
          height: 300,
          child: Center(child: CircularProgressIndicator()),
        );
      },
      errorBuilder: (_, __, ___) => const SizedBox(
        height: 300,
        child: Center(child: Text('No se pudo cargar el gato 😿')),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('🐱 Memes de Gatos')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _controlador,
            decoration: const InputDecoration(
              labelText: 'Escribe tu frase',
              border: OutlineInputBorder(),
            ),
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _generar(),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            children: [
              for (final filtro in FiltroGato.values)
                ChoiceChip(
                  label: Text(filtro.nombre),
                  selected: _filtro == filtro,
                  onSelected: (_) => setState(() => _filtro = filtro),
                ),
            ],
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: _generar,
            icon: const Icon(Icons.pets),
            label: const Text('Generar gato'),
          ),
          const SizedBox(height: 16),
          if (_url == null)
            const Text('Escribe una frase, elige un filtro y toca el botón.')
          else
            _imagen(_url!),
        ],
      ),
    );
  }
}