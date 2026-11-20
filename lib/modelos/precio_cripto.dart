enum Cripto {
  bitcoin('bitcoin', 'Bitcoin', 'BTC'),
  ethereum('ethereum', 'Ethereum', 'ETH'),
  solana('solana', 'Solana', 'SOL');

  final String id;
  final String nombre;
  final String simbolo;

  const Cripto(this.id, this.nombre, this.simbolo);
}

class PrecioCripto {
  final Cripto cripto;
  final double precioUsd;

  const PrecioCripto({required this.cripto, required this.precioUsd});

  /// Cuántas fracciones de la moneda se compran con [montoUsd] dólares.
  double cantidadPara(double montoUsd) {
    if (precioUsd <= 0) return 0;
    return montoUsd / precioUsd;
  }
}

/// 1234567.891 -> "$1,234,567.89"
String formatearUsd(double valor) {
  final partes = valor.toStringAsFixed(2).split('.');
  final entero = partes[0]
      .replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (_) => ',');
  return '\$$entero.${partes[1]}';
}

/// Las criptos se compran en fracciones muy pequeñas, por eso 8 decimales.
String formatearCantidad(double cantidad) => cantidad.toStringAsFixed(8);

/// Convierte lo que escribe el usuario en un número. Devuelve null si el
/// texto está vacío, no es un número o es cero.
double? parsearMonto(String texto) {
  final valor = double.tryParse(texto.trim());
  if (valor == null || valor <= 0) return null;
  return valor;
}