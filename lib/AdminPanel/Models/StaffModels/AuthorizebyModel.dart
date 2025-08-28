class AuthorizebyModel{
  final int id;
  final String value;

  AuthorizebyModel({ required this.id,required this.value});

  factory AuthorizebyModel.fromJson(Map<String,dynamic> json){
    return AuthorizebyModel(id: json['id'], value: json['value']);
  }



  @override
  String toString() {
    return '{id:$id,authorizeby:$value}';
  }
}