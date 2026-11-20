import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../modelos/precio_cripto.dart';
import '../servicios/cripto_servicio.dart';

enum EstadoCripto { cargando, exito, error }

class CriptoPantalla extends StatefulWidget {
  final CriptoServicio servicio;

  const CriptoPantalla({super.key, required this.servicio});

  @override
  State<CriptoPantalla> createState() => _CriptoPantallaState();
}

class _CriptoPantallaState extends State<CriptoPantalla> {
  final _controlador = TextEditingController();
  EstadoCripto _estado = EstadoCripto.cargando;
  List<PrecioCripto> _precios = [];
  String _mensajeError = '';

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  @override
  void dispose() {
    _controlador.dispose();
    super.dispose();
  }

  Future<void> _cargar() async {
    setState(() => _estado = EstadoCripto.cargando);
    try {
      final precios = await widget.servicio.obtenerPrecios();
      if (!mounted) return;
      setState(() {
        _precios = precios;
        _estado = EstadoCripto.exito;
      });
    } on CriptoException catch (e) {
      if (!mounted) return;
      setState(() {
        _mensajeError = e.mensaje;
        _estado = EstadoCripto.error;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _mensajeError = 'Respuesta inesperada del servidor';
        _estado = EstadoCripto.error;
      });
    }
  }

  Widget _tarjeta(PrecioCripto precio, double? monto) {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${precio.cripto.nombre} (${precio.cripto.simbolo})',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            Text(
              formatearUsd(precio.precioUsd),
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            if (monto != null) ...[
              const SizedBox(height: 12),
              const Text('Con tu monto compras:'),
              Text(
                '${formatearCantidad(precio.cantidadPara(monto))} '
                '${precio.cripto.simbolo}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ],
        ),
      ),
    );
  }

  List<Widget> _contenido(double? monto) {
    switch (_estado) {
      case EstadoCripto.cargando:
        return [const Center(child: CircularProgressIndicator())];
      case EstadoCripto.error:
        return [
          Text(_mensajeError, style: const TextStyle(color: Colors.red)),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: _cargar,
            icon: const Icon(Icons.refresh),
            label: const Text('Reintentar'),
          ),
        ];
      case EstadoCripto.exito:
        return [for (final precio in _precios) _tarjeta(precio, monto)];
    }
  }

  @override
  Widget build(BuildContext context) {
    final monto = parsearMonto(_controlador.text);

    return Scaffold(
      appBar: AppBar(
        title: const Text('🪙 Criptomonedas'),
        actions: [
          IconButton(
            tooltip: 'Actualizar precios',
            icon: const Icon(Icons.refresh),
            onPressed: _estado == EstadoCripto.cargando ? null : _cargar,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _controlador,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
            ],
            decoration: const InputDecoration(
              labelText: 'Monto en USD',
              prefixText: '\$ ',
              border: OutlineInputBorder(),
            ),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 16),
          ..._contenido(monto),
        ],
      ),
    );
  }
}