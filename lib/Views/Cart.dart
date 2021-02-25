import 'dart:collection';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:via_court/Constants/AppColors.dart';
import 'package:via_court/Constants/AppConstants.dart';
import 'package:via_court/Constants/AppStrings.dart';
import 'package:via_court/Constants/AppTextStyles.dart';
import 'package:via_court/Models/AddToCartResponse.dart';
import 'package:via_court/Models/CartItemModel.dart';
import 'package:via_court/Models/CommonResponse.dart';
import 'package:via_court/Models/ProductResponse.dart';
import 'package:via_court/Utils/ApiManager.dart';
import 'package:via_court/Views/checkOutPage.dart';
import 'package:via_court/Widgets/custom_background_common_View.dart';
import 'package:via_court/Widgets/custom_button.dart';
import 'package:via_court/Models/CartResposne.dart';

class Cart extends StatefulWidget {
  int pitchId, bookingId, userId;

  Cart({@required this.pitchId, this.bookingId, this.userId});

  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  int qty = 1;
  int subTotal, total;
  List<CartItemModel> cartItemList = List();
  List<ServiceData> serviceList = [];
  Pitch pitchData;

  int sum = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // _itemAdd();
    getCart();
  }

  bool isLoading = false;

  getCart() async {
    if (await ApiManager.checkInternet()) {
      if (mounted)
        setState(() {
          isLoading = true;
        });
      // print(id);
      Map<String, dynamic> request = new HashMap();

      // request["name"] = "abc";
      // request["status"] = "Available";
      // request["email"] = "yash@gmail.com";
      // request["court_id"] = "3";
      // request["location_id"] = "1";
      request["users_id"] = "1";
      request["pitch_id"] = "${widget.pitchId}";
      // request["slote_duration"] = "2";
      // request["booking_date"] = "${requestDateFormate.format(booking_date)}";
      // TimeSlotResponse response = new TimeSlotResponse.fromJson(
      //     await ApiManager().postCallWithHeader(
      //         AppStrings.PITCH_TIME_SLOT_URL + "/$id", request, context)); //
      // print(response.timeslots.length);
      // api call
      CartResponse response = new CartResponse.fromJson(
        await ApiManager()
            .postCallWithHeader(AppStrings.CART_URL, request, context),
      );
      if (response != null) {
        if (mounted)
          setState(() {
            isLoading = false;
          });
        serviceList = response.service;
        pitchData = response.pitch;
        sum=0;
        response.service.forEach((element) {
          // sum = sum + element.total;


          sum += element.total;
        });
        // serviceList.forEach((element) {
        //   element.total;
        //
        // });
        subTotal = sum;
        total = sum + pitchData.price;
        // products = response.result;
        setState(() {});
      } else {
        if (mounted)
          setState(() {
            isLoading = false;
          });
        if (mounted) setState(() {});
      }
      if (mounted)
        setState(() {
          isLoading = false;
        });
    }
  }


  addtocartapi({int price, int serviceId}) async {
    if (await ApiManager.checkInternet()) {
      if (mounted)
        setState(() {
          isLoading = true;
        });
      Map<String, dynamic> request = new HashMap();
      request["bookings_id"] = "${widget.bookingId}";
      request["users_id"] = "${widget.userId}";
      request["price"] = "$price";
      request["services_id"] = "$serviceId";
      AddToCartresponse response = new AddToCartresponse.fromJson(
          await ApiManager()
              .postCallWithHeader(AppStrings.ADD_TO_CART, request, context));
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
        print(response.product);
        if (mounted)
          setState(() {
            isLoading = false;
          });
        getCart();


        setState(() {});

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

  removefromCart({int serviceId}) async {
    if (await ApiManager.checkInternet()) {
      if (mounted)
        setState(() {
          isLoading = true;
        });
      Map<String, dynamic> request = new HashMap();
      // request["bookings_id"] = "${widget.bookingId}";
      // request["users_id"] = "${widget.userId}";
      // request["price"] = "$price";
      // request["services_id"] = "$serviceId";
      CommonResponse response = new CommonResponse.fromJson(
        await ApiManager().postCallWithHeader(
            AppStrings.DECREMENT_URL + "/$serviceId", request, context),
      );
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
        // print(response.product);
        if (mounted)
          setState(() {
            isLoading = false;
          });
        getCart();

        setState(() {});

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

  _itemAdd() {
    cartItemList.add(CartItemModel(
        price: 5.46,
        itemName: "FootBall",
        qty: 3,
        imgUrl: "assets/images/footBall.png"));
    cartItemList.add(CartItemModel(
        price: 2.05,
        itemName: "Bottle",
        qty: 2,
        imgUrl: "assets/images/bottle.png"));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.white,
          body: _buildBody(),
        ),
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
            height: 13,
          ),
          Flexible(child: mainBody())
        ],
      ),
    );
  }

  _header() {
    return Container(
      padding: EdgeInsets.only(left: 0, right: 28),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AppConstants().header(text: AppStrings.cartText, context: context),
          Stack(
            alignment: Alignment.topRight,
            overflow: Overflow.visible,
            children: [
              Image.asset(
                "assets/images/cart.png",
                width: 33,
                height: 29,
                fit: BoxFit.contain,
              ),
              Positioned(
                left: 22,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 0.8, horizontal: 5),
                  decoration:
                  BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                  child: Text(
                    "3",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ),
            ],
          ),
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
              _headerOfListView(),
              Expanded(
                child: cartBodyView(),
              ),
              // _subTotalView(),
              SizedBox(
                height: 9,
              ),
              _totalView(),
              SizedBox(
                height: 17,
              ),
              _bottomButton(),
              SizedBox(
                height: 24,
              )
            ],
          ),
        ));
  }

  _headerOfListView() {
    return Container(
      // decoration: BoxDecoration(
      //     color: Color(0xffD5F1F2),
      //     borderRadius: BorderRadius.only(
      //         topLeft: Radius.circular(10),
      //         bottomRight: Radius.circular(10),
      //         bottomLeft: Radius.circular(10))),
      margin: EdgeInsets.fromLTRB(17, 28, 17, 0),
      child: Slidable(
        actionPane: SlidableDrawerActionPane(),
        secondaryActions: <Widget>[
          Container(
            width: 59,
            height: 59,
            color: AppColors.yellowColor,
            child: Icon(
              FontAwesomeIcons.pencilAlt,
              color: Colors.white,
            ),
          ),
          Container(
            width: 59,
            height: 59,
            color: AppColors.pinkColor,
            child: Icon(
              FontAwesomeIcons.trashAlt,
              color: Colors.white,
            ),
          ),
        ],
        child: Container(
          decoration: BoxDecoration(
            color: Color(0xffD5F1F2),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
              bottomLeft: Radius.circular(10),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.fromLTRB(7, 14, 12, 14),
            child: Row(
              children: [
                pitchData == null
                    ? Container()
                    : CachedNetworkImage(
                  height: 31,
                  width: 44,
                  fit: BoxFit.contain,
                  imageUrl:
                  AppStrings.IMGBASE_URL + "${pitchData.pitchImage}",
                  progressIndicatorBuilder:
                      (context, url, downloadProgress) => Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: SpinKitCircle(
                      color: AppColors.appColor_color,
                      size: 20,
                    ),
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
                SizedBox(
                  width: 7,
                ),
                Expanded(
                    child: Text(
                      pitchData == null
                          ? ""
                          : pitchData.name != null
                          ? pitchData.name
                          : "",
                      style: AppTextStyles.textStyle14grey,
                    )),
                Text(
                  "Qty: 1",
                  style: AppTextStyles.textStyle14grey,
                ),
                SizedBox(
                  width: 50,
                ),
                Text(
                  pitchData == null
                      ? ""
                      : pitchData.price == null
                      ? pitchData.price
                      : "\$ ${pitchData.price}",
                  style: AppTextStyles.textStyle14grey,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  cartBodyView() {
    return Container(
      child: ListView.builder(
          padding: EdgeInsets.fromLTRB(17, 10, 17, 10),
          itemCount: serviceList.length,
          itemBuilder: (BuildContext context, int index) {
            return _cartBodyItemView(serviceList[index], index);
          }),
    );
  }

  _cartBodyItemView(ServiceData item, int index) {
    return Container(
      decoration: BoxDecoration(
          color: Color(0xffD5F1F2),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
              bottomLeft: Radius.circular(10))),
      margin: EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.fromLTRB(7, 14, 12, 14),
      child: Row(
        children: [
          CachedNetworkImage(
            height: 31,
            width: 44,
            fit: BoxFit.cover,
            imageUrl: AppStrings.IMGBASE_URL + item.image,
            progressIndicatorBuilder: (context, url, downloadProgress) =>
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SpinKitCircle(
                    color: AppColors.appColor_color,
                    size: 20,
                  ),
                ),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
          SizedBox(
            width: 7,
          ),
          Expanded(
              child: Container(
                child: Text(
                  item.title,
                  style: AppTextStyles.textStyle14grey,
                ),
              )),
          _quantityIncremented(item),
          SizedBox(
            width: 42,
          ),
          Text(
            "\$ ${item.total}",
            style: AppTextStyles.textStyle14grey,
          )
        ],
      ),
    );
  }

  _quantityIncremented(ServiceData qty) {
    return Container(
      child: Row(
        children: [
          Container(
            child: InkWell(
              onTap: () {
                if (qty.qty > 1) {
                  qty.qty = --qty.qty;
                  removefromCart(serviceId: qty.id);
                  // getCart();
                }

                setState(() {});
              },
              child: Icon(
                FontAwesomeIcons.minus,
                size: 15,
                color: AppColors.border_color,
              ),
            ),
          ),
          SizedBox(
            width: 11,
          ),
          Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Color(0xffC2DCD4))),
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 3),
              child: Text(
                "${qty.qty}",
                style: TextStyle(fontSize: 14),
              )),
          SizedBox(
            width: 11,
          ),
          Container(
            child: InkWell(
                onTap: () {
                  print("asdas");
                  setState(
                        () {
                      qty.qty = qty.qty + 1;
                      addtocartapi(serviceId: qty.servicesId, price: qty.price);
                    },
                  );
                },
                child: Icon(
                  FontAwesomeIcons.plus,
                  color: AppColors.border_color,
                  size: 15,
                )),
          ),
        ],
      ),
    );
  }

  _subTotalView() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 23),
      child: Row(
        children: [
          Expanded(
              child: Text(
                "Sub-total",
                style: TextStyle(fontSize: 14, color: Color(0xff666666)),
              )),
          Text(
            "\$ $subTotal",
            style: TextStyle(fontSize: 14, color: Color(0xff666666)),
          )
        ],
      ),
    );
  }

  _totalView() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 23),
      child: Row(
        children: [
          Expanded(
              child: Text(
                "Total",
                style: TextStyle(fontSize: 20, color: Colors.black,fontWeight: FontWeight.bold),
              )),
          Text(
            "\$ $total",
            style: TextStyle(fontSize: 20, color: Colors.black,fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }

  _bottomButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 23),
      child: CustomButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => CheckOutPage(price: "$total",)));
          },
          text: AppStrings.proceedToCheckOutText),
    );
  }
}



