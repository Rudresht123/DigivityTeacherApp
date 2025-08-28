
import 'package:digivity_admin_app/Components/AppBarComponent.dart';
import 'package:digivity_admin_app/Components/BackgrounWeapper.dart';
import 'package:digivity_admin_app/Components/BottomNavigation.dart';
import 'package:digivity_admin_app/Components/CardContainer.dart';
import 'package:digivity_admin_app/Components/CustomBlueButton.dart';
import 'package:digivity_admin_app/Components/InputField.dart';
import 'package:digivity_admin_app/Components/SideBar.dart';
import 'package:digivity_admin_app/Components/ToggolButton.dart';
import 'package:digivity_admin_app/css/style.dart';
import 'package:flutter/material.dart';

class TwoFactorAuthentication extends StatefulWidget{

  TwoFactorAuthentication({Key? key}):super(key: key);
  @override
  State<TwoFactorAuthentication> createState() {
    return _TwoFactorAuth();
  }
}

class _TwoFactorAuth extends State<TwoFactorAuthentication>{
  final TextEditingController _currentpassword = TextEditingController();

  bool isTwoFAEnabled = false;




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Sidebar(),
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: AppBarComponent(appbartitle: "User Profile"),
      ),
      body: BackgroundWrapper(
          child:CardContainer(
            margin: EdgeInsets.symmetric(vertical: 70,horizontal: 10),
            padding: EdgeInsets.symmetric(horizontal: 20,vertical: 0),
            height: 100,
            child:  Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/logos/two_factor_auth.png',
                    width: 300,
                  ),
                  Text('2 FA Authentication',style: TextStyle(fontWeight: AppFontWeights.bold,fontSize: AppFontSizes.xLarge),),
                  SizedBox(height: 30,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TwoFAToggleButton(
                        value: isTwoFAEnabled,
                        onChanged: (val) {
                          setState(() {
                            isTwoFAEnabled = val;
                          });
                        },
                      ),
                    ],
                  ),
                  CustomTextField(label: 'Current Password', hintText: 'Enter Current Password', controller: _currentpassword),
                  SizedBox(height: 20,),
                  CustomBlueButton(text: "Submit", icon: Icons.arrow_right_alt_sharp,width: 400, onPressed: (){})
                ]),
          )
      ),

      bottomNavigationBar: CustomBottomNavBar(),
    );

  }
}