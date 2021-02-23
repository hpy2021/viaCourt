import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:via_court/Constants/AppColors.dart';
import 'package:via_court/Constants/AppConstants.dart';
import 'package:via_court/Constants/AppStrings.dart';
import 'package:via_court/Constants/AppTextStyles.dart';
import 'package:via_court/Models/SignUpResposne.dart';
import 'package:via_court/Utils/ApiManager.dart';
import 'package:via_court/Views/EditProfile.dart';
import 'package:via_court/Views/LoginScreen.dart';
import 'package:via_court/Widgets/custom_background_common_View.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userApiCall();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _buildBody(context),
    );
  }

  userApiCall() async {
    if (await ApiManager.checkInternet()) {
      if (mounted)
        setState(() {
          isLoading = true;
        });
      SignUpResponse registerResponse = SignUpResponse.fromJson(
          await ApiManager().getCallwithheader(AppStrings.USER_URL));

      if (registerResponse.status == 201) {
        if (mounted)
          setState(() {
            isLoading = false;
          });
        AppConstants().showToast(msg: "User Created SuccessFully");
      } else {
        if (mounted)
          setState(() {
            isLoading = false;
          });
        AppConstants().showToast(msg: "${registerResponse.message}");
      }
    }
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
          header("John smith", context),
          SizedBox(
            height: 13,
          ),
          Flexible(child: mainBody())
        ],
      ),
    );
  }

  mainBody() {
    return BackgroundCurvedView(
      widget: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: profileView(),
            ),
          ],
        ),
      ),
    );
  }

  header(String text, context) {
    return Container(
      padding: EdgeInsets.only(left: 13, right: 20),
      child: InkWell(
        onTap: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => EditProfile()));
        },
        child: Row(
          children: [
            Container(
              height: 56,
              width: 56,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: AssetImage("assets/images/profile.jpg"))),
            ),
            SizedBox(width: 16),
            Text(
              text,
              style: AppTextStyles.textStyle25white,
            ),
          ],
        ),
      ),
    );
  }

  profileView() {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 22),
      children: [
        SizedBox(
          height: 37,
        ),
        _textIconWidget(text: "My Profile", url: "assets/images/profile.png"),
        SizedBox(
          height: 34,
        ),
        _textIconWidget(text: "Change Password", url: "assets/images/lock.png"),
        SizedBox(
          height: 34,
        ),
        _textIconWidget(text: "My Bookings", url: "assets/images/ticket.png"),
        SizedBox(
          height: 34,
        ),
        _textIconWidget(
            text: "Terms & Condition", url: "assets/images/doc.png"),
        SizedBox(
          height: 34,
        ),
        _textIconWidget(text: "Privacy Policy", url: "assets/images/pp.png"),
        SizedBox(
          height: 34,
        ),
        Container(
          width: double.infinity,
          height: 1,
          color: Color(0xffBAC0DA),
        ),
        SizedBox(
          height: 32,
        ),
        _textIconWidget(
            text: "Logout",
            url: "assets/images/signout.png",
            onPressed: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();

              prefs.clear();
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>LoginScreen()), (route) => false);
            }),
      ],
    );
  }

  _textIconWidget({String url, String text, Function onPressed}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0),
      child: InkWell(
        onTap: onPressed,
        child: Row(
          children: [
            Image.asset(
              "$url",
              height: 20.7,
              width: 20.7,
              color: AppColors.lightGreenText_color,
            ),
            SizedBox(
              width: 11.3,
            ),
            Text(
              text,
              style: AppTextStyles.textStyle18,
            )
          ],
        ),
      ),
    );
  }
}
