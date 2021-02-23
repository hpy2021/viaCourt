
import 'package:flutter/material.dart';
import 'package:via_court/Constants/AppColors.dart';
import 'package:via_court/Constants/AppTextStyles.dart';

class CustomButton extends StatelessWidget {
  CustomButton({@required this.onPressed,@required this.text});
  Function onPressed;

  String text;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      minWidth: double.infinity,
      onPressed: onPressed,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      color: AppColors.appColor_color,
      child: Text(text,style: AppTextStyles.loginButtonTextStyle,),
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 14),

    );
  }

}
