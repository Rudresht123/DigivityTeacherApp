 import 'package:digivity_admin_app/AdminPanel/MobileThemsColors/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class SimpleAppBar extends StatefulWidget{
  final String titleText;
  final String routeName;

  SimpleAppBar({required this.titleText,required this.routeName});

  @override
  State<SimpleAppBar> createState() {
    return _SimpleAppBar();
  }


}

class _SimpleAppBar extends State<SimpleAppBar>{

  @override
  Widget build(BuildContext context){
    final uiTheme = Provider.of<UiThemeProvider>(context);


    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: uiTheme.iconColor?? Colors.white),
        backgroundColor: uiTheme.appBarColor ?? Colors.blue,
        leading: IconButton(onPressed: (){
          if(widget.routeName == 'back'){
            context.pop();
          }else{
            context.goNamed('${widget.routeName}');
          }
        }, icon: const Icon(Icons.arrow_back)),
        title: Text('${widget.titleText}',style: TextStyle(fontSize:16,color: uiTheme.iconColor?? Colors.white,fontWeight: FontWeight.w600),),
        centerTitle: true,
      ),
    );
  }
}
