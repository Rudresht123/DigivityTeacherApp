class ClasswiseTotalConductedPtmModel {
  final String key;
  final String value;
  final String classTotalPtm;

  ClasswiseTotalConductedPtmModel({
    required this.key,
    required this.value,
    required this.classTotalPtm,
  });

  factory ClasswiseTotalConductedPtmModel.fromJson(Map<String, dynamic> json) {
    return ClasswiseTotalConductedPtmModel(
      key: json['key']?.toString() ?? '',
      value: json['value']?.toString() ?? '',
      classTotalPtm: json['class_total_ptm']?.toString() ?? '',
    );
  }


}
