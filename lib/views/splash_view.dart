import 'package:flutter/material.dart';
import 'package:jsochurch/utils/my_functions.dart';
import 'package:jsochurch/viewmodels/splash_view_model.dart';
import 'package:jsochurch/views/login_view.dart';
import 'package:provider/provider.dart';

import '../utils/buttons.dart';
import '../utils/my_colors.dart';
import '../utils/app_text_styles.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SplashViewModel>(
      builder: (_,sp,__) {
        return Scaffold(
          backgroundColor: splashColor,
          body: SafeArea(child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                      child: Image.asset("assets/images/church_logo.png"),
                    ),
                    const Text("Welcome to the",style: AppTextStyles.interWhite18Style,),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12.0),
                      child: Text("Jacobite Syrian\nOrthodox Church\nDirectory!",style:AppTextStyles.inter32WhiteBoldStyle ,),
                    ),
                    const SizedBox(height: 10,),
                    const Text("Connecting you with our faith and community.",style:AppTextStyles.interWhite18Style,),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0,vertical: 20),
                child: Center(
                  child: MyElevatedButton(
                    height: 45,
                    width: double.infinity,
                    onPressed: () {
                      // sp.update();
                      sp.setInitialPage();
                      callNextReplacement(const LoginView(), context);
                    },
                    borderRadius:
                    const BorderRadius.all(
                        Radius.circular(60)),
                    child:const Text(
                      "Get Started",
                      style:AppTextStyles.inter16WhiteStyle
                    ),
                  ),
                ),
              )
            ],
          )),
        );
      }
    );
  }

}
