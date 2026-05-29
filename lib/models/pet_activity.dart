import 'activity_type.dart';
import 'activity_schedule.dart';

class PetActivity {
  final String id;
  final ActivityType type;
  final List<ActivitySchedule> schedules;
  final String? notes;
  final bool enabled;

  PetActivity({
    required this.id,
    required this.type,
    required this.schedules,
    this.notes,
    this.enabled = true,
  });

  factory PetActivity.fromJson(Map<String, dynamic> json) => PetActivity(
    id: json['id'] as String,
    type: ActivityType.values.firstWhere((e) => e.toString() == json['type']),
    schedules: (json['schedules'] as List<dynamic>)
        .map((e) => ActivitySchedule.fromJson(e as Map<String, dynamic>))
        .toList(),
    notes: json['notes'] as String?,
    enabled: json['enabled'] ?? true,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type.toString(),
    'schedules': schedules.map((e) => e.toJson()).toList(),
    'notes': notes,
    'enabled': enabled,
  };
}
