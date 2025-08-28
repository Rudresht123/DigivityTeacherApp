class Professiontypemodel{
  final int id;
  final String value;

  Professiontypemodel({required this.id,required this.value});

  factory Professiontypemodel.fromJson(Map<String,dynamic> json){
    return Professiontypemodel(id: json['id'], value: json['value']);
  }

  @override
  String toString(){
    return '{id:$id;profession_type:$value}';
  }

}