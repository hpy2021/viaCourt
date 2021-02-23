import 'package:flutter/material.dart';
import 'package:via_court/Constants/AppColors.dart';
import 'package:via_court/Constants/AppConstants.dart';
import 'package:via_court/Constants/AppStrings.dart';
import 'package:via_court/Widgets/custom_background_common_View.dart';

class ActivityScreen extends StatefulWidget {
  @override
  _ActivityScreenState createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          AppConstants().header(text: AppStrings.activityText,context: context),
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
                child: Center(
                  child: Text("Activity screen is under progress"),
                ),
              )
            ],
          ),
        ));
  }

}
