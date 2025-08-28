import 'package:digivity_admin_app/AdminPanel/Components/ReportCardBox.dart';
import 'package:digivity_admin_app/Components/BackgrounWeapper.dart';
import 'package:digivity_admin_app/Components/SimpleAppBar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CommunicationIndex extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
   return Scaffold(
     appBar: PreferredSize(preferredSize: Size.fromHeight(kToolbarHeight), child: SimpleAppBar(titleText: 'Send SMS To Users', routeName: 'back')),
     body: BackgroundWrapper(child: Container(
       padding: EdgeInsets.symmetric(vertical: 20,horizontal: 10),
       child: Column(
         children: [
           ReportCardBox(icon: Icons.message, title: 'Compose SMS', onTap: (){
             context.pushNamed('list-for-compose-sms');
           })
         ],
       ),
     )),
   );
  }

}