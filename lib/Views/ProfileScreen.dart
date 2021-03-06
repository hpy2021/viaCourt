import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:via_court/Constants/AppColors.dart';
import 'package:via_court/Constants/AppConstants.dart';
import 'package:via_court/Constants/AppStrings.dart';
import 'package:via_court/Constants/AppTextStyles.dart';
import 'package:via_court/Models/CommonResponse.dart';
import 'package:via_court/Models/SignUpResposne.dart';
import 'package:via_court/Models/userResponse.dart';
import 'package:via_court/Models/userResponse.dart';
import 'package:via_court/Utils/ApiManager.dart';
import 'package:via_court/Views/EditProfile.dart';
import 'package:via_court/Views/LoginScreen.dart';
import 'package:via_court/Widgets/custom_background_common_View.dart';
import 'package:via_court/Utils/firebaseMessagingService.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserResponse user;
  bool isLoading = false;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  String _homeScreenText = "Waiting for token...";
  String _messageText = "Waiting for message...";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userApiCall();
    // _firebaseMessaging.configure(
    //   onMessage: (Map<String, dynamic> message) async {
    //     setState(() {
    //       _messageText = "Push Messaging message: $message";
    //     });
    //     print("onMessage: $message");
    //   },
    //   onLaunch: (Map<String, dynamic> message) async {
    //     setState(() {
    //       _messageText = "Push Messaging message: $message";
    //     });
    //     print("onLaunch: $message");
    //   },
    //   onResume: (Map<String, dynamic> message) async {
    //     setState(() {
    //       _messageText = "Push Messaging message: $message";
    //     });
    //     print("onResume: $message");
    //   },
    // );
    // _firebaseMessaging.requestNotificationPermissions(
    //     const IosNotificationSettings(sound: true, badge: true, alert: true));
    // _firebaseMessaging.onIosSettingsRegistered
    //     .listen((IosNotificationSettings settings) {
    //   print("Settings registered: $settings");
    // });
    // _firebaseMessaging.getToken().then((String token) {
    //   assert(token != null);
    //   setState(() {
    //     _homeScreenText = "Push Messaging token: $token";
    //   });
    //   print(_homeScreenText);
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.white,
          body: _buildBody(context),
        ),
        AppConstants.progress(isLoading, context)
      ],
    );
  }

  userApiCall() async {
    if (await ApiManager.checkInternet()) {
      if (mounted)
        setState(() {
          isLoading = true;
        });
      UserResponse registerResponse = UserResponse.fromJson(
          await ApiManager().getCallwithheader(AppStrings.USER_URL));

      if (registerResponse.status == "Active") {
        if (mounted)
          setState(() {
            isLoading = false;
          });
        print(registerResponse.firstname);
        user = registerResponse;
        setState(() {});
        // AppConstants().showToast(msg: "User returned SuccessFully");
      } else {
        if (mounted)
          setState(() {
            isLoading = false;
          });
        // AppConstants().showToast(msg: "${registerResponse.message}");
      }
    }
  }

  logoutApiCall() async {
    if (await ApiManager.checkInternet()) {
      if (mounted)
        setState(() {
          isLoading = true;
        });
      var request;
      CommonResponse registerResponse = CommonResponse.fromJson(
        await ApiManager().postCallWithHeader(AppStrings.LOGOUT_URL,request,context),
      );

      if (registerResponse.status == 204) {
        if (mounted)
          setState(() {
            isLoading = false;
          });
        // print(registerResponse.firstname);
        // user = registerResponse;
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>LoginScreen()), (route) => false);
        setState(() {});
        AppConstants().showToast(msg: "User loggedout SuccessFully");
      } else {
        if (mounted)
          setState(() {
            isLoading = false;
          });
        // AppConstants().showToast(msg: "${registerResponse.message}");
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
          user == null
              ? header("user", context)
              : header("${user.firstname + " " + user.lastname}", context),
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
          // Navigator.push(
          //     context, MaterialPageRoute(builder: (context) => EditProfile(user: user,)));
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
        _textIconWidget(
            text: "My Profile",
            url: "assets/images/profile.png",
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => EditProfile(
                          user: user,
                        )))),
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
              logoutApiCall();

              // Navigator.pushAndRemoveUntil(
              //     context,
              //     MaterialPageRoute(builder: (context) => LoginScreen()),
              //     (route) => false);
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
