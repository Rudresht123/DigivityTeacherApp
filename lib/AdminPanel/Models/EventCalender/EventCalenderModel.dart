class EventCalenderModel {
  final int id;
  final String title;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final String backgroundColor;
  final String textColor;
  final String isHoliday;
  final String publishedForStudent;
  final String publishedForTeacher;

  EventCalenderModel({
    required this.id,
    required this.title,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.backgroundColor,
    required this.textColor,
    required this.isHoliday,
    required this.publishedForStudent,
    required this.publishedForTeacher,
  });

  // Factory constructor to create an instance from JSON
  factory EventCalenderModel.fromJson(Map<String, dynamic> json) {
    return EventCalenderModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      startDate: DateTime.parse(json['start_date']),
      endDate: DateTime.parse(json['end_date']),
      backgroundColor: json['background_color'] ?? '#000000',
      textColor: json['text_color'] ?? '#ffffff',
      isHoliday: json['is_holiday'] ?? 'no',
      publishedForStudent: json['published_for_student'] ?? 'no',
      publishedForTeacher: json['published_for_teacher'] ?? 'no',
    );
  }
  
}
