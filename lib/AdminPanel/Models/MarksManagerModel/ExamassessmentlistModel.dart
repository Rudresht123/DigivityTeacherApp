class ExamassessmentlistModel{
  final int examasssememntId;
  final String examassessment;

  ExamassessmentlistModel({required this.examasssememntId,required this.examassessment});


  factory ExamassessmentlistModel.fromJson(Map<String, dynamic> json) {
    return ExamassessmentlistModel(
      examasssememntId: json['key'] ?? '',
      examassessment: json['value'] ?? '',
    );
  }

  @override
  String toString() {
    return '{examtypeId:$examasssememntId,examType:$examassessment}';
  }
}