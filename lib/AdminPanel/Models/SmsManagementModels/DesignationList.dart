class DesignationList{
  final int Id;
  final String value;

  DesignationList({required this.Id,required this.value});


  factory DesignationList.fromJson(Map<String,dynamic> json){
    return DesignationList(Id: json['id'], value: json['value']);
  }



  @override
  String toString() {
    return '{Id:$Id,value:$value}';
  }
}