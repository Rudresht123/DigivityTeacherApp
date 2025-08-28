import 'package:digivity_admin_app/Components/BackgrounWeapper.dart';
import 'package:digivity_admin_app/Components/SimpleAppBar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ComposeSms extends StatefulWidget{
final List<String>? selectedCourses;
final List<int>? selectedDesignations;
final List<int>? selectedAdminstration;

ComposeSms({this.selectedCourses,this.selectedDesignations,this.selectedAdminstration});

  @override
  State<StatefulWidget> createState() {
    return _ComposeSms();
  }
}


class _ComposeSms extends State<ComposeSms>{
  @override
  Widget build(BuildContext context) {
   return Scaffold(
     appBar: PreferredSize(preferredSize: Size.fromHeight(kToolbarHeight), child: SimpleAppBar(titleText: 'Compose SMS', routeName: 'back')),
     body: BackgroundWrapper(child: Column(
     //   Top Bar for show the Recevers

     )),
   );
  }
}