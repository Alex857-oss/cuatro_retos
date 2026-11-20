enum EstadoAnimo {
  feliz('Feliz', '😄', 35),
  triste('Triste', '😢', 18),
  emocionado('Emocionado', '🤩', 28),
  romantico('Romántico', '💕', 10749),
  miedo('Con ganas de miedo', '😱', 27),
  sorprendeme('Sorpréndeme', '🎲', null);

  final String nombre;
  final String emoji;
  final int? generoId;

  const EstadoAnimo(this.nombre, this.emoji, this.generoId);
}