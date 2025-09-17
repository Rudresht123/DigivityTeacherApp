class RouteStopModel {
  final int stopId;
  final String stopName;

  RouteStopModel({required this.stopId, required this.stopName});

  factory RouteStopModel.fromJson(Map<String, dynamic> json) {
    return RouteStopModel(stopId: json['id'], stopName: json['route_name']);
  }
}
