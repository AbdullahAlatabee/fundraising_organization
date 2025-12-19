class DonationCase {
  final int? id;
  final String title;
  final String description;
  final double targetAmount;
  final double collectedAmount;
  final String status; // 'open', 'completed'
  final String? imagePath;
  final int createdBy;
  final String createdAt;

  DonationCase({
    this.id,
    required this.title,
    required this.description,
    required this.targetAmount,
    this.collectedAmount = 0.0,
    required this.status,
    this.imagePath,
    required this.createdBy,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'target_amount': targetAmount,
      'collected_amount': collectedAmount,
      'status': status,
      'image_path': imagePath,
      'created_by': createdBy,
      'created_at': createdAt,
    };
  }

  factory DonationCase.fromMap(Map<String, dynamic> map) {
    return DonationCase(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      targetAmount: map['target_amount'],
      collectedAmount: map['collected_amount'],
      status: map['status'],
      imagePath: map['image_path'],
      createdBy: map['created_by'],
      createdAt: map['created_at'],
    );
  }
}
