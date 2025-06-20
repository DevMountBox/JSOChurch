
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jsochurch/viewmodels/home_view_model.dart';
import 'package:jsochurch/viewmodels/select_diocese_view_model.dart';
import 'package:jsochurch/widgets/text_widget.dart';
import 'package:provider/provider.dart';

import '../utils/app_text_styles.dart';
import '../utils/buttons.dart';
import '../utils/globals.dart';
import '../utils/my_colors.dart';
import '../viewmodels/splash_view_model.dart';

class InitialSplashView extends StatefulWidget {
  const InitialSplashView({super.key});

  @override
  _InitialSplashViewState  createState() => _InitialSplashViewState ();
}

class _InitialSplashViewState extends State<InitialSplashView> {
  @override
  void initState() {
    super.initState();
    SplashViewModel splashViewModel =
    Provider.of<SplashViewModel>(context, listen: false);
    SelectDioceseViewModel dioceseViewModel =
    Provider.of<SelectDioceseViewModel>(context, listen: false);
    HomeViewModel homeViewModel =
    Provider.of<HomeViewModel>(context, listen: false);
    Future.delayed(const Duration(seconds: 1), () {
      if(mounted){
        if(!kIsWeb) {
          homeViewModel.multiDioceseData();
          homeViewModel.getBigFathers();
          homeViewModel.updateDioceseCount();
          homeViewModel.updateOtherChurchCounts();
          homeViewModel.updateClergyCounts();
          splashViewModel.checkLatestUpdate(context);
        }else{
          splashViewModel.getSharedPrefWeb(context,dv: dioceseViewModel);
        }
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Consumer<SplashViewModel>(
      builder: (_, sv, __) {
        return  Scaffold(
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                customNormalText(text: "version ${sv.appViewVersion}", color: myWhite, fontSize: 14),
              ],
            ),
          ),
          backgroundColor: splashColor,
          body: SafeArea(child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  Image.asset("assets/images/church_logo.png"),
                ],
              ),
              SizedBox(height: 80,),
              CircularProgressIndicator(color: myWhite,)
            ],
          )),
        );
      },
    );
  }
}