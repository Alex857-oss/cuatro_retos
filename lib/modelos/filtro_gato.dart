enum FiltroGato {
  ninguno('Ninguno', null),
  mono('Blanco y negro', 'mono'),
  negativo('Negativo', 'negate');

  final String nombre;
  final String? valorApi;

  const FiltroGato(this.nombre, this.valorApi);
}