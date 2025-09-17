class OnlineClassDetails {
  final int id;
  final String courseId;
  final int subjectId;
  final int staffId;
  final String className;
  final String subjectName;
  final String staffName;
  final String onlineClassTiming;
  final String onlineClassLink;
  final String periodTime; // API sends string

  OnlineClassDetails({
    required this.id,
    required this.courseId,
    required this.subjectId,
    required this.staffId,
    required this.className,
    required this.subjectName,
    required this.staffName,
    required this.onlineClassTiming,
    required this.onlineClassLink,
    required this.periodTime,
  });

  factory OnlineClassDetails.fromJson(Map<String, dynamic> json) {
    return OnlineClassDetails(
      id: json['id'] ?? 0,
      courseId: json['course_id']?.toString() ?? '',
      subjectId: json['subject_id'] ?? 0,
      staffId: json['staff_id'] ?? 0,
      className: json['class_name'] ?? '',
      subjectName: json['subject_name'] ?? '',
      staffName: json['staff_name'] ?? '',
      onlineClassTiming: json['online_class_timings'] ?? '',
      onlineClassLink: json['online_class_links'] ?? '',
      periodTime: json['period_time']?.toString() ?? '',
    );
  }
}
