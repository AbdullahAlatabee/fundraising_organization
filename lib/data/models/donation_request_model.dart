class DonationRequest {
  final int? id;
  final String name;
  final String phone;
  final String description;
  final String? imagePath;
  final double? latitude;
  final double? longitude;
  final String status; // 'pending', 'approved', 'rejected'
  final String createdAt;

  DonationRequest({
    this.id,
    required this.name,
    required this.phone,
    required this.description,
    this.imagePath,
    this.latitude,
    this.longitude,
    required this.status,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'description': description,
      'image_path': imagePath,
      'latitude': latitude,
      'longitude': longitude,
      'status': status,
      'created_at': createdAt,
    };
  }

  factory DonationRequest.fromMap(Map<String, dynamic> map) {
    return DonationRequest(
      id: map['id'],
      name: map['name'],
      phone: map['phone'],
      description: map['description'],
      imagePath: map['image_path'],
      latitude: map['latitude'],
      longitude: map['longitude'],
      status: map['status'],
      createdAt: map['created_at'],
    );
  }
}
