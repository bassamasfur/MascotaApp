/// Modelo para recordatorios de mascota
class Reminder {
  final String id;
  final String title;
  final DateTime date;
  final String? notes;

  Reminder({
    required this.id,
    required this.title,
    required this.date,
    this.notes,
  });

  factory Reminder.fromJson(Map<String, dynamic> json) {
    return Reminder(
      id: json['id'] as String,
      title: json['title'] as String,
      date: DateTime.parse(json['date'] as String),
      notes: json['notes'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'date': date.toIso8601String(),
      'notes': notes,
    };
  }
}
