class CourseList{
  final String Id;
  final String value;

  CourseList({required this.value,required this.Id});


  factory CourseList.fromJson(Map<String,dynamic> json){
    return CourseList(value: json['value'], Id: json['id']);
  }


  @override
  String toString() {
    return '{Id:$Id,value:$value}';
  }
}