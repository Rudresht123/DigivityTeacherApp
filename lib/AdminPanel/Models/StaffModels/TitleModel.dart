class TitleModel{
  final String id;
  final String value;


  TitleModel({required this.id,required this.value});

  factory TitleModel.fromJson(Map<String,dynamic> json){
    return TitleModel(id: json['id'], value: json['value']);
  }

  @override
  String toString() {
    return '{id:$id,title:$value}';
  }
}