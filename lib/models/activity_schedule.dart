class ActivitySchedule {
  final String id;
  final DateTime time;
  final int? quantity;
  final String? details;
  final bool notification;

  ActivitySchedule({
    required this.id,
    required this.time,
    this.quantity,
    this.details,
    this.notification = true,
  });

  factory ActivitySchedule.fromJson(Map<String, dynamic> json) =>
      ActivitySchedule(
        id: json['id'] as String,
        time: DateTime.parse(json['time'] as String),
        quantity: json['quantity'] as int?,
        details: json['details'] as String?,
        notification: json['notification'] ?? true,
      );

  Map<String, dynamic> toJson() => {
    'id': id,
    'time': time.toIso8601String(),
    'quantity': quantity,
    'details': details,
    'notification': notification,
  };
}
