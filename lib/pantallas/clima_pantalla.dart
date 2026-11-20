import 'package:flutter/material.dart';

import '../modelos/clima.dart';
import '../servicios/clima_servicio.dart';

enum EstadoClima { inicial, cargando, exito, error }

class ClimaPantalla extends StatefulWidget {
  final ClimaServicio servicio;

  const ClimaPantalla({super.key, required this.servicio});

  @override
  State<ClimaPantalla> createState() => _ClimaPantallaState();
}

class _ClimaPantallaState extends State<ClimaPantalla> {
  final _controlador = TextEditingController(text: 'Dolores Hidalgo');
  EstadoClima _estado = EstadoClima.inicial;
  Clima? _clima;
  String _mensajeError = '';

  @override
  void dispose() {
    _controlador.dispose();
    super.dispose();
  }

  Future<void> _buscar() async {
    setState(() => _estado = EstadoClima.cargando);
    try {
      final clima = await widget.servicio.obtenerClima(_controlador.text);
      if (!mounted) return;
      setState(() {
        _clima = clima;
        _estado = EstadoClima.exito;
      });
    } on ClimaException catch (e) {
      if (!mounted) return;
      setState(() {
        _mensajeError = e.mensaje;
        _estado = EstadoClima.error;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _mensajeError = 'Respuesta inesperada del servidor';
        _estado = EstadoClima.error;
      });
    }
  }

  Widget _dato(String titulo, String valor) {
    return Column(
      children: [
        Text(titulo, style: const TextStyle(color: Colors.grey)),
        const SizedBox(height: 4),
        Text(valor, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _tarjeta(Clima clima) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Text(
              '${clima.ciudad}, ${clima.pais}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(clima.emoji, style: const TextStyle(fontSize: 72)),
            Text(
              '${clima.temperatura.round()}°C',
              style: Theme.of(context).textTheme.displayMedium,
            ),
            Text(clima.descripcionCapitalizada),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _dato('Sensación', '${clima.sensacionTermica.round()}°C'),
                _dato('Humedad', '${clima.humedad}%'),
                _dato('Viento', '${clima.viento.toStringAsFixed(1)} m/s'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _resultado() {
    switch (_estado) {
      case EstadoClima.inicial:
        return const Text('Escribe una ciudad y toca el botón.');
      case EstadoClima.cargando:
        return const Center(child: CircularProgressIndicator());
      case EstadoClima.exito:
        return _tarjeta(_clima!);
      case EstadoClima.error:
        return Text(
          _mensajeError,
          style: const TextStyle(color: Colors.red),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('🌦️ Clima')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _controlador,
            decoration: const InputDecoration(
              labelText: 'Ciudad',
              border: OutlineInputBorder(),
            ),
            textInputAction: TextInputAction.search,
            onSubmitted: (_) => _buscar(),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: _estado == EstadoClima.cargando ? null : _buscar,
            icon: const Icon(Icons.search),
            label: const Text('Buscar clima'),
          ),
          const SizedBox(height: 16),
          _resultado(),
        ],
      ),
    );
  }
}