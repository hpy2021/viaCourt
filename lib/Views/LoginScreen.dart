import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:via_court/Constants/AppColors.dart';
import 'package:via_court/Constants/AppConstants.dart';
import 'package:via_court/Constants/AppStrings.dart';
import 'package:via_court/Constants/AppTextStyles.dart';
import 'package:via_court/Models/LoginResponse.dart';
import 'package:via_court/Utils/ApiManager.dart';
import 'package:via_court/Views/BottomNavigationBarHome.dart';
import 'package:via_court/Views/SelectCourtSizeScreen.dart';
import 'package:via_court/Views/OtpScreen.dart';
import 'package:via_court/Views/SignUpScreen.dart';
import 'package:via_court/Widgets/custom_button.dart';
import 'package:via_court/Widgets/custom_textFormField.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  bool isSwitchedOn = false;
  bool isLoading = false;
  SharedPreferences sharedPreferences;

  loginApiCall({
    String email,
    String password,
  }) async {
    if (await ApiManager.checkInternet()) {
      if (mounted)
        setState(() {
          isLoading = true;
        });

      var request = Map<String, dynamic>();

      request["email"] = email;
      request["password"] = password;
      LoginResponse registerResponse = LoginResponse.fromJson(
          await ApiManager().postCall(AppStrings.LOGIN_URL, request, context));

      if (registerResponse.status == 200) {

          sharedPreferences = await SharedPreferences.getInstance();
          await sharedPreferences.setString(
              AppStrings.TOKEN_KEY, registerResponse.token);
         await sharedPreferences.setBool("isRemindme", isSwitchedOn);

          Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => BottomNavigationBarView(),
          ),
        );
        if (mounted)
          setState(() {
            isLoading = false;
          });
        AppConstants().showToast(msg: "Successfully Logged In");
      } else {
        if (mounted)
          setState(() {
            isLoading = false;
          });
        AppConstants().showToast(msg: "Problem with login");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
          child: Scaffold(
            backgroundColor: Colors.white,
            body: _body(),
          ),
        ),
        AppConstants.progress(isLoading, context)
      ],
    );
  }

  _body() {
    return SingleChildScrollView(
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(gradient: AppColors().gradient()),
            width: double.infinity,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                SizedBox(
                  height: 89,
                ),
                _signInText(),
                SizedBox(height: 31),
                CustomTextFormField(
                  controller: emailController,
                  hintText: AppStrings.emailHintText,
                  obscureText: false,
                ),
                SizedBox(height: 25),
                CustomTextFormField(
                  controller: passwordController,
                  hintText: AppStrings.passWordHintText,
                  obscureText: true,
                ),
                SizedBox(
                  height: 25,
                ),
                _remindMeSwitch(),
                SizedBox(
                  height: 25,
                ),
                _loginButton(),
                SizedBox(
                  height: 18,
                ),
                _bottomLineText()
              ],
            ),
          ),
          _closeButton()
        ],
      ),
    );
  }

  _signInText() {
    return Text(
      tr("login"),
      style: AppTextStyles.bigTextStyle,
    );
  }

  _remindMeSwitch() {
    return Padding(
      padding: const EdgeInsets.only(left: 6.0, right: 22),
      child: Row(
        children: [
          Transform.scale(
            scale: 0.55,
            child: CupertinoSwitch(
                dragStartBehavior: DragStartBehavior.start,
                value: isSwitchedOn,
                trackColor: Color(0xffBFBFBF),
                onChanged: (value) {
                  isSwitchedOn = value;
                  print(isSwitchedOn);
                  setState(() {});
                }),
          ),
          Expanded(
              child: Text(
            "Remind me",
            style: AppTextStyles.smallTextStyle,
          )),
          Text(
            "Forget Password?",
            style: AppTextStyles.smallTextStyleWithColor,
          )
        ],
      ),
    );
  }

  _loginButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22),
      child: CustomButton(
        onPressed: () {

          _validationCheck();
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(builder: (context) => BottomNavigationBarView()),
          // );
        },
        text: AppStrings.loginButtonText,
      ),
    );
  }

  _bottomLineText() {
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SignUpScreen()));
      },
      child: RichText(
        text: TextSpan(
            text: AppStrings.DonhaveaccountUpText,
            style: TextStyle(fontSize: 16, color: AppColors.purpleText_color),
            children: [
              TextSpan(
                  text: AppStrings.signUpText,
                  style: AppTextStyles.signUpTextStyle)
            ]),
      ),
    );
  }

  _closeButton() {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 56, 17, 0),
      height: 30,
      width: 30,
      decoration:
          BoxDecoration(color: Color(0xff51526E), shape: BoxShape.circle),
      child: Icon(
        Icons.clear,
        color: Colors.white,
        size: 18,
      ),
    );
  }

  _validationCheck() {
    if (emailController.text.trim().isEmpty) {
      AppConstants().showToast(msg: "Please enter email");
    } else if (passwordController.text.trim().isEmpty) {
      AppConstants().showToast(msg: "Please enter mobile number");
    } else {
      loginApiCall(
        email: emailController.text,
        password: passwordController.text,
      );
    }
  }
}
