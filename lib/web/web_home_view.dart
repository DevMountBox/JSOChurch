import 'package:flutter/material.dart';
import 'package:jsochurch/utils/alert_diologs.dart';
import 'package:jsochurch/utils/my_colors.dart';
import 'package:jsochurch/viewmodels/clergy_view_model.dart';
import 'package:jsochurch/viewmodels/select_church_view_model.dart';
import 'package:jsochurch/viewmodels/select_diocese_view_model.dart';
import 'package:jsochurch/web/church_upload_view.dart';
import 'package:jsochurch/web/diocese_upload_view.dart';
import 'package:jsochurch/web/father_upload_view.dart';
import 'package:jsochurch/web/view_models/web_view_model.dart';
import 'package:provider/provider.dart';

import '../utils/globals.dart';
import '../viewmodels/login_view_model.dart';

class WebHomeView extends StatelessWidget {
  const WebHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    List<BottomNavigationBarItem> navBarAdmItems = [
      BottomNavigationBarItem(
        backgroundColor: Colors.white,
        icon: Image.asset(
          "assets/images/diocese.png",
          color: Colors.white70,
        ),
        activeIcon: Image.asset(
          "assets/images/diocese.png",
          color: Colors.blue,
        ),
        label: 'Dioceses',
      ),
      BottomNavigationBarItem(
        backgroundColor: Colors.white,
        icon: Image.asset(
          "assets/images/church.png",
          color: Colors.white70,
        ),
        activeIcon: Image.asset(
          "assets/images/church.png",
          color: Colors.blue,
        ),
        label: 'Churches',
      ),
      BottomNavigationBarItem(
        backgroundColor: Colors.white,
        icon: Image.asset(
          "assets/images/clergy.png",
          color: Colors.white70,
        ),
        activeIcon: Image.asset(
          "assets/images/clergy.png",
          color: Colors.blue,
        ),
        label: 'Clergy',
      ),
    ];

    return PopScope(
        child: Material(
          type: MaterialType.transparency,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: width,
                  height: 50,
                  alignment: Alignment.centerLeft,
                  decoration: const BoxDecoration(
                    color: Colors.white,

                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 30.0),
                        child: Image.asset("assets/images/church_logo.png", scale: 2),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 20.0),
                        child: Row(
                          children: [
                            loginUser != null

                                ? Text(loginUser!.fatherName.toUpperCase())
                                : const Text("User"),
                            Consumer<LoginViewModel>(builder: (context, lv, child) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: PopupMenuButton<String>(
                                  position: PopupMenuPosition.under,
                                  icon: const Icon(
                                    Icons.keyboard_arrow_down,
                                  ), // The icon for the button
                                  itemBuilder: (context) => [
                                    const PopupMenuItem<String>(
                                      value: "logout",
                                      child: Row(
                                        children: [
                                          Icon(Icons.logout, color: Colors.black),
                                          SizedBox(width: 8),
                                          Text("Logout"),
                                        ],
                                      ),
                                    ),
                                  ],
                                  onSelected: (value) {
                                    if (value == "logout") {
                                      logoutDialog(context, "Do you want to Logout?", "Logout");
                                    }
                                  },
                                ),
                              );
                            })
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                    padding: EdgeInsets.only(
                        left: width * 0.01,
                        right: width * 0.01,
                        top: height * 0.01,
                        bottom: height * 0.01),
                    width: width,
                    height: height-50,
                    alignment: Alignment.centerLeft,

                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Consumer<WebViewModel>(
                            builder: (_, wv, __) {
                              return
                                // loginUser != null ?
                                Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  gradient: const LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      gradientBlue1,
                                      gradientBlue2
                                    ],
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Consumer3<SelectDioceseViewModel,SelectChurchViewModel,ClergyViewModel>(
                                      builder: (_,dv,cv,clv,__) {
                                        return Flexible(
                                          child: NavigationRail(
                                            useIndicator: true,
                                            indicatorColor: Colors.white,
                                            backgroundColor:
                                            Colors.transparent,
                                            selectedIndex:wv.currentPage,
                                            onDestinationSelected:
                                                (int index) {
                                              wv.changeNavPage(index);
                                              cv.clearBothDioceseAndRegion();
                                              if(index==0){
                                              dv.getDioceses();

                                              }else if(index==1){
                                                if(isSecretaryAdminLogin){
                                                  if(dv.dioceseList.isNotEmpty) {
                                                    cv.addToDioceseFilter([
                                                      dv.dioceseList
                                                          .singleWhere((
                                                          element) =>
                                                      element.dioceseId ==
                                                          secretaryDioceseIdAdmin,)
                                                    ]);
                                                    cv.filteredChurches();
                                                  }
                                                }else {
                                                  cv.getChurches();
                                                }
                                              }else if(index==2){
                                                clv.getAllClergyList();
                                              }
                                            },
                                            extended: width > 800,
                                            selectedIconTheme: const IconThemeData(
                                              color: Colors.blue,
                                            ),
                                            unselectedIconTheme:
                                            const IconThemeData(
                                              color: Colors.black,
                                            ),
                                            selectedLabelTextStyle: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 13,
                                              fontFamily: "Poppins",
                                            ),
                                            unselectedLabelTextStyle:
                                            const TextStyle(
                                              color: Colors.white,
                                              fontSize: 13,
                                              fontFamily: "Poppins",
                                            ),
                                            destinations: navBarAdmItems
                                                .map((item) =>
                                                NavigationRailDestination(
                                                  icon: item.icon,
                                                  selectedIcon:
                                                  item.activeIcon,
                                                  label: Text(
                                                      item.label!),
                                                ))
                                                .toList(),
                                          ),
                                        );
                                      }
                                    ),
                                    const Stack(
                                      alignment: Alignment.bottomCenter,
                                      children: [

                                        Padding(
                                          padding:
                                          EdgeInsets.all(8.0),
                                          child: Text(
                                            "v 1.0",
                                            style: TextStyle(
                                                fontSize: 10,
                                                color: Colors.white),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                                  // : SizedBox();
                            }),
                        Consumer<WebViewModel>(
                            builder: (context, value, child) {
                              return Expanded(
                                flex: 4,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Consumer<WebViewModel>(
                                    builder: (_,wv,__) {
                                      return Column(
                                        children: [
                                          Flexible(
                                            child: IndexedStack(
                                              clipBehavior: Clip.antiAlias,
                                              index: wv.currentPage,
                                              children: const [
                                                DioceseUploadView(),
                                                ChurchUploadView(),
                                                FatherUploadView()
                                              ],
                                            ),
                                          ),
                                          // Align(
                                          //   alignment: Alignment.centerRight,
                                          //   child: Text(
                                          //     "copyrightLabel",
                                          //     style: TextStyle(fontSize: 10),
                                          //   ),
                                          // ),
                                        ],
                                      );
                                    }
                                  ),
                                ),
                              );
                            })
                      ],
                    )),
              ],
            ),
          ),
        ));
  }
}
