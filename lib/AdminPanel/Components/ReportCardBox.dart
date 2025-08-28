import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ReportCardBox extends StatefulWidget{

  final IconData icon;
  final String title;
  final VoidCallback onTap;

  ReportCardBox({required this.icon,required this.title,required this.onTap});
  @override
  State<StatefulWidget> createState() {
    return _ReportCard();
  }
}


class _ReportCard extends State<ReportCardBox>{
 @override
  Widget build(BuildContext context) {
   return InkWell(
     onTap: widget.onTap,
     child: Card(
       elevation: 1,
       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
       child: Padding(
         padding: const EdgeInsets.symmetric(horizontal:1, vertical: 3),
         child: ListTile(
           leading: Container(
             padding: EdgeInsets.all(8),
             decoration: BoxDecoration(
               color: Colors.deepPurple[50],
               borderRadius: BorderRadius.circular(8),
             ),
             child: Icon(widget.icon, color: Colors.deepPurple),
           ),
           title: Text(
             widget.title,
             style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
           ),
           trailing: Icon(Icons.arrow_forward, size: 14),
         ),
       ),
     ),
   );
 }
  }
