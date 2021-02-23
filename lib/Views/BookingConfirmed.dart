import 'dart:collection';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:via_court/Constants/AppColors.dart';
import 'package:via_court/Constants/AppConstants.dart';
import 'package:via_court/Constants/AppStrings.dart';
import 'package:via_court/Constants/AppTextStyles.dart';
import 'package:via_court/Models/BookingConfirmedResponse.dart';
import 'package:via_court/Models/CommonResponse.dart';
import 'package:via_court/Utils/ApiManager.dart';
import 'package:via_court/Views/ProductScreen.dart';
import 'package:via_court/Widgets/custom_background_common_View.dart';
import 'package:via_court/Widgets/custom_button.dart';

class BookingConfirmed extends StatefulWidget {
  Booking booking;

  BookingConfirmed({@required this.booking});

  @override
  _BookingConfirmedState createState() => _BookingConfirmedState();
}

class _BookingConfirmedState extends State<BookingConfirmed> {
  List<SportsItemView> sportsItemList = [];
  List<SportsItemView> availableItemList = [];
  bool isLoading = false;

  @override
  void initState() {
    print(widget.booking.price);
    // TODO: implement initState
    super.initState();
    sportsItemList.add(SportsItemView(
        text: "Football", imageUrl: "assets/images/footBall.png"));
    sportsItemList.add(SportsItemView(
        text: "BoxCricket", imageUrl: "assets/images/cricket.png"));
    availableItemList.add(SportsItemView(
        text: "", imageUrl: "assets/images/footBall.png", isSelected: false));
    availableItemList.add(SportsItemView(
        text: "", imageUrl: "assets/images/bottle.png", isSelected: true));
    availableItemList.add(SportsItemView(
        text: "", imageUrl: "assets/images/tshirt.png", isSelected: false));
    availableItemList.add(SportsItemView(
        text: "", imageUrl: "assets/images/rugby.png", isSelected: false));
  }
  String _startTime,_endTime,bookedDate;
  
  _data(){
    _startTime = DateFormat("HH:mm a").format(DateTime.parse("${widget.booking.bookingSlotStartTime}"));
    _endTime = DateFormat("HH:mm a").format(DateTime.parse("${widget.booking.bookingSlotEndTime}"));
    print(_startTime +" sdfasdfasdf " +_endTime);
    bookedDate =  DateFormat("MMMM dd, yyyy").format(DateTime.parse("${widget.booking.bookingDate}"));

  }

  availablityCheckApi() async {
    if (await ApiManager.checkInternet()) {
      if (mounted)
        setState(() {
          isLoading = true;
        });
      Map<String, dynamic> request = new HashMap();

      // request["courts_id"] = "${widget.courtid}";
      // request["locations_id"] = "${widget.locationid}";
      // request["pitch_id"] = "${widget.pitchid}";
      // request["users_id"] = "${widget.courtid}";
      // request["booking_date"] = "$_currentDate2";
      // request["booking_slot"] = "${startTime + " to "+ endTime}";
      // request["booking_slot_start_time"] = "$startTime";
      // request["booking_slot_end_time"] = "$endTime";
      // request["price"] = "${widget.price}";

      request["bookings_id"] = "102";
      request["users_id"] = "1";
      request["price"] = "223";
      request["services_id"] = "1";
      CommonResponse response = new CommonResponse.fromJson(await ApiManager()
          .postCallWithHeader(
          AppStrings.ADD_TO_CART
              ,
          request,
          context));
      // CommonResponse response = new CommonResponse.fromJson(await ApiManager()
      //     .postCallWithHeader(
      //     AppStrings.BOOKING_CONFIRM_URL,
      //     request,
      //     context));

      //
      // print(response.timeslots.length);
      // api call
      // TimeSlotResponse response = new TimeSlotResponse.fromJson(await ApiManager()
      //     .postCallWithHeader(AppStrings.PRODUCT_URL, request, context));
      if (response != null) {
        print(response.result);
        if (mounted)
          setState(() {
            isLoading = false;
          });
        // result = response.result;
        setState(() {});

        return response.result;
        // if (response.timeslots == null) {
        // slotItemList.clear();
        // slotItemList == null;
      } else {
        if (mounted)
          setState(() {
            isLoading = false;
          });
        // slotItemList = response.timeslots;

        if (mounted) setState(() {});
      }
      if (mounted)
        setState(() {
          isLoading = false;
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    _data();
    return Scaffold(
      backgroundColor: Colors.white,
      body: _buildBody(),
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
          AppConstants()
              .header(text: AppStrings.reviewbookingText, context: context),
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
        widget: SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 27,
            ),
            _imageView(),
            SizedBox(
              height: 20,
            ),
            _detailsView(),
            _iconTextWidget(
                text: "$bookedDate", icon: Icons.calendar_today_outlined),
            SizedBox(
              height: 16,
            ),
            _iconTextWidget(
                text: "$_startTime - $_endTime", icon: Icons.access_time_outlined),
            SizedBox(
              height: 16,
            ),
            Divider(
              thickness: 1,
              color: Color(0xffCECECE),
            ),
            SizedBox(
              height: 10,
            ),
            Text("Available Sports",
                style: AppTextStyles.textStyle14mediumblack),
            SizedBox(
              height: 15,
            ),
            Container(
                height: 38,
                width: double.infinity,
                child: _availableSportList()),
            SizedBox(
              height: 16,
            ),
            Divider(
              thickness: 1,
              color: Color(0xffCECECE),
            ),
            // Expanded(child: Container(),),
            // SizedBox(
            //   height: 10,http://cb548057bf17.ngrok.io/api/addToCart
            //
            // 'bookings_id' => 'required',
            // 'users_id' =>'required',
            // 'price'=> 'required',
            // 'services_id' =>'required',
            // ),
            // Text("Available Items",
            //     style: AppTextStyles.textStyle14mediumblack),
            //
            // SizedBox(
            //   height: 9,
            // ),
            // Container(
            //     height: 50,
            //     width: double.infinity,
            //     child: _additionalItemsView()),
            SizedBox(
              height: 21,
            ),
            _bottomContinueButton(),
            SizedBox(
              height: 20,
            ),
            // _SizedBox(
            //               height: 21,
            //             ),availableSportList()
          ],
        ),
      ),
    ));
  }

  _imageView() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          foregroundDecoration: BoxDecoration(
              color: Colors.black.withOpacity(0.39),
              borderRadius: BorderRadius.circular(10)),
          child: Image.asset(
            "assets/images/pitchImage.png",
            height: 149,
            width: 370,
          ),
        ),
        _onImageText()
      ],
    );
  }

  _onImageText() {
    return Container(
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.appColor_color,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 11),
            child: Icon(
              Icons.check,
              color: Colors.white,
              size: 28,
            ),
          ),
          SizedBox(width: 8),
          Text(
            "Please review your booking",
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.w500, color: Colors.white),
          )
        ],
      ),
    );
  }

  _detailsView() {
    return Container(
        child: ListTile(
      contentPadding: EdgeInsets.zero,
      title:
          Text("Lorem ipsum dolor sit", style: AppTextStyles.textStyle18medium),
      trailing:
          Text("\$ ${widget.booking.price}", style: AppTextStyles.textStyle18mediumwithGreen),
      subtitle: Text("Width : 58 ft/17.68 m, Lenth : 6 ft/1.83 m.",
          style: AppTextStyles.textStyle14grey),
    ));
  }

  _iconTextWidget({IconData icon, String text}) {
    return Row(
      children: [
        Icon(
          icon,
          size: 25,
          color: AppColors.appColor_color,
        ),
        SizedBox(
          width: 5.7,
        ),
        Text(text, style: AppTextStyles.textStyle14green)
      ],
    );
  }

  _availableSportList() {
    return Container(
        child: ListView.builder(
            itemCount: sportsItemList.length,
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              return _availableSportsItemView(sportsItemList[index]);
            }));
  }

  _availableSportsItemView(SportsItemView item) {
    return Container(
        padding: EdgeInsets.only(right: 17),
        child: Column(
          children: [
            Image.asset(
              item.imageUrl,
              height: 21,
              width: 21,
              fit: BoxFit.contain,
            ),
            SizedBox(height: 2.4),
            Text(item.text,
                style: TextStyle(
                    fontSize: 12,
                    color: Color(0xff666666),
                    fontWeight: FontWeight.w500))
          ],
        ));
  }

  _additionalItemsView() {
    return Container(
      child: ListView.builder(
          itemCount: availableItemList.length,
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemBuilder: (BuildContext ctx, int index) {
            return InkWell(
              onTap: () {
                availableItemList[index].isSelected =
                    !availableItemList[index].isSelected;
                setState(() {});
              },
              child: Container(
                  margin: EdgeInsets.only(right: 6),
                  decoration: BoxDecoration(
                      color: availableItemList[index].isSelected
                          ? AppColors.selectedColor
                          : AppColors.notselectedColor,
                      borderRadius: BorderRadius.circular(5)),
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                  child: Image.asset(
                    availableItemList[index].imageUrl,
                    height: 37,
                    width: 37,
                    color: availableItemList[index].isSelected
                        ? AppColors.selectedItemColor
                        : AppColors.notselectedItemColor,
                  )),
            );
          }),
    );
  }

  _bottomContinueButton() {
    return CustomButton(
        onPressed: () {
          // availablityCheckApi();
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => ProductScreen(bookingId:widget.booking.id,userId: int.parse(widget.booking.usersId) ,pitchId:int.parse(widget.booking.pitchId) ,)));
        },
        text: AppStrings.continueText);
  }
}

class SportsItemView {
  String imageUrl, text;

  bool isSelected = false;

  SportsItemView({this.text, this.imageUrl, this.isSelected});
}