class AssignedTransportRouteModel {
  final int id;
  final String routeName;
  final int routeId;

  AssignedTransportRouteModel({
    required this.id,
    required this.routeName,
    required this.routeId,
  });

  factory AssignedTransportRouteModel.fromJson(Map<String, dynamic> json) {
    return AssignedTransportRouteModel(
      id: json['id'],
      routeName: json["route_name"],
      routeId: json['route_id'],
    );
  }
}
