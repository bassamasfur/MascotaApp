class Breed {
  final String nombre;
  final String especie;
  final Map<String, String> caracteristicas;
  final List<String> temperamento;
  final List<String> cuidados;
  final List<String> salud;
  final List<String> curiosidades;
  final String imagenUrl;
  final String? descripcion;

  Breed({
    required this.nombre,
    required this.especie,
    required this.caracteristicas,
    required this.temperamento,
    required this.cuidados,
    required this.salud,
    required this.curiosidades,
    required this.imagenUrl,
    this.descripcion,
  });

  factory Breed.fromJson(Map<String, dynamic> json) {
    return Breed(
      nombre: json['nombre'] ?? '',
      especie: json['especie'] ?? '',
      caracteristicas: Map<String, String>.from(json['caracteristicas'] ?? {}),
      temperamento: List<String>.from(json['temperamento'] ?? []),
      cuidados: List<String>.from(json['cuidados'] ?? []),
      salud: List<String>.from(json['salud'] ?? []),
      curiosidades: List<String>.from(json['curiosidades'] ?? []),
      imagenUrl: json['imagen_url'] ?? '',
      descripcion: json['descripcion'],
    );
  }
}
