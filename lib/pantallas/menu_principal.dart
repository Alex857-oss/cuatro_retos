import 'package:flutter/material.dart';

import '../servicios/clima_servicio.dart';
import '../servicios/cripto_servicio.dart';
import '../servicios/tmdb_servicio.dart';
import 'clima_pantalla.dart';
import 'cripto_pantalla.dart';
import 'gatos_pantalla.dart';
import 'inicio_pantalla.dart';

class MenuPrincipal extends StatefulWidget {
  final TmdbServicio tmdbServicio;
  final ClimaServicio climaServicio;
  final CriptoServicio criptoServicio;

  const MenuPrincipal({
    super.key,
    required this.tmdbServicio,
    required this.climaServicio,
    required this.criptoServicio,
  });

  @override
  State<MenuPrincipal> createState() => _MenuPrincipalState();
}

class _MenuPrincipalState extends State<MenuPrincipal> {
  int _indice = 0;

  @override
  Widget build(BuildContext context) {
    final pantallas = <Widget>[
      InicioPantalla(servicio: widget.tmdbServicio),
      const GatosPantalla(),
      ClimaPantalla(servicio: widget.climaServicio),
      CriptoPantalla(servicio: widget.criptoServicio),
    ];

    return Scaffold(
      body: IndexedStack(index: _indice, children: pantallas),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _indice,
        onDestinationSelected: (i) => setState(() => _indice = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.movie), label: 'Películas'),
          NavigationDestination(icon: Icon(Icons.pets), label: 'Gatos'),
          NavigationDestination(icon: Icon(Icons.cloud), label: 'Clima'),
          NavigationDestination(
              icon: Icon(Icons.currency_bitcoin), label: 'Cripto'),
        ],
      ),
    );
  }
}