class CourseModel{
  final String courseId;
  final String Course;

  CourseModel({required this.courseId,required this.Course});


  factory CourseModel.fromJson(Map<String, dynamic> json) {
    return CourseModel(
      courseId: json['key'] ?? '',
      Course: json['value'] ?? '',
    );
  }

  @override
  String toString() {
    return '{courseId:$courseId,Course:$Course}';
  }
}