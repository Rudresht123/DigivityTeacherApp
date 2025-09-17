import 'package:digivity_admin_app/AdminPanel/Models/TransportAttendanceModels/AssignedTransportRouteModel.dart';
import 'package:digivity_admin_app/AdminPanel/Models/TransportAttendanceModels/RouteStopModel.dart';
import 'package:digivity_admin_app/AuthenticationUi/Loader.dart';
import 'package:digivity_admin_app/Components/ApiMessageWidget.dart';
import 'package:digivity_admin_app/Components/BackgrounWeapper.dart';
import 'package:digivity_admin_app/Components/CardContainer.dart';
import 'package:digivity_admin_app/Components/CustomBlueButton.dart';
import 'package:digivity_admin_app/Components/CustomDropdown.dart';
import 'package:digivity_admin_app/Components/DatePickerField.dart';
import 'package:digivity_admin_app/Components/SimpleAppBar.dart';
import 'package:digivity_admin_app/Helpers/TransportAttendanceHelper/TransportAttendanceHelper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class FilterStudentStopwise extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _FilterStudentStopwise();
  }
}

class _FilterStudentStopwise extends State<FilterStudentStopwise> {
  List<AssignedTransportRouteModel> routes = [];
  List<RouteStopModel> routesstops = [];
  TextEditingController _attendacedate = TextEditingController();
  int? routeId;
  int? routeStopId;
  String? routeStopName;
  String? routename;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getAssignedRoute();
    });
  }

  void _getAssignedRoute() async {
    showLoaderDialog(context);
    try {
      final response = await TransportAttendanceHelper().getAssignedRoute();
      routes = response;
      print(routes);
      setState(() {});
    } catch (e) {
      showBottomMessage(context, "${e}", true);
    } finally {
      hideLoaderDialog(context);
    }
  }

  void _getRouteStops(int routeId) async {
    showLoaderDialog(context);
    try {
      final routestops1 = await TransportAttendanceHelper().getRouteStop(
        routeId,
      );
      setState(() {
        routesstops = routestops1;
      });
    } catch (e) {
      showBottomMessage(context, "$e", true);
    } finally {
      hideLoaderDialog(context);
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: SimpleAppBar(
          titleText: "Transport Attendance",
          routeName: "back",
        ),
      ),
      body: BackgroundWrapper(
        child: Column(
          children: [
            CardContainer(
              child: Column(
                children: [
                  /// Route Dropdown
                  CustomDropdown(
                    selectedValue: routeId,
                    items: routes.map((e) {
                      return {"valueKey": e.routeId, "displayKey": e.routeName};
                    }).toList(),
                    displayKey: "displayKey",
                    valueKey: "valueKey",
                    onChanged: (value) {
                      if (value != null) {
                        routeId = value;
                        final selected = routes.firstWhere(
                          (e) => e.routeId == value,
                        );
                        routename = selected.routeName;
                        _getRouteStops(value);
                      }
                    },
                    hint: "Select Route",
                  ),

                  SizedBox(height: 20),

                  CustomDropdown(
                    selectedValue: routeStopId,
                    items: routesstops.map((e) {
                      return {"valueKey": e.stopId, "displayKey": e.stopName};
                    }).toList(),
                    displayKey: "displayKey",
                    valueKey: "valueKey",
                    onChanged: (value) {
                      if (value != null) {
                        final selectedStop = routesstops.firstWhere(
                          (e) => e.stopId == value,
                        );
                        setState(() {
                          routeStopId = value;
                          routeStopName = selectedStop.stopName;
                        });
                      }
                    },
                    hint: "Select Route Stop",
                  ),

                  SizedBox(height: 20),

                  DatePickerField(
                    controller: _attendacedate,
                    label: "Attendance Date",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: CustomBlueButton(
          text: "Search Student",
          icon: Icons.search,
          onPressed: () {
            if (routeId == null) {
              showBottomMessage(context, "Please Select First Route", true);
            } else if (routeStopId == null) {
              showBottomMessage(
                context,
                "Please Select First Route Stop",
                true,
              );
            } else {
              try {
                context.pushNamed(
                  "mark-transport-attendance",
                  extra: {
                    "routeId": routeId,
                    "routeStopId": routeStopId,
                    "attendanceDate": _attendacedate.text,
                    "routeStopName":routeStopName,
                    "routename":routename,
                  },
                );
              } catch (e) {
                showBottomMessage(context, "${e}", true);
              }
            }
            // mark-transport-attendance
          },
        ),
      ),
    );
  }
}
