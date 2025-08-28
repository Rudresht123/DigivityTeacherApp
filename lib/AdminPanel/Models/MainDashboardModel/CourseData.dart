class CourseData {
  final String keyid;
  final String value;
  final int? count;

  CourseData({required this.keyid, required this.value,this.count});

  factory CourseData.fromJson(Map<String, dynamic> json) {
    return CourseData(
      keyid: json['keyid'] ?? '',
      value: json['value'] ?? '',
      count:json['count'] ?? 0
    );
  }
}
