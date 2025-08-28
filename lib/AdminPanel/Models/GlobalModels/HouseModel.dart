import 'dart:convert';

class HouseModel{
  final int id;
  final String house;
  HouseModel({required this.id,required this.house});

  factory HouseModel.fromJson(Map<String, dynamic> json) {
    return HouseModel(
      id: json['id'],
      house: json['house'],
    );
  }

  @override
  String toString(){
    return '{id:$id;house:$house}';
  }
}