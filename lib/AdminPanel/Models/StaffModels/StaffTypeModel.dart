class StaffTypeModel{
  final int id;
  final String value;
  StaffTypeModel({required this.id,required this.value});


  factory StaffTypeModel.fromJson(Map<String,dynamic> json){
    return StaffTypeModel(id: json['id'], value: json['value']);
  }

  @override
  String toString() {
    return '{id:$id,staff_type:$value}';
  }
}