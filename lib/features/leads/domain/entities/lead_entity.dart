class LeadEntity {
  final String? id;
  final String title;
  final String description;
  final String? status;
  final String? userId;
  final String? rejectionNotes;

  const LeadEntity({
    this.id,
    required this.title,
    required this.description,
    this.status,
    this.userId,
    this.rejectionNotes,
  });
}
