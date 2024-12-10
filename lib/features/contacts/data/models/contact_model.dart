import '../../domain/entities/contact_entity.dart';

class ContactModel extends ContactEntity {
  ContactModel({
    super.id,
    required super.name,
    required super.phone,
    super.address,
    super.role,
  });

  factory ContactModel.fromJson(Map<String, dynamic> json) {
    return ContactModel(
      id: json['_id'],
      name: json['name'],
      phone: json['phone'],
      address: json['address'],
      role: json['role'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phone': phone,
      'address': address,
      'role': role,
    };
  }

  factory ContactModel.fromEntity(ContactEntity entity) {
    return ContactModel(
      name: entity.name,
      phone: entity.phone,
      address: entity.address,
      role: entity.role,
    );
  }
  ContactEntity toEntity() {
    return ContactEntity(
      id: id,
      name: name,
      phone: phone,
      address: address,
      role: role,
    );
  }
}
