import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:jsochurch/viewmodels/select_diocese_view_model.dart';
import 'package:jsochurch/views/splash_view.dart';
import 'package:jsochurch/web/web_home_view.dart';
import 'package:jsochurch/web/web_login_view.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/appModel.dart';
import '../models/user_model.dart';
import '../utils/globals.dart';
import '../utils/my_functions.dart';
import '../views/login_view.dart';
import '../views/nav_bar.dart';
import '../views/select_parish_detail_view.dart';
import '../views/update_view.dart';
import 'home_view_model.dart';
import 'login_view_model.dart';

class SplashViewModel extends ChangeNotifier{
  int appVersion=7;
  String appViewVersion="1.0.6";

  Future<void> setInitialPage() async {
    SharedPreferences userPreference = await SharedPreferences.getInstance();

    userPreference.setString("initial", "1");

  }
  Future<void> checkLatestUpdate(BuildContext context) async {
    SharedPreferences userPreference = await SharedPreferences.getInstance();
    String? initial = userPreference.getString("initial");

    DatabaseEvent rootEvent = await mRoot.child("0").once();
    Map<dynamic, dynamic> rootMap = rootEvent.snapshot.value != null
        ? rootEvent.snapshot.value as Map
        : {};

    appModel = AppModel(
      rootMap['appName']?.toString() ?? '',
      rootMap['appDesc']?.toString() ?? '',
      rootMap['appLink']?.toString() ?? '',
      rootMap['contactNo']?.toString() ?? '',
      rootMap['contactMail']?.toString() ?? '',
    );

    if (initial == null || rootMap.isEmpty) {
      navigateToScreen(const SplashScreen(), context);
      return;
    }

    int parsedUpdate = int.tryParse(rootMap['update']?.toString().trim() ?? '0') ?? 0;
    if (parsedUpdate > appVersion) {
      navigateToScreen(
        UpdateView(
          text: rootMap['text']?.toString() ?? '',
          button: rootMap['button']?.toString() ?? '',
          address: rootMap['address']?.toString() ?? '',
        ),
        context,
      );
      return;
    }

    await Future.delayed(const Duration(seconds: 3));
    String? mobileNumber = userPreference.getString("mobileNumber");

    if (mobileNumber == null) {
      navigateToScreen(const LoginView(), context);
      return;
    }

    DatabaseEvent loginEvent = await mRoot.child("logins").child(mobileNumber).once();
    if (!loginEvent.snapshot.exists) {
      navigateToScreen(const LoginView(), context);
      return;
    }

    Map<dynamic, dynamic> loginMap = loginEvent.snapshot.value as Map;
    String userId = loginMap["userId"].toString();

    DatabaseEvent userEvent = await mRoot.child("users").child(userId).once();
    if (!userEvent.snapshot.exists) {
      navigateToScreen(const LoginView(), context);
      return;
    }

    Map<dynamic, dynamic> userMap = userEvent.snapshot.value as Map;

    loginUser = UserModel(
      userId: userId,
      fatherName: userMap['fatherName'] ?? '',
      type: userMap['type'] ?? '',
      primaryAt: userMap['primaryAt'] ?? '',
      primaryAtId: userMap['primaryAtId'] ?? '',
      secondaryVicarAt: userMap['secondaryVicarAt'] ?? '',
      secondaryVicarAtId: userMap['secondaryVicarAtId'] ?? '',
      dioceseSecretary: userMap['assistantAt'] ?? '',
      dioceseSecretaryId: userMap['assistantAtId'] ?? '',
      phoneNumber: userMap['phoneNumber'] ?? '',
      secondaryNumber: userMap['secondaryNumber'] ?? '',
      emailId: userMap['emailId'] ?? '',
      presentAddress: userMap['presentAddress'] ?? '',
      permanentAddress: userMap['permanentAddress'] ?? '',
      place: userMap['place'] ?? '',
      district: userMap['district'] ?? '',
      state: userMap['state'] ?? '',
      motherParish: userMap['motherParish'] ?? '',
      dob: formatDate(userMap['dob']) ?? '',
      bloodGroup: userMap['bloodGroup'] ?? '',
      ordination: "${userMap['ordinationBy'] ?? ''} on ${formatDate(userMap['ordinationDate']) ?? ''}",
      positions: userMap['positions'] ?? '',
      status: userMap['status'] ??0,
      image: userMap['image'] ?? '',
    );
    if (userMap['status'] != 0) {
      callNextReplacement(NavbarView(), context);
    } else {
      if(userMap['type']!="metropolitans") {
        callNextReplacement(const SelectParishDetailView(), context);
      }else{
        callNextReplacement(NavbarView(), context);

      }
  }
  }

  void navigateToScreen(Widget screen, BuildContext context) {
    callNextReplacement(screen, context);
  }

  Future<void> getSharedPrefWeb(BuildContext context,{SelectDioceseViewModel? dv})async {
    SharedPreferences userPreference = await SharedPreferences.getInstance();

    await Future.delayed(const Duration(seconds: 3));
    String? mobileNumber = userPreference.getString("mobileNumber");
      print(mobileNumber.toString()+"  :mob:");
    if (mobileNumber == null) {
      navigateToScreen(const WebLoginView(), context);
      return;
    }

    DatabaseEvent loginEvent = await mRoot.child("logins").child(mobileNumber).once();
    if (!loginEvent.snapshot.exists) {
      navigateToScreen(const WebLoginView(), context);
      return;
    }

    Map<dynamic, dynamic> loginMap = loginEvent.snapshot.value as Map;
    int userType = loginMap["type"] ?? 0;
    String userId = loginMap["userId"].toString();
    userTypeGlobal=userType;
    notifyListeners();
    DatabaseEvent userEvent = await mRoot.child("users").child(userId).once();
    if (!userEvent.snapshot.exists) {
      navigateToScreen(const WebLoginView(), context);
      return;
    }

    Map<dynamic, dynamic> userMap = userEvent.snapshot.value as Map;
    loginUser = UserModel(
      userId: userId,
      fatherName: userMap['fatherName'] ?? '',
      type: userMap['type'] ?? '',
      primaryAt: userMap['primaryAt'] ?? '',
      primaryAtId: userMap['primaryAtId'] ?? '',
      secondaryVicarAt: userMap['secondaryVicarAt'] ?? '',
      secondaryVicarAtId: userMap['secondaryVicarAtId'] ?? '',
      dioceseSecretary: userMap['assistantAt'] ?? '',
      dioceseSecretaryId: userMap['assistantAtId'] ?? '',
      phoneNumber: userMap['phoneNumber'] ?? '',
      secondaryNumber: userMap['secondaryNumber'] ?? '',
      emailId: userMap['emailId'] ?? '',
      presentAddress: userMap['presentAddress'] ?? '',
      permanentAddress: userMap['permanentAddress'] ?? '',
      place: userMap['place'] ?? '',
      district: userMap['district'] ?? '',
      state: userMap['state'] ?? '',
      motherParish: userMap['motherParish'] ?? '',
      dob: formatDate(userMap['dob']) ?? '',
      bloodGroup: userMap['bloodGroup'] ?? '',
      ordination: "${userMap['ordinationBy'] ?? ''} on ${formatDate(userMap['ordinationDate']) ?? ''}",
      positions: userMap['positions'] ?? '',
      status: userMap['status'] ?? 0,
      image: userMap['image'] ?? '',
    );
    if(userType==2){
      if(dv!=null){
        print("diocese working");
        dv.getDioceses();
      }
      isSecretaryAdminLogin=false;
      secretaryDioceseIdAdmin="";
      notifyListeners();
    navigateToScreen( WebHomeView() , context);
  }else if(loginUser!.dioceseSecretaryId!=""){
        isSecretaryAdminLogin=true;
        secretaryDioceseIdAdmin=loginUser!.dioceseSecretaryId;
        notifyListeners();
        if(dv!=null){
          dv.getDioceses();
        }
        callNextReplacement(WebHomeView(), context);


    }else{
      navigateToScreen( WebLoginView() , context);

    }
  }

}