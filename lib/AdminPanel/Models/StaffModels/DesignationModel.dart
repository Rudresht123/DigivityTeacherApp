class Designationmodel{
  final int id;
  final String value;

  Designationmodel({required this.id,required this.value});

  factory Designationmodel.fromJson(Map<String,dynamic> json){
    return Designationmodel(id: json['id'], value: json['value']);
  }

  @override
  String toString() {
    return '{id:$id,designation:$value}';
  }
}