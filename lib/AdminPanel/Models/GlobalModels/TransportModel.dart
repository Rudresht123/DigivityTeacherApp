class TransportModel{
  final int route_id;
  final String route_name;

  TransportModel({required this.route_id,required this.route_name});


  factory TransportModel.fromJson(Map<String,dynamic> json){
    return TransportModel(
    route_id: json['route_id'],
    route_name: json['route_name']
    );
  }

  @override
  String toString() {
    // TODO: implement toString
    return '{route_id:$route_id,route_name:$route_name}';
  }
}