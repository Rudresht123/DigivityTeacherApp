class StudentDocumentUpload {
  final int studentId;
  final int id;
  final int documentId;
  final String documentName;
  final String documentFile;

  StudentDocumentUpload({
    required this.studentId,
    required this.id,
    required this.documentId,
    required this.documentName,
    required this.documentFile,
  });

  factory StudentDocumentUpload.fromJson(Map<String, dynamic> json) {
    return StudentDocumentUpload(
      studentId: json['student_id'] ?? '',
      id: json['id'] ?? 0,
      documentId: json['document_id'] ?? 0,
      documentName: json['document_name'] ?? '',
      documentFile: json['document_file'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'student_id': studentId,
      'id': id,
      'document_id': documentId,
      'document_name': documentName,
      'document_file': documentFile,
    };
  }
}
