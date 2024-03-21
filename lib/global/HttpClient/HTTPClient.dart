import 'dart:convert';
import 'dart:io';

import 'package:rassasy_new/global/global.dart';
import 'package:rassasy_new/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
Future salesOrderDeliverToDelivered({context,required tableID}) async {
  final response;
  try {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var basePath = BaseUrl.baseUrl;
    final token = prefs.getString('token');
    String url = basePath+'pos-table-reserve/';

    Map data = {"DeliveryManID":tableID};
    print(data);
    print(url);
    var body = json.encode(data);
    var response = await http.post(Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer $token',
        },body:body);


    Map n = json.decode(utf8.decode(response.bodyBytes));
    var status = n["StatusCode"];
    var msg = n["message"];
    return [status,msg];
  } catch (e) {

    print(e.toString());
    return [5000,"Error"];

  }
}


Future createWaiterPOS({context,required waiterName,required waiterId,required staffType}) async {
  final response;
  try {

    myLog(waiterId);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var basePath = BaseUrl.baseUrl;


    String url = basePath+'/posholds/create-pos-hold-staff/';

    if(waiterId !=""){
      url = basePath+'/posholds/update-pos-hold-staff/';
    }
    myLog(url);
    var userID = prefs.getInt('user_id') ?? 0;
    var accessToken = prefs.getString('access') ?? '';
    var companyID = prefs.getString('companyID') ?? 0;
    var branchID = prefs.getInt('branchID') ?? 1;
    Map data = {
      "id":waiterId,
      "CompanyID": companyID,
      "CreatedUserID":userID,
      "staff_type":staffType,
      "BranchID":branchID,
      "name":waiterName};
    myLog(accessToken);
    myLog(data);

    print(url);
    var body = json.encode(data);
    var response = await http.post(Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer $accessToken',
        },body:body);


    Map n = json.decode(utf8.decode(response.bodyBytes));
    print(response.body);
    var status = n["StatusCode"];
    var msg = n["message"];
    return [status,msg];
  } catch (e) {

    print(e.toString());
    return [5000,"Error"];

  }
}
Future defaultDataInitial({context}) async {

  final response;
  try {
    start(context);
    HttpOverrides.global = MyHttpOverrides();
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var userID = prefs.getInt('user_id') ?? 0;
    var companyID = prefs.getString('companyID') ?? 0;
    var branchID = prefs.getInt('branchID') ?? 1;
    var accessToken = prefs.getString('access') ?? '';

    String baseUrl = BaseUrl.baseUrl;

    final String url = '$baseUrl/users/get-default-values/';
    print(url);
    Map data = {"CompanyID": companyID, "userId": userID, "BranchID": branchID};
    print(data);
    print(accessToken);
    //encode Map to JSON
    var body = json.encode(data);
    var response = await http.post(Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer $accessToken',
        },
        body: body);
    Map n = json.decode(response.body);
    print(response.body);


    var status = n["StatusCode"];
    var msg = n["message"];
    if(status ==6000){
      stop();
      var frmDate = n["financial_FromDate"].substring(0, 10);
      var toDate = n["financial_ToDate"].substring(0, 10);
      prefs.setString("financial_FromDate", frmDate);
      prefs.setString("financial_ToDate", toDate);
      prefs.setString("Country", n["Country"]);
      prefs.setString("CountryName", n["CountryName"]);
      prefs.setString("State", n["State"]);
      prefs.setString("CurrencySymbol", n["CurrencySymbol"]);
      var settingsData = n['settingsData'];
      prefs.setBool("checkVat", settingsData["VAT"]);
      prefs.setBool("check_GST", settingsData["GST"]);
      prefs.setString("QtyDecimalPoint", settingsData["QtyDecimalPoint"]);
      prefs.setString("PriceDecimalPoint", settingsData["PriceDecimalPoint"]);
      prefs.setString("RoundingFigure", settingsData["RoundingFigure"]);
      prefs.setInt("user_type", n["user_type"]);
    }
    else{
      stop();
    }
    return [status,msg];
  } catch (e) {
    stop();
    print(e.toString());
    return [5000,"Error"];

  }
}




