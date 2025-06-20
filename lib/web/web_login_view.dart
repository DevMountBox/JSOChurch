import 'package:flutter/material.dart';
import 'package:jsochurch/utils/my_colors.dart';
import 'package:jsochurch/viewmodels/login_view_model.dart';
import 'package:jsochurch/viewmodels/select_diocese_view_model.dart';
import 'package:provider/provider.dart';
import 'package:sms_autofill/sms_autofill.dart';

import '../utils/app_text_styles.dart';

class WebLoginView extends StatelessWidget {
  const WebLoginView({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    final FocusNode _pinPutFocusNode = FocusNode();

    return Consumer<LoginViewModel>(builder: (_, lv, __) {
      return Scaffold(
          body: SizedBox(
        height: height,
        child: Column(children: [
          Container(
            height: 15,
            width: width,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  gradientBlue1,
                  gradientBlue2,
                ],
              ),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 5,
                child: Container(
                    height: height - 15,
                    decoration: const BoxDecoration(
                        color: gradientBlue1),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 50.0),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 15.0),
                              child:
                                  Image.asset("assets/images/church_logo.png"),
                            ),
                            const Text(
                              "Welcome to the",
                              style: AppTextStyles.interWhite18Style,
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 12.0),
                              child: Text(
                                "Jacobite Syrian\nOrthodox Church\nDirectory!",
                                style: AppTextStyles.inter32WhiteBoldStyle,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const Text(
                              "Connecting you with our faith and community.",
                              style: AppTextStyles.interWhite18Style,
                            ),
                          ],
                        ),
                      ),
                    )),
              ),
              Expanded(
                flex: 3,
                child: SizedBox(
                  height: height - 15,
                  child: Padding(
                    padding: EdgeInsets.all(width * 0.05),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Image.asset(
                        //   "assets/images/logogbs.png",
                        //   scale: 8,
                        // ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "PHONE NUMBER",
                              style: TextStyle(
                                  fontFamily: "Poppins",
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 3,
                            ),
                            SizedBox(
                              height: 40,
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 7,
                                    child: TextField(
                                      controller: lv.webUserController,
                                      maxLength: 10,
                                      style: const TextStyle(
                                          fontFamily: "Poppins", fontSize: 12),
                                      decoration: InputDecoration(
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 10),
                                          counterText: "",
                                          enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: myGreyText
                                                      .withOpacity(0.2),
                                                  width: 1.0),
                                              borderRadius:
                                                  BorderRadius.circular(3)),
                                          border: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                  color: myRed, width: 1.0),
                                              borderRadius:
                                                  BorderRadius.circular(3)),
                                          hintText: "Phone number",
                                          hintStyle:
                                              const TextStyle(fontSize: 12)),
                                      onChanged: (text){
                                        lv.setLoginUserNameWeb(text);
                                      },
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: InkWell(
                                      onTap: () async {
                                        lv.loginSendOtp(context);
                                      },
                                      child: Container(
                                        height: 40,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: myGreyText
                                                    .withOpacity(0.2)),
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(5))),
                                        child: lv.showLoading
                                            ? const SizedBox(
                                                child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 10.0,
                                                    vertical: 8),
                                                child:
                                                    CircularProgressIndicator(),
                                              ))
                                            : const Icon(Icons.arrow_forward),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            const Text(
                              "OTP",
                              style: TextStyle(
                                  fontFamily: "Poppins",
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 3,
                            ),
                            Consumer<SelectDioceseViewModel>(
                              builder: (_,dv,__) {
                                return SizedBox(
                                  height: 40,
                                  child: PinFieldAutoFill(
                                    codeLength: 6,
                                    focusNode: _pinPutFocusNode,
                                    keyboardType: TextInputType.number,
                                    controller: lv.otpController,
                                    currentCode: "",
                                    // cursor: Cursor(color: myBlack,enabled: true),
                                    decoration: BoxLooseDecoration(
                                        textStyle:
                                            const TextStyle(color: Colors.black),
                                        radius: const Radius.circular(5),
                                        strokeColorBuilder: FixedColorBuilder(
                                            myGreyText.withOpacity(0.2))),
                                    onCodeChanged: (pin) {
                                      if (pin!.length == 6) {
                                        lv.verification(context, pin,dv: dv);
                                      }
                                    },
                                  ),
                                );
                              }
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ]),
      ));
    });
  }
}
