import '../../domain/entities/lead_entity.dart';

class LeadModel extends LeadEntity {
  const LeadModel({
    super.id,
    required super.title,
    required super.description,
    super.status,
    super.userId,
    super.rejectionNotes,
  });

  factory LeadModel.fromJson(Map<String, dynamic> json) {
    return LeadModel(
      id: json['_id'],
      title: json['title'],
      description: json['description'],
      status: json['status'],
      userId: json['user_id'],
      rejectionNotes: json['rejectionNotes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
    };
  }

  factory LeadModel.fromEntity(LeadEntity entity) {
    return LeadModel(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      status: entity.status,
      userId: entity.userId,
      rejectionNotes: entity.rejectionNotes,
    );
  }
  LeadEntity toEntity() {
    return LeadEntity(
      id: id,
      title: title,
      description: description,
      status: status,
      userId: userId,
      rejectionNotes: rejectionNotes,
    );
  }
}
