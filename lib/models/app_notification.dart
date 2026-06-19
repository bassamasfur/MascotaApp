class AppNotification {
  final int id;
  final String title;
  final String body;
  final DateTime receivedAt;

  const AppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.receivedAt,
  });

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      id: json['id'] as int,
      title: json['title'] as String? ?? 'Notificación',
      body: json['body'] as String? ?? '',
      receivedAt: DateTime.parse(json['receivedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'receivedAt': receivedAt.toIso8601String(),
    };
  }
}
