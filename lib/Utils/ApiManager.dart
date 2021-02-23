import 'dart:convert';
import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart'as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:via_court/Constants/AppStrings.dart';
import 'package:via_court/Models/CartItemModel.dart';
import 'package:via_court/Models/CourtListModel.dart';
import 'package:via_court/Provider/CourtProvider.dart';

class ApiManager {

  static Future<bool> checkInternet() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {


      return false;
    } else {
      return true;
    }
  }


  getCall(
      String url) async {
    // var headers;
    // if (prefs.getString(AppStrings.ACCESSTOKEN_PREF_KEY) == null) {
    //   headers = {"Accept": "application/json"};
    // } else {
    //   AccessTokenResponse user = AccessTokenResponse.fromJson(
    //       jsonDecode(prefs.getString(AppStrings.ACCESSTOKEN_PREF_KEY)));
    //   headers = {
    //     "Accept": "application/json",
    //     "Authorization": user.data.tokenType + " " + user.data.accessToken
    //   };
    // }
    // var uri = Uri.parse(url);
    // uri = uri.replace(queryParameters: request);
    // print(uri);
    // AtarkeLogs.debugging(headers);

    http.Response response = await http.get(url);
    print("this is the resposne ${response.body}");
    print(response.headers);
    // if (response.statusCode == 401) {
    //
    // } else {
    //
    //
    // }
    return await jsonDecode(response.body);
  }

  getCallwithheader(
      String url) async {
    var headers;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString(AppStrings.TOKEN_KEY) == null) {
      headers = {"Accept": "application/json"};
    } else {
      String user = prefs.getString(AppStrings.TOKEN_KEY);
      print(user);
      // headers = {HttpHeaders.contentTypeHeader: "Application/json", "authorization": "Bearer $user"};
    }

    http.Response response = await http.get(url,headers: {"Accept": "application/json", "Authorization": "Bearer ${prefs.getString(AppStrings.TOKEN_KEY)}"});
    print(response.headers);

    print(url);
    print(response.body);

    return await jsonDecode(response.body);
  }

  postCall(String url, Map request, BuildContext context) async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    var headers;
    // if (prefs.getString(AppStrings.TOKEN_KEY) == null) {
    //   headers = {"Accept": "application/json"};
    // } else {
    //   String user = prefs.getString(AppStrings.TOKEN_KEY);
    //   print(user);
    //
    print("request " + request.toString());
    headers = {"Accept": "application/json"};
    // }

    http.Response response =
    await http.post(url, body: request, headers: headers);
    print(response.body);
    print("this is the header : ${response.headers}");
    if (response.statusCode == 401) {
    } else {
      return await json.decode(response.body);
    }
  }
  postCallWithHeader(String url, Map request, BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(url);

    var headers;
    if (prefs.getString(AppStrings.TOKEN_KEY) == null) {
      headers = {"Accept": "application/json"};
    } else {
      String user = prefs.getString(AppStrings.TOKEN_KEY);
      print(user);
    //
    print("request " + request.toString());
    headers = {"Accept": "application/json","Authorization": "Bearer $user"};
    }

    http.Response response =
    await http.post(url, body: request, headers: headers);
    print(response.body);
    if (response.statusCode == 401) {
    } else {
      return await json.decode(response.body);
    }
  }


}