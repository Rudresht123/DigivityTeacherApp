class StudentTypeModel{
  final int type_id;
  final String type_name;

  StudentTypeModel({ required this.type_id,required this.type_name});

  factory StudentTypeModel.fromJson(Map<String,dynamic> json){
    return StudentTypeModel(
        type_id: json['type_id'],
        type_name: json['type_name']
    );
  }

  @override
  String toString() {
    // TODO: implement toString
    return '{type_id:$type_id,type_name:$type_name}';
  }
}