class MaritalStatus{
  final String id;
  final String value;

  MaritalStatus({required this.id,required this.value});

  factory MaritalStatus.fromJson(Map<String,dynamic> json){
    return MaritalStatus(id: json['id'], value: json['value']);
  }


  @override
  String toString() {
    return '{id:$id,maritalstatus:$value}';
  }
}