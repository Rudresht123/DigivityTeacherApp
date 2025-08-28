class DepartmentModel{
  final int id;
  final String value;

  DepartmentModel({required this.id,required this.value});

  factory DepartmentModel.fromJson(Map<String,dynamic> json){
    return DepartmentModel(id: json['id'], value: json['value']);
  }

  @override
  String toString() {
    return '{id:$id,department:$value}';
  }
}