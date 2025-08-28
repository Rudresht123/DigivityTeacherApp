class Attachment {
  final String fileName;
  final String filePath;
  final String extension;

  Attachment({
    required this.fileName,
    required this.filePath,
    required this.extension,
  });

  factory Attachment.fromJson(Map<String, dynamic> json) {
    return Attachment(
      fileName: json['file_name'],
      filePath: json['file_path'],
      extension: json['extension'],
    );
  }
}