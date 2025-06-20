import 'package:flutter/material.dart';
import 'package:jsochurch/utils/my_colors.dart';
import 'package:jsochurch/viewmodels/clergy_view_model.dart';
import 'package:jsochurch/viewmodels/select_church_view_model.dart';
import 'package:jsochurch/viewmodels/select_diocese_view_model.dart';
import 'package:jsochurch/views/church_view.dart';
import 'package:jsochurch/views/diocese_view.dart';
import 'package:jsochurch/views/login_view.dart';
import 'package:jsochurch/views/select_churches_view.dart';
import 'package:jsochurch/views/clergy_view.dart';
import 'package:jsochurch/views/select_diocese_view.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:provider/provider.dart';

import '../utils/my_flutter_app_icons.dart';
import '../viewmodels/home_view_model.dart';
import 'home_view.dart';

class NavbarView extends StatefulWidget {
  const NavbarView({super.key});

  @override
  State<NavbarView> createState() => _NavbarViewState();
}

class _NavbarViewState extends State<NavbarView> {
  int _currentIndex = 0;

  final PersistentTabController _controller =
      PersistentTabController(initialIndex: 0);

  void changePage(int index) {
    setState(() {
      _currentIndex = index;
      if (index == 0) {
        final hv = Provider.of<HomeViewModel>(context, listen: false);
      } else if (index == 1) {
        final cv = Provider.of<SelectChurchViewModel>(context, listen: false);
        final dv = Provider.of<SelectDioceseViewModel>(context, listen: false);
        cv.getChurches();
        dv.getDioceses();
      } else if (index == 2) {
        final sv = Provider.of<SelectDioceseViewModel>(context, listen: false);
        sv.getDioceses();
      } else if (index == 3) {
        final cv = Provider.of<ClergyViewModel>(context, listen: false);
        cv.setTabIndex(0);
        cv.getClergyList(cv.clergyType);
      }
    });
  }

  final pages = [
    const HomeView(),
    const ChurchView(
      title: "Churches",
    ),
    const DioceseView(),
    const ClergyView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeViewModel>(builder: (_, nv, __) {
      return Scaffold(
        backgroundColor: myWhite,
        resizeToAvoidBottomInset: false,
        body: PersistentTabView(
          context,
          controller: _controller,
          screens: pages,
          navBarHeight: 60,
          items: _navBarsItems(),
          onItemSelected: changePage,
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
          backgroundColor: Colors.white,
          handleAndroidBackButtonPress: true,
          resizeToAvoidBottomInset: false,
          stateManagement: true,
          hideNavigationBarWhenKeyboardAppears: true,
          decoration: NavBarDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.25),
                blurRadius: 15,
                offset: const Offset(0.0, 1.0),
              ),
            ],
            borderRadius: BorderRadius.circular(10.0),
            colorBehindNavBar: Colors.white,
          ),
          animationSettings: const NavBarAnimationSettings(
              screenTransitionAnimation: ScreenTransitionAnimationSettings(
            // Screen transition animation on change of selected tab.
            animateTabTransition: false,
            curve: Curves.ease,
            duration: Duration(milliseconds: 200),
          )),
          navBarStyle: NavBarStyle.style8,
        ),
      );
    });
  }

  List<PersistentBottomNavBarItem> _navBarsItems() => [
        PersistentBottomNavBarItem(
          icon: const Icon(MyFlutterApp.home),
          title: "Home",
          iconSize: 25,
          activeColorPrimary: buttonBlue,
          inactiveColorPrimary: Colors.grey,
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(MyFlutterApp.church),
          title: "Church",
          iconSize: 25,
          activeColorPrimary: buttonBlue,
          inactiveColorPrimary: Colors.grey,
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(MyFlutterApp.diocese),
          title: "Diocese",
          iconSize: 25,
          activeColorPrimary: buttonBlue,
          inactiveColorPrimary: Colors.grey,
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(MyFlutterApp.clergy),
          title: "Clergy",
          iconSize: 25,
          activeColorPrimary: buttonBlue,
          inactiveColorPrimary: Colors.grey,
        ),
      ];

  Widget navbarIcon(String icon) {
    return SizedBox(
      height: 25,
      width: 25,
      child: Image.asset("assets/images/$icon.png"),
    );
  }
}
