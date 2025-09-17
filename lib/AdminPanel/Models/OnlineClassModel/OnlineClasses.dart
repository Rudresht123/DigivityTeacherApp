import 'package:digivity_admin_app/AdminPanel/Models/OnlineClassModel/OnlineClassDetails.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OnlineClasses {
  final int id;
  final String className;
  final String onlineClassTitle;
  final String? onlineClassNotes;
  List<OnlineClassDetails>? onlineClassDetails;

  OnlineClasses({
    required this.id,
    required this.className,
    required this.onlineClassTitle,
    this.onlineClassNotes,
    this.onlineClassDetails,
  });

  factory OnlineClasses.fromJson(Map<String, dynamic> json) {
    final onlineClass = (json['onlineclass'] as List).isNotEmpty
        ? json['onlineclass'][0]
        : null;
    return OnlineClasses(
      id: onlineClass?['id'] ?? 0,
      className: onlineClass?['class_name'] ?? '',
      onlineClassTitle: onlineClass?['online_class_title'] ?? '',
      onlineClassNotes: onlineClass?['online_class_notes'],
      onlineClassDetails: json['onlineclassdetails'] != null
          ? (json['onlineclassdetails'] as List)
                .map((e) => OnlineClassDetails.fromJson(e))
                .toList()
          : [],
    );
  }
}
