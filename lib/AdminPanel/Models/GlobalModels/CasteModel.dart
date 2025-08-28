class CasteModel{
  final int caste_id;
  final String caste;

  CasteModel({
    required this.caste_id,
    required this.caste
  });
  factory CasteModel.fromJson(Map<String,dynamic> json){
    return CasteModel(
      caste_id:json['caste_id'],
      caste:json['caste']
    );
  }

  @override
  String toString() {
    return '{caste_id:$caste_id,caste:$caste}';
  }
}