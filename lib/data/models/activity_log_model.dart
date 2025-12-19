class ActivityLog {
  final int? id;
  final int userId;
  final String action;
  final String entity;
  final String timestamp;

  ActivityLog({
    this.id,
    required this.userId,
    required this.action,
    required this.entity,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'action': action,
      'entity': entity,
      'timestamp': timestamp,
    };
  }

  factory ActivityLog.fromMap(Map<String, dynamic> map) {
    return ActivityLog(
      id: map['id'],
      userId: map['user_id'],
      action: map['action'],
      entity: map['entity'],
      timestamp: map['timestamp'],
    );
  }
}
