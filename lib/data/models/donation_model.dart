class Donation {
  final int? id;
  final int donorId;
  final int caseId;
  final double amount;
  final String donationType; // 'cash', 'in-kind'
  final String donationDate;
  final int addedBy;

  Donation({
    this.id,
    required this.donorId,
    required this.caseId,
    required this.amount,
    required this.donationType,
    required this.donationDate,
    required this.addedBy,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'donor_id': donorId,
      'case_id': caseId,
      'amount': amount,
      'donation_type': donationType,
      'donation_date': donationDate,
      'added_by': addedBy,
    };
  }

  factory Donation.fromMap(Map<String, dynamic> map) {
    return Donation(
      id: map['id'],
      donorId: map['donor_id'],
      caseId: map['case_id'],
      amount: map['amount'],
      donationType: map['donation_type'],
      donationDate: map['donation_date'],
      addedBy: map['added_by'],
    );
  }
}
