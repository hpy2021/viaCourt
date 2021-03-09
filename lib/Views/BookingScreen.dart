import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../Constants/AppColors.dart';
import '../Constants/AppConstants.dart';
import '../Constants/AppStrings.dart';
import '../Models/BookingResponse.dart';
import '../Views/BookinHistoryView.dart';
import '../Widgets/custom_background_common_View.dart';

class BookingScreen extends StatefulWidget {
  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen>
    with TickerProviderStateMixin {
  bool isLoading = false;
  List<Bookings> bookingList = [];
  TabController _tabController;
 @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = new TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(context),
    );
  }

  _body() {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: TabBar(
          controller: _tabController,
          isScrollable: false,
          indicatorColor:AppColors.home_gradient2,
          labelPadding: EdgeInsets.only(bottom: 5),
          indicatorPadding: EdgeInsets.all(0.0),
          indicatorWeight: 2,
          tabs: <Widget>[
            Container(
              child: Text(
                "Recent",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
            ),
            Container(
              child: Text(
                "History",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
        body: BackgroundCurvedView(
          widget: TabBarView(
            dragStartBehavior: DragStartBehavior.down,
            controller: _tabController,
            children: <Widget>[BookingHistory(isHistory: false,), BookingHistory(isHistory: true,)],
          ),
        ),
      ),
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
          AppConstants().header(text: AppStrings.bookingText, context: context),
          SizedBox(
            height: 20,
          ),
          Flexible(child: _body())
        ],
      ),
    );
  }
}
