import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:intl/intl.dart';
import 'package:via_court/Constants/AppColors.dart';
import 'package:via_court/Constants/AppConstants.dart';
import 'package:via_court/Constants/AppStrings.dart';
import 'package:via_court/Constants/AppTextStyles.dart';
import 'package:via_court/Views/HomeScreen.dart';
import 'package:via_court/Widgets/custom_button.dart';

class SelectDateScreen extends StatefulWidget {
  int pitchId;
SelectDateScreen({this.pitchId});
  @override
  _SelectDateScreenState createState() => _SelectDateScreenState();
}

class _SelectDateScreenState extends State<SelectDateScreen> {
  DateTime _currentDate = DateTime.now();
  DateTime _currentDate2 = DateTime.now();
  var date = DateFormat("MMMM dd, yyyy");
  var date2 = DateFormat("dd/MM/yyyy");
  var requestDateFormate = DateFormat("yyyy-MM-dd");

  @override
  Widget build(BuildContext context) {
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
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 46,
          ),
          AppConstants().header(text: AppStrings.selectdate, context: context),
          SizedBox(
            height: 13,
          ),
          Expanded(child: calenderView())
        ],
      ),
    );
  }

  calenderView() {
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
            child: Column(
              // mainAxisSize: MainAxisSize.min,
              children: [
                roundedCornerTextView(),
                Expanded(child: _calender()),
                // Expanded(child: SizedBox()),

                _bottomBookingButton()
              ],
            )));
  }

  roundedCornerTextView() {
    return Container(
        margin: EdgeInsets.fromLTRB(20, 28, 20, 14),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: Colors.white,
          boxShadow: [
            BoxShadow(blurRadius: 7, color: Color(0xff3FA786).withOpacity(0.27))
          ],

          // border: Border.all(color: Color(0xff3FA786).withOpacity(0.27))
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "${date2.format(_currentDate2)}",
              style: AppTextStyles.textStyle15medium,
            ),
            Icon(
              Icons.calendar_today_outlined,
              color: AppColors.appColor_color,
            )
          ],
        ));
  }

  _calender() {
    return Container(
      margin: EdgeInsets.fromLTRB(20, 14, 20, 35),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(blurRadius: 7, color: Color(0xff3FA786).withOpacity(0.27))
          ]),
      padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
      child: CalendarCarousel<Event>(
        isScrollable: true,

        onDayPressed: (DateTime date, List<Event> events) {
          print("date : $date");
          // isSelected = !isSelected;
          _currentDate2 = date;
          // getSlots(id: widget.pitchid, booking_date: date);

          setState(() {});
        },

        weekendTextStyle: TextStyle(
            color: Color(0xff666666),
            fontWeight: FontWeight.w500,
            fontSize: 12),

        weekdayTextStyle: TextStyle(
          color: AppColors.appColor_color,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),

        thisMonthDayBorderColor: Colors.grey,
        daysTextStyle: AppTextStyles.textStyle12medium,
        dayPadding: 7,
//          weekDays: null, /// for pass null when you do not want to render weekDays
//       headerText: 'Custom Header',
        headerTextStyle: TextStyle(color: Color(0xff666666), fontSize: 15),
        leftButtonIcon: Card(
          elevation: 24,
          shadowColor: Color(0xff000000).withOpacity(0.07),
          child: Icon(Icons.chevron_left),
        ),
        rightButtonIcon: Card(
          elevation: 24,
          shadowColor: Color(0xff000000).withOpacity(0.07),
          child: Icon(Icons.chevron_right),
        ),
        height: 350,
        weekFormat: false,
        // markedDatesMap: _markedDateMap,
        selectedDateTime: _currentDate2,
        showIconBehindDayText: true,
//          daysHaveCircularBorder: false, /// null for not rendering any border, true for circular border, false for rectangular border
        customGridViewPhysics: NeverScrollableScrollPhysics(),
        // markedDateShowIcon: true,
        markedDateIconMaxShown: 4,
        selectedDayTextStyle: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w500,
          fontSize: 12,
        ),
        inactiveDaysTextStyle: AppTextStyles.textStyle12medium,
        nextDaysTextStyle: AppTextStyles.textStyle12mediumlight,
        prevDaysTextStyle: AppTextStyles.textStyle12mediumlight,
        selectedDayButtonColor: AppColors.appColor_color,
        childAspectRatio: 1,

        todayTextStyle: TextStyle(
          color: Color(0xff666666),
          fontWeight: FontWeight.w500,
          fontSize: 12,
        ),
        markedDateIconBuilder: (event) {
          return event.icon;
        },
        minSelectedDate: _currentDate.subtract(Duration(days: 360)),
        maxSelectedDate: _currentDate.add(Duration(days: 360)),
        todayButtonColor: Color(0xffCFF4D2),

        // todayBorderColor: Colors.green,
        markedDateMoreShowTotal: true,
        // null for not showing hidden events indicator
        markedDateIconMargin: 9,
        markedDateIconOffset: 3,
      ),
    );
  }

  _bottomBookingButton() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 19),
      child: CustomButton(
          onPressed: () {
            print(_currentDate2);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HomeScreen(pitchId: widget.pitchId,selectedDate:_currentDate2 ,),
              ),
            );
            // if (dateTime.isEmpty) {
            //   AppConstants().showToast(msg: "Please select the slot");
            // } else {
            //   _bookingConfirmapi(dateTime, endTime);
            // }
          },
          text: "Select"),
    );
  }
}
