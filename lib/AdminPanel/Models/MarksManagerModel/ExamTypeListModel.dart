class ExamTypeListModel{
  final int examtypeId;
  final String examType;

  ExamTypeListModel({required this.examType,required this.examtypeId});


  factory ExamTypeListModel.fromJson(Map<String, dynamic> json) {
    return ExamTypeListModel(
      examtypeId: json['key'] ?? '',
      examType: json['value'] ?? '',
    );
  }

  @override
  String toString() {
    return '{examtypeId:$examtypeId,examType:$examType}';
  }
}