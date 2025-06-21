class Task {
  final String id;
  final String userId;
  final String title;
  final String description;
  late bool status;
  final DateTime createdAt;
  final DateTime ddate;

  Task({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.status,
    required this.createdAt,
    required this.ddate,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['_id'],
      userId: json['userId'],
      title: json['title'],
      description: json['description'],
      status: json['status'],
      createdAt: DateTime.parse(json['createdAt']),
      ddate: DateTime.parse(json['ddate']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userId': userId,
      'title': title,
      'description': description,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'ddate': ddate.toIso8601String(),
    };
  }
}
