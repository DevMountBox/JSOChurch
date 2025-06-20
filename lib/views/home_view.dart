import 'package:flutter/material.dart';
import 'package:jsochurch/utils/my_functions.dart';
import 'package:jsochurch/viewmodels/clergy_view_model.dart';
import 'package:jsochurch/viewmodels/detailed_view_model.dart';
import 'package:jsochurch/viewmodels/select_church_view_model.dart';
import 'package:jsochurch/viewmodels/select_diocese_view_model.dart';
import 'package:jsochurch/views/big_father_view.dart';
import 'package:jsochurch/views/church_view.dart';
import 'package:jsochurch/views/clergy_view.dart';
import 'package:jsochurch/views/diocese_view.dart';
import 'package:jsochurch/views/profile_view.dart';
import 'package:jsochurch/web/view_models/edit_view_model.dart';
import 'package:jsochurch/widgets/adapter_widgets.dart';
import 'package:jsochurch/widgets/text_widget.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:provider/provider.dart';

import '../utils/globals.dart';
import '../utils/my_colors.dart';
import '../viewmodels/home_view_model.dart';
import 'detailed_view.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Consumer<HomeViewModel>(builder: (_, hv, __) {
      return Scaffold(
        backgroundColor: myWhite,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [gradientBlue1, gradientBlue2])),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 50, 12, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                  height: 96,
                                  width: 96,
                                  child:
                                      Image.asset("assets/images/church_logo.png")),
                              SizedBox(width: 20,),
                              SizedBox(
                                  height: 96,
                                  width: 96,
                                  child:
                                      Image.asset("assets/images/jso_logo.png")),
                            ],
                          ),
                          Consumer<EditViewModel>(
                            builder: (_,ev,__) {
                              return InkWell(
                                onTap: (){
                                  ev.getChurchDetailsAndStatus();
                                  PersistentNavBarNavigator.pushNewScreen(
                                    context,
                                    screen: const ProfileView(),
                                    withNavBar: false,
                                    pageTransitionAnimation:
                                    PageTransitionAnimation.cupertino,
                                  );
                                },
                                child: CircleAvatar(

                                  maxRadius: 25,
                                  child: ClipOval(
                                    child: Image.network(
                                      loginUser!.image,
                                      fit: BoxFit.cover,
                                      alignment: Alignment.topCenter,
                                      width: 50,
                                      height: 50,
                                    ),
                                  ),
                                ),
                              );
                            }
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      customBoldText(
                          text: "Welcome,",
                          color: myWhite,
                          fontSize: 24),
                      const SizedBox(
                        height: 10,
                      ),
                      customNormalText(
                          text:
                              loginUser!.fatherName,
                          color: myWhite,
                          fontSize: 16),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10,),
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      itemCount: hv.bigFathersList.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        var item = hv.bigFathersList[index];
                        String father="";
                        String position="";
                        father =item.positions;
                        position=item.fatherName;

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Column(
                            children: [
                              Consumer<DetailedViewModel>(
                                builder: (_,dv,__) {

                                  return InkWell(
                                      onTap: () {
                                        if(index!=0) {
                                          //in backend fatherid set in type in bigdather node
                                          String type="";
                                          dv.getFatherDetails(item.type);
                                          PersistentNavBarNavigator
                                              .pushNewScreen(
                                            context,
                                            screen: const DetailedView(
                                                from: "metropolitan"),
                                            withNavBar: false,
                                            pageTransitionAnimation:
                                            PageTransitionAnimation.cupertino,
                                          );
                                        }else{
                                          dv.getBigFatherDetails(item);
                                          PersistentNavBarNavigator
                                              .pushNewScreen(
                                            context,
                                            screen: const BigFatherView(),
                                            withNavBar: false,
                                            pageTransitionAnimation:
                                            PageTransitionAnimation.cupertino,
                                          );
                                        }
                                      },
                                      child: bigFatherAdapter(context,fatherImage: item.image,position:position,fatherName: father));
                                }
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 15,),
                    customBoldText(
                        text: "Our Clergy", color: myBlack, fontSize: 18),
                    GridView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 1.4,
                      ),
                      itemCount: hv.clergyList.length,
                      itemBuilder: (context, index) {
                        var item = hv.clergyList[index];
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Consumer<ClergyViewModel>(
                            builder: (_,cv,__) {
                              return InkWell(
                                onTap: (){
                                  cv.setTabIndex(index);
                                  cv.getClergyList(item.getDataString);
                                  PersistentNavBarNavigator.pushNewScreen(
                                    context,
                                    screen: const ClergyView(),
                                    withNavBar: false,
                                    pageTransitionAnimation:
                                    PageTransitionAnimation.cupertino,
                                  );
                                },
                                child: clergyAdapter(
                                  context: context,
                                  clergy: item,
                                ),
                              );
                            }
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 10,),
                    customBoldText(
                        text: "Diocese", color: myBlack, fontSize: 18),
                    const SizedBox(
                      height: 10,
                    ),
                    // SingleChildScrollView(
                    //   scrollDirection: Axis.horizontal,
                    //   child: Row(
                    //     children: [
                    //       dioceseAdapter(
                    //           context: context,
                    //           count: "15",
                    //           asset: "kerala",
                    //           location: "Kerala"),
                    //       Padding(
                    //         padding:
                    //             const EdgeInsets.symmetric(horizontal: 16.0),
                    //         child: dioceseAdapter(
                    //             context: context,
                    //             count: "15",
                    //             asset: "india",
                    //             location: "Outside Kerala"),
                    //       ),
                    //       dioceseAdapter(
                    //           context: context,
                    //           count: "15",
                    //           asset: "other",
                    //           location: "Outside India"),
                    //     ],
                    //   ),
                    // ),
                    Consumer<SelectDioceseViewModel>(
                      builder: (_,sv,__) {
                        return InkWell(
                            onTap: (){
                              sv.getDioceses();
                              PersistentNavBarNavigator.pushNewScreen(
                                context,
                                screen: const DioceseView(),
                                withNavBar: false,
                                pageTransitionAnimation:
                                PageTransitionAnimation.cupertino,
                              );
                            },
                            child: singleDioceseAdapter(context: context, count: hv.dioceseCount));
                      }
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    // customBoldText(
                    //     text: "Other Church Group",
                    //     color: myBlack,
                    //     fontSize: 18),
                    // const SizedBox(
                    //   height: 5,
                    // ),
                    // GridView.builder(
                    //   shrinkWrap: true,
                    //   padding: EdgeInsets.zero,
                    //   physics: const NeverScrollableScrollPhysics(),
                    //   gridDelegate:
                    //       const SliverGridDelegateWithFixedCrossAxisCount(
                    //     crossAxisCount: 2,
                    //     childAspectRatio: 1.3,
                    //   ),
                    //   itemCount: hv.otherChurchList.length,
                    //   itemBuilder: (context, index) {
                    //    var item=hv.otherChurchList[index];
                    //     return Padding(
                    //       padding: const EdgeInsets.all(8.0),
                    //       child: Consumer<SelectChurchViewModel>(
                    //         builder: (_,cv,__) {
                    //           return InkWell(
                    //             onTap: (){
                    //               cv.otherChurches(item.getDataString);
                    //               PersistentNavBarNavigator.pushNewScreen(
                    //                 context,
                    //                 screen:  ChurchView(title: "${item.dioceseName} Churches",),
                    //                 withNavBar: false,
                    //                 pageTransitionAnimation:
                    //                 PageTransitionAnimation.cupertino,
                    //               );
                    //             },
                    //             child: otherChurchGroupWidget(
                    //               context: context,
                    //               color: item.color,
                    //               churchName: item.dioceseName,
                    //               churchCount: item.churchCount,
                    //             ),
                    //           );
                    //         }
                    //       ),
                    //     );
                    //   },
                    // )
                  ],
                ),
              )
            ],
          ),
        ),
      );
    });
  }
}
