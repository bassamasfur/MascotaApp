/// Modelo para datos médicos de mascota
class MedicalData {
  final String id;
  final String type; // Ej: 'Vacuna', 'Medicación', 'Visita'
  final String name;
  final DateTime date;
  final String? notes;

  MedicalData({
    required this.id,
    required this.type,
    required this.name,
    required this.date,
    this.notes,
  });

  factory MedicalData.fromJson(Map<String, dynamic> json) {
    return MedicalData(
      id: json['id'] as String,
      type: json['type'] as String,
      name: json['name'] as String,
      date: DateTime.parse(json['date'] as String),
      notes: json['notes'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'name': name,
      'date': date.toIso8601String(),
      'notes': notes,
    };
  }
}
