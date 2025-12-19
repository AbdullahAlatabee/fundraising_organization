class Donor {
  final int? id;
  final String fullName;
  final String phone;
  final String? address;
  final String? notes;
  final int createdBy;
  final String createdAt;

  Donor({
    this.id,
    required this.fullName,
    required this.phone,
    this.address,
    this.notes,
    required this.createdBy,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'full_name': fullName,
      'phone': phone,
      'address': address,
      'notes': notes,
      'created_by': createdBy,
      'created_at': createdAt,
    };
  }

  factory Donor.fromMap(Map<String, dynamic> map) {
    return Donor(
      id: map['id'],
      fullName: map['full_name'],
      phone: map['phone'],
      address: map['address'],
      notes: map['notes'],
      createdBy: map['created_by'],
      createdAt: map['created_at'],
    );
  }
}
