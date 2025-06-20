import 'package:flutter/services.dart';
import 'package:jsochurch/utils/app_text_styles.dart';
import 'package:jsochurch/utils/globals.dart';
import 'package:jsochurch/utils/my_colors.dart';
import 'package:flutter/material.dart';
import 'package:jsochurch/utils/my_functions.dart';
import 'package:jsochurch/viewmodels/home_view_model.dart';
import 'package:jsochurch/viewmodels/login_view_model.dart';
import 'package:jsochurch/views/nav_bar.dart';
import 'package:jsochurch/views/select_parish_detail_view.dart';
import 'package:phone_form_field/phone_form_field.dart';
import 'package:pin_input_text_field/pin_input_text_field.dart';
import 'package:provider/provider.dart';

import '../widgets/text_fields.dart';
import '../widgets/text_widget.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginViewModel>(
      builder: (_,lv,__) {
        return Scaffold(
          backgroundColor: myWhite,
          body: SafeArea(
              child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
            child:Stack(
              children: [
                lv.isSendOtp?
                verifyOtpWidget(context):sendOtpWidget(context),
                !lv.isSendOtp? Positioned(
                  bottom: 10,
                  right: 10,
                  child: InkWell(
                    onTap: (){
                      // lv.update();
                      lv.loginSendOtp(context);
                    },
                    child: Container(
                      height: 48,
                      width: 48,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: buttonBlue,
                      ),
                      child: lv.showLoading
                          ? const Center(
                        child: SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            color: myWhite,
                          ),
                        ),
                      )
                          : const Icon(
                        Icons.arrow_forward_rounded,
                        color: myWhite,
                      ),
                    ),
                  ),
                ):SizedBox(),
               lv.isSendOtp? Positioned(
                  bottom: 10,
                  left: 10,
                  child: InkWell(
                    onTap: (){
                      lv.backToLogin();
                    },
                    child: Container(
                      height: 48,
                      width: 48,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: buttonBlue)
                      ),
                      child: const Icon(Icons.arrow_back_rounded,color: buttonBlue,),
                    ),
                  ),
                ):SizedBox(),
              ],
            ) ,
          )),
        );
      }
    );
  }

  Widget sendOtpWidget(BuildContext context){
    return Consumer<LoginViewModel>(
      builder: (_,lv,__) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            customBoldText(text: "Log in", color: myBlack, fontSize: 32),
            customNormalText(
                text: "Enter your mobile number",
                color: myGreyText,
                fontSize: 16),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: SizedBox(
                height: 50,
                child: PhoneFormField(
                  decoration: InputDecoration(
                    counterText: "",
                    counterStyle: const TextStyle(fontSize: 0),
                    hintText: "Enter your phone number",
                    hintStyle: const TextStyle(
                        fontFamily: 'Inter', fontSize: 16, color: myGreyText),
                    labelStyle: const TextStyle(
                        fontFamily: 'Inter', fontSize: 16, color: myBlack),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                    border: greyBorder,
                    enabledBorder: greyBorder,
                    focusedBorder: greyBorder,
                  ),
                  initialValue: PhoneNumber.parse('+91'),
                  countrySelectorNavigator:
                  const CountrySelectorNavigator.draggableBottomSheet(),
                  onChanged: (phoneNumber){
                    lv.setLoginUserName(phoneNumber);
                  },
                  enabled: true,
                  isCountrySelectionEnabled: true,
                  isCountryButtonPersistent: true,
                  countryButtonStyle: const CountryButtonStyle(
                      showDialCode: true,
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      showFlag: true,
                      textStyle: AppTextStyles.inter16BlackStyle,
                      flagSize: 16),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: customNormalText(text: "An SMS verification will be sent to you, and message and data rates may apply.", color: myGreyText, fontSize: 12),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15.0),
              child:lv.isContactUs&&appModel!=null? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ContactUsWidget(contactNo: appModel!.contactNo, contactEmail: appModel!.contactEmail),
                  const SizedBox(height: 5,),

                  // customNormalText(text: "Contact no: ${appModel!.contactNo}", color: buttonBlue, fontSize: 14),
                  // customNormalText(text: "e-Mail ID: ${appModel!.contactEmail}", color: buttonBlue, fontSize: 14),
                ],
              ):SizedBox(),
            )
          ],
        );
      }
    );
  }
  Widget verifyOtpWidget(BuildContext context){
    var height = MediaQuery.of(context).size.height;

    return Consumer<LoginViewModel>(
      builder: (_,lv,__) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(child: customBoldText(text: "Enter the code", color:myBlack, fontSize: 32)),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                child: customNormalTextCentered(text: "We sent you a 6 digit code at\n+${lv.countryCode} ${lv.phoneNumber}", color: myGreyText, fontSize: 12),
              ),
              const SizedBox(height:15,),
              Consumer2<HomeViewModel,LoginViewModel>(
                builder: (_,hv,lv,__) {
                  return PinInputTextField(
                    controller:lv.otpController,
                    pinLength: 6,
                    keyboardType: TextInputType.number,
                    cursor: Cursor(color: buttonBlue, height: 20, width: 2, enabled: true),
                    decoration: UnderlineDecoration(
                      textStyle: const TextStyle(
                        fontSize: 32,
                        color: myBlack,
                        fontFamily: "InterB",
                      ),
                      colorBuilder: PinListenColorBuilder(
                        Colors.blue,
                        myGreyText.withOpacity(0.25),
                      ),
                    ),
                    onChanged: (pin) {
                      if (pin.length == 6) {
                        hv.updateDioceseCount();
                        hv.updateOtherChurchCounts();
                        hv.updateClergyCounts();
                        lv.verification(context, pin);
                      }
                    },
                    onSubmit: (pin) {
                      print("Submitted OTP: $pin");
                    },
                  );
                }
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: InkWell(
                    onTap: (){
                      lv.loginSendOtp(context);
                    },
                    child: customBoldText(text: "Resend", color: buttonBlue, fontSize: 16)),
              )
            ],
          ),
        );
      }
    );
  }
}
class ContactUsWidget extends StatelessWidget {
  final String contactNo;
  final String contactEmail;

  ContactUsWidget({required this.contactNo, required this.contactEmail});

  @override
  Widget build(BuildContext context) {
    return SelectableText.rich(
      TextSpan(
        children: [
          const TextSpan(
            text: "If you are facing an issue in logging in please WhatsApp us on ",
            style: TextStyle(color: buttonBlue,fontSize: 14,fontFamily: "Inter"),
          ),
          WidgetSpan(
            child: GestureDetector(
              onTap: () {
                Clipboard.setData(ClipboardData(text: contactNo));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Phone number copied to clipboard")),
                );
              },
                child: customNormalText(text: contactNo, color: buttonBlue, fontSize: 14),

            ),
          ),
          const TextSpan(
            text: " or email ",
            style: TextStyle(color: buttonBlue,fontSize: 14,fontFamily: "Inter"),
          ),

          WidgetSpan(
            child: GestureDetector(
              onTap: () {
                Clipboard.setData(ClipboardData(text: contactEmail));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Email copied to clipboard")),
                );
              },
              child: customNormalText(text: contactEmail, color: buttonBlue, fontSize: 14),
            ),
          ),
        ],
      ),
      style: const TextStyle(fontSize: 16),
    );
  }
}