import 'dart:collection';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:via_court/Constants/AppColors.dart';
import 'package:via_court/Constants/AppConstants.dart';
import 'package:via_court/Constants/AppStrings.dart';
import 'package:via_court/Constants/AppTextStyles.dart';
import 'package:via_court/Constants/fadeAnimation.dart';
import 'package:via_court/Models/CourtListModel.dart';
import 'package:via_court/Utils/ApiManager.dart';
import 'package:via_court/Views/SelectCourtSizeScreen.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<CourtList> courtList = List();
  List<CourtData> courtData = List();
  var data;
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCourt();
  }

  CourtListResponse courtListModel;

  getCourt() async {
    // if (await ApiManager.checkInternet()) {
    if (mounted)
      setState(() {
        isLoading = true;
      });

    Map<String, dynamic> request = new HashMap();

    CourtListResponse response = CourtListResponse.fromJson(
        await ApiManager().getCall(AppStrings.COURT_URL));
    // CourtListResponse response = CourtListResponse.fromJson(await ApiManager()
    //     .postCallWithHeader(AppStrings.PITCHES_URL+"/4",request,context));

    if (response.status == 200) {
      isLoading = false;

      courtData = response.result;
      setState(() {});
    }

    if (mounted)
      setState(() {
        // isLoading = false;
      });
  }

  // else {
  //   // AppConstants().showToast(msg: AppStrings.noInternet);
  // }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
            body: AnnotatedRegion(
          child: _buildBody(),
          value: SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: Brightness.light),
        )),
        AppConstants.progress(isLoading, context)
      ],
    );
  }

  _buildBody() {
    return Container(
      decoration: BoxDecoration(gradient: AppColors().homegradient()),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 46,
          ),
          _header(),
          SizedBox(
            height: 3,
          ),
          Container(
            padding: EdgeInsets.only(left: 13, right: 20),
            child: Text(AppStrings.listofCourttext,
                style: AppTextStyles.textStyle16),
          ),
          SizedBox(
            height: 13,
          ),
          Expanded(child: _courtListView())
        ],
      ),
    );
  }

  _header() {
    return Container(
      padding: EdgeInsets.only(left: 13, right: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            AppStrings.selectCourttext,
            style: AppTextStyles.textStyle25white,
          ),
          Stack(
            alignment: Alignment.centerRight,
            children: [
              Icon(
                Icons.notifications,
                color: Colors.white,
                size: 30,
              ),
              Positioned(
                bottom: 15,
                right: 2,
                child: Container(
                  height: 11,
                  width: 11,
                  decoration:
                      BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  _courtListView() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(40),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(40),
        ),
        child: courtData.length != 0
            ? ListView.builder(
                itemCount: courtData.length,
                itemBuilder: (BuildContext context, int index) {
                  return _courtListItemView(courtData[index]);
                })
            : Container(child: Center(child: Text(""))),
      ),
    );
  }

  _courtListItemView(CourtData data) {
    return FadeAnimation(
      0.5,
      Container(
        margin: EdgeInsets.fromLTRB(17, 0, 17, 15),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
            color: AppColors.itemListBackGroundColor),
        child: InkWell(
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SelectCourtSize(
                        pitchId: data.id,
                        locationId: data.locationsId,
                      ))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                    child: CachedNetworkImage(
                      height: 192,
                      width: 379,
                      fit: BoxFit.cover,
                      imageUrl: AppStrings.IMGBASE_URL + data.courtImage,
                      progressIndicatorBuilder:
                          (context, url, downloadProgress) => Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: SpinKitCircle(
                          color: AppColors.appColor_color,
                          size: 50,
                        ),
                      ),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    )
                    // child:AppConstants.imageLoader(data.courtImage, "")
                    // CachedNetworkImage(
                    //   imageUrl: "http://via.placeholder.com/200x150",
                    //   imageBuilder: (context, imageProvider) => Container(
                    //     decoration: BoxDecoration(
                    //       image: DecorationImage(
                    //           image: imageProvider,
                    //           fit: BoxFit.cover,
                    //           colorFilter:
                    //           ColorFilter.mode(Colors.red, BlendMode.colorBurn)),
                    //     ),
                    //   ),
                    //   placeholder: (context, url) => CircularProgressIndicator(),
                    //   errorWidget: (context, url, error) => Icon(Icons.error),
                    // ),
                    // child: Image.network(
                    //   "${AppStrings.IMGBASE_URL + data.courtImage}",
                    //   height: 192,
                    //   width: 379,
                    //   fit: BoxFit.cover,
                    // ),
                    ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0, top: 16),
                child: Text(
                  "${data.title}",
                  style: AppTextStyles.textStyle15mediumblack,
                ),
              ),
              SizedBox(height: 6),
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Text(
                  "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed accumsan justo quis mauris imperdiet.",
                  style: AppTextStyles.regular14black,
                ),
              ),
              SizedBox(height: 9.6),

              Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      color: AppColors.appColor_color,
                      size: 20,
                    ),
                    SizedBox(width: 9),
                    Expanded(
                        child: Text(
                      "${data.address1 == null ? "Address" : data.address1}",
                      style: AppTextStyles.textStyle14green,
                    ))
                  ],
                ),
              ),
              SizedBox(height: 9.6),

              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.access_time_rounded,
                      color: AppColors.appColor_color,
                      size: 17,
                    ),
                    SizedBox(width: 10.5),
                    Text("10:00 AM - 11:00 AM", style: AppTextStyles.green13)
                  ],
                ),
              ),
              SizedBox(height: 14),

              // _bottomButton(courtList.price)
            ],
          ),
        ),
      ),
    );
  }

  _bottomButton(String text) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: AppColors.appColor_color,
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
      ),
      child: Text(
        "\$ $text",
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
