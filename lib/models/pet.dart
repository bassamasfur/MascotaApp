import 'reminder.dart';
import 'medical_data.dart';

class Pet {
  final String id;
  final String name;
  final String species;
  final String breed; // raza
  final bool isPureBreed; // true = puro, false = mestizo
  final int age;
  final double weight;
  final DateTime? birthDate;
  final String gender;
  final String color;
  final String? microchip;
  final String? registrationNumber;
  final String imageUrl; // path o url de la foto
  final String description;
  final List<Reminder> reminders;
  final List<MedicalData> medicalData;

  Pet({
    required this.id,
    required this.name,
    required this.species,
    required this.breed,
    required this.isPureBreed,
    required this.age,
    required this.weight,
    this.birthDate,
    required this.gender,
    required this.color,
    this.microchip,
    this.registrationNumber,
    required this.imageUrl,
    required this.description,
    this.reminders = const [],
    this.medicalData = const [],
  });

  /// Constructor para crear una Pet desde JSON
  factory Pet.fromJson(Map<String, dynamic> json) {
    return Pet(
      id: json['id'] as String,
      name: json['name'] as String,
      species: json['species'] as String,
      breed: json['breed'] as String,
      isPureBreed: json['isPureBreed'] as bool,
      age: json['age'] as int,
      weight: (json['weight'] as num).toDouble(),
      birthDate: json['birthDate'] != null
          ? DateTime.parse(json['birthDate'])
          : null,
      gender: json['gender'] as String,
      color: json['color'] as String,
      microchip: json['microchip'] as String?,
      registrationNumber: json['registrationNumber'] as String?,
      imageUrl: json['imageUrl'] as String,
      description: json['description'] as String,
      reminders:
          (json['reminders'] as List<dynamic>?)
              ?.map((e) => Reminder.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      medicalData:
          (json['medicalData'] as List<dynamic>?)
              ?.map((e) => MedicalData.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  /// Convierte el modelo a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'species': species,
      'breed': breed,
      'isPureBreed': isPureBreed,
      'age': age,
      'weight': weight,
      'birthDate': birthDate?.toIso8601String(),
      'gender': gender,
      'color': color,
      'microchip': microchip,
      'registrationNumber': registrationNumber,
      'imageUrl': imageUrl,
      'description': description,
      'reminders': reminders.map((e) => e.toJson()).toList(),
      'medicalData': medicalData.map((e) => e.toJson()).toList(),
    };
  }

  /// Crea una copia de Pet con los campos especificados actualizados
  Pet copyWith({
    String? id,
    String? name,
    String? species,
    String? breed,
    bool? isPureBreed,
    int? age,
    double? weight,
    DateTime? birthDate,
    String? gender,
    String? color,
    String? microchip,
    String? registrationNumber,
    String? imageUrl,
    String? description,
    List<Reminder>? reminders,
    List<MedicalData>? medicalData,
  }) {
    return Pet(
      id: id ?? this.id,
      name: name ?? this.name,
      species: species ?? this.species,
      breed: breed ?? this.breed,
      isPureBreed: isPureBreed ?? this.isPureBreed,
      age: age ?? this.age,
      weight: weight ?? this.weight,
      birthDate: birthDate ?? this.birthDate,
      gender: gender ?? this.gender,
      color: color ?? this.color,
      microchip: microchip ?? this.microchip,
      registrationNumber: registrationNumber ?? this.registrationNumber,
      imageUrl: imageUrl ?? this.imageUrl,
      description: description ?? this.description,
      reminders: reminders ?? this.reminders,
      medicalData: medicalData ?? this.medicalData,
    );
  }

  @override
  String toString() {
    return 'Pet(id: $id, name: $name, species: $species, breed: $breed, age: $age, weight: $weight)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Pet && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
