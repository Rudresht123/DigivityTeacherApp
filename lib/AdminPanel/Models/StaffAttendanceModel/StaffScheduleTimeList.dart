class StaffScheduleTimeList{

  final int id;
  final String designation;
  final String arrivalTime;
  final String departureTime;
  final int lateAllowed;
  final int punchinDisable;
  final String? latitude;
  final String? longitude;
  final String? radius;

  StaffScheduleTimeList({ required this.id,required this.designation,required this.arrivalTime,required this.departureTime,required this.lateAllowed,required this.punchinDisable,this.longitude,this.latitude,this.radius});

  factory StaffScheduleTimeList.fromJson(Map<String,dynamic> json){
    return StaffScheduleTimeList(
        id: json['id'],
        designation: json['designation'],
        arrivalTime: json['arrival_time'],
        departureTime: json['departure_time'],
        lateAllowed: json['late_allowed'],
        punchinDisable: json['punchin_disable'],
        latitude:json['latitude'],
        longitude:json['longitude'],
        radius : json['radius']
    );
  }
}