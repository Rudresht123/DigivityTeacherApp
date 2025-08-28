class CourseDocStatus {
  final int courseId;
  final String course;
  final int totalStudent;
  final int totalDoument;
  final int totalUploadedDoument;
  final int totalStudentDocNotUploaded;

  CourseDocStatus({
    required this.courseId,
    required this.course,
    required this.totalStudent,
    required this.totalDoument,
    required this.totalUploadedDoument,
    required this.totalStudentDocNotUploaded,
  });

  factory CourseDocStatus.fromJson(Map<String, dynamic> json) {
    return CourseDocStatus(
      courseId: json['course_id'],
      course: json['course'],
      totalStudent: json['total_student'],
      totalDoument: json['total_doument'],
      totalUploadedDoument:json['total_uploaded_doument'],
      totalStudentDocNotUploaded: json['total_student_doc_not_uploaded'],
    );
  }
}
