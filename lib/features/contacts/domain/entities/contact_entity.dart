class ContactEntity {
  final String? id;
  final String name;
  final String phone;
  final String? address;
  final String? relationship;

  ContactEntity({
    this.id,
    required this.name,
    required this.phone,
    this.address,
    this.relationship,
  });
}
