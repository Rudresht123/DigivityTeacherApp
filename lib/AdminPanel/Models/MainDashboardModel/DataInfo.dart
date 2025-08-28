class DataInfo {
  final String key;
  final dynamic value; // because value can be String or List

  DataInfo({required this.key, required this.value});

  factory DataInfo.fromJson(Map<String, dynamic> json) {
    return DataInfo(
      key: json['key'] ?? '',
      value: json['value'] ?? '', // custom handling may be needed
    );
  }
}
