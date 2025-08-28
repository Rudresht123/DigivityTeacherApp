class SubjectModel {
  final int id;
  final String subject;

  SubjectModel({required this.id, required this.subject});

  factory SubjectModel.fromJson(Map<String, dynamic> json) {
    return SubjectModel(
      id: json['id'],
      subject: json['subject'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'subject': subject,
    };
  }

  @override
  String toString() {
    return 'SubjectModel(id: $id, subject: $subject)';
  }
}
