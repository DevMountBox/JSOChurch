import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jsochurch/viewmodels/select_diocese_view_model.dart';
import 'package:jsochurch/views/nav_bar.dart';
import 'package:jsochurch/views/select_parish_detail_view.dart';
import 'package:phone_form_field/phone_form_field.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_model.dart';
import '../utils/globals.dart';
import '../utils/my_functions.dart';
import '../views/home_view.dart';
import '../web/web_home_view.dart';
enum MobileVerificationState {
  showMobileFormState,
  showOtpFormState,
}
class LoginViewModel extends ChangeNotifier{
  TextEditingController webUserController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  String userNameController = "";
  String countryCode="";

  bool isSendOtp=false;
bool isLoading=false;
  bool isRegistered = false;
  bool isContactUs=false;

bool showLoading = false;
String verificationId="";
String code = "";
String phoneNumber="";
MobileVerificationState currentState =
    MobileVerificationState.showMobileFormState;


void sendOtp(){
  isSendOtp=true;
  notifyListeners();
}
void backToLogin(){
  isSendOtp=false;
  notifyListeners();
}
void signInWithPhoneAuthCredential(BuildContext context,
    PhoneAuthCredential phoneAuthCredential, {SelectDioceseViewModel? dv}) async {

  showLoading = true;
  notifyListeners();

  try {
    final authCredential =
    await auth.signInWithCredential(phoneAuthCredential);


    showLoading = false;
    notifyListeners();
    if (authCredential.user != null) {
      userAuthorized(context,phoneNumber,dv: dv);
    }
  } on FirebaseAuthException catch (e) {
    showLoading = false;
    notifyListeners();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Colors.redAccent,
      content: Text(
        e.message ?? "",
        style: TextStyle(color: Colors.black87),
      ),
    ));
  }
}


Future<void> userAuthorized(BuildContext context,String phoneNumber,
    {SelectDioceseViewModel? dv}) async {

  mRoot.child("logins").child(phoneNumber).once().then((event) async {
    if (event.snapshot.exists) {
      SharedPreferences userPreference = await SharedPreferences.getInstance();
      Map<dynamic, dynamic> loginMap = event.snapshot.value as Map;
      String userId = loginMap["userId"].toString();
      int userType = loginMap["type"] ?? 0;
      userTypeGlobal=userType;
      notifyListeners();
      if(userType!=2){

        mRoot
          .child("users")
          .child(userId)
          .onValue
          .listen((event2) {
        if (event2.snapshot.exists) {
          print("working auth");
          Map<dynamic, dynamic> userMap = event2.snapshot.value as Map;
          String formattedDob = formatDate(userMap['dob']);
          String formattedOrdination = formatDate(userMap['ordinationDate']);

          UserModel churchFather = UserModel(
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
            dob: formattedDob ?? '',
            bloodGroup: userMap['bloodGroup'] ?? '',
            ordination: "${userMap['ordinationBy'] ?? ''} on ${formattedOrdination ?? ''}",
            positions: userMap['positions'] ?? '',
            status: userMap['status'] ?? 0,
            image: userMap['image'] ?? '',
          );

          isLoading = false;

          loginUser = churchFather;

          userPreference.setString("mobileNumber", phoneNumber);
          userPreference.setString("userId", userId);

          if (!kIsWeb) {
            if (loginUser!.status != 0) {
              callNextReplacement(NavbarView(), context);
            } else {
              if(loginUser!.type!="metropolitans") {
                callNextReplacement(const SelectParishDetailView(), context);
              }else{
                callNextReplacement(NavbarView(), context);

              }
            }
          }else if(loginUser!.dioceseSecretaryId!=""){
            isSecretaryAdminLogin=true;
            secretaryDioceseIdAdmin=loginUser!.dioceseSecretaryId;
            notifyListeners();
            if(dv!=null){
              dv.getDioceses();
            }
            callNextReplacement(WebHomeView(), context);

          }
          notifyListeners();
        } else {
          isLoading = false;
          notifyListeners();
        }
      });
    }else{
        userPreference.setString("mobileNumber", phoneNumber);
        userPreference.setString("userId", userId);
        isSecretaryAdminLogin=false;
        secretaryDioceseIdAdmin="";
        if(dv!=null){
          dv.getDioceses();
        }
        notifyListeners();
        callNextReplacement(WebHomeView(), context);
      }
    } else {
      isLoading = false;
      notifyListeners();
    }
  });
}
void verification(BuildContext context,String pin, {SelectDioceseViewModel? dv}){
  PhoneAuthCredential
  phoneAuthCredential =
  PhoneAuthProvider
      .credential(
      verificationId:
      verificationId,
      smsCode: pin);
  signInWithPhoneAuthCredential(context,
      phoneAuthCredential,dv: dv);
  otpController.text = pin;
  code = pin;
  notifyListeners();

}
void setLoginUserName(PhoneNumber phone){
  userNameController=phone.nsn;
  countryCode=phone.countryCode;
  notifyListeners();
}
void setLoginUserNameWeb(String phone){
  userNameController=phone;
  countryCode="91";
  notifyListeners();
}

Future<void> loginSendOtp(BuildContext context) async {
  if (userNameController.length == 10) {
    isContactUs=false;
    otpController.clear();
    notifyListeners();
    await checkIsRegistered(userNameController);
    showLoading = true;
    phoneNumber = userNameController;
    notifyListeners();
    if( isRegistered) {
        print("+$countryCode$userNameController");
      await auth.verifyPhoneNumber(
        timeout: const Duration(seconds: 5),
        phoneNumber: "+$countryCode$userNameController",
        verificationCompleted: (phoneAuthCredential) async {

          showLoading = false;
          notifyListeners();
        },
        verificationFailed: (verificationFailed) async {
          isContactUs=true;
          showLoading = false;
          notifyListeners();
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(
                      verificationFailed.message ?? "")));
        },
        codeSent: (verificationId, resendingToken) async {
          showLoading = false;
          currentState =
              MobileVerificationState.showOtpFormState;
          this.verificationId = verificationId;
          isSendOtp=true;

          notifyListeners();
        },
        codeAutoRetrievalTimeout: (verificationId) async {},
      );
    }else{
      showLoading = false;
      isContactUs=true;
      notifyListeners();
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(
        backgroundColor: Colors.red,
        content: Text(
          "You are not a registered user !",
          style: TextStyle(color: Colors.white),
        ),
      ));
    }
  } else {
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(
      backgroundColor: Colors.redAccent,
      content: Text(
        "Please enter valid hone number",
        style: TextStyle(color: Colors.white),
      ),
    ));
  }
}
Future<void> checkIsRegistered(String phoneNumber) async {
  isRegistered=false;
  notifyListeners();
  print(phoneNumber);
  await mRoot
      .child("logins")
      .child(phoneNumber)
      .once()
      .then(( event) async {
    if (event.snapshot.exists) {
      print("object");

      isRegistered=true;
      notifyListeners();
    }});
}
  void clearSharedPreference() async {
    currentState =
        MobileVerificationState.showMobileFormState;
    isSendOtp=false;
     userNameController = "";
     countryCode="";
     isLoading=false;
     isRegistered = false;
     showLoading = false;
     verificationId="";
     code = "";
     phoneNumber="";

    notifyListeners();
    SharedPreferences userPreference = await SharedPreferences.getInstance();
    userPreference.clear();
    userPreference.setString("initial", "1");
  }
}