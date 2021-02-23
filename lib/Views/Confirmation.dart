import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:via_court/Constants/AppColors.dart';
import 'package:via_court/Constants/AppConstants.dart';
import 'package:via_court/Constants/AppStrings.dart';
import 'package:via_court/Views/BottomNavigationBarHome.dart';
import 'package:via_court/Views/HomeScreen.dart';
import 'package:via_court/Widgets/custom_background_common_View.dart';
import 'package:via_court/Widgets/custom_button.dart';

class ConfirmationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
   return Scaffold(
  backgroundColor: Colors.white,
  body: _buildBody(context),
  );
}

_buildBody(context) {
  return Container(
    decoration: BoxDecoration(gradient: AppColors().homegradient()),
    width: double.infinity,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 46,
        ),
        AppConstants()
            .header(text: AppStrings.confirmationText, context: context),
        SizedBox(
          height: 13,
        ),
        Flexible(child: mainBody(context))
      ],
    ),
  );
}

mainBody(context) {
  return BackgroundCurvedView(
      widget: Container(
        width: double.infinity,
        child: Stack(
          children: [
            Column(

              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 101,),

                _roundCircleWithtick(),
                SizedBox(height: 33,),
                Text("\$ 32.46",style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),),
                SizedBox(height: 11,),
                Text("Your Payment is Received !",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500,color: Color(0xff666666)),),

                SizedBox(height: 38,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 45),
                  child: Text("Thank you, your payment has been successful. Confirmation email has been sent to abc@xxxaaa.com.",textAlign: TextAlign.center,style: TextStyle(fontSize: 16,color: Color(0xff666666),),),
                ),

              ],
            ),
            _bottomContinueButton(context)
          ],
        ),
      ),);
}

_roundCircleWithtick(){
    return Container(

      decoration: BoxDecoration(
        shape: BoxShape.circle,
            color: Color(0xffA4F2D9)
      ),
      padding: EdgeInsets.symmetric(horizontal: 42,vertical: 51),
      child: Icon(FontAwesomeIcons.check,color: AppColors.lightGreenText_color,size: 43,),
    );
}

  _bottomContinueButton(context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(21.0, 0.0, 21.0, 20.0),
        child: CustomButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>BottomNavigationBarView()), (route) => false);
            },
            text: AppStrings.doneText),
      ),
    );
  }
}
