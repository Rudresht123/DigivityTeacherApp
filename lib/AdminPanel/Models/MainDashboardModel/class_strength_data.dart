class ClassStrengthData {
  final int maleCount;
  final int femaleCount;
  final String course;

  ClassStrengthData({
    required this.maleCount,
    required this.femaleCount,
    required this.course,
  });

  factory ClassStrengthData.fromJson(Map<String, dynamic> json) {
    return ClassStrengthData(
      maleCount: json['male_count'],
      femaleCount: json['female_count'],
      course: json['course']['course'], // <- this returns String directly
    );
  }
}
