import 'package:chips_choice/chips_choice.dart';
import 'package:flutter/material.dart';
import 'package:jsochurch/viewmodels/detailed_view_model.dart';
import 'package:jsochurch/viewmodels/select_church_view_model.dart';
import 'package:jsochurch/views/filter_view.dart';
import 'package:jsochurch/views/nav_bar.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:provider/provider.dart';

import '../models/church_model.dart';
import '../utils/my_colors.dart';

import '../utils/my_functions.dart';
import '../viewmodels/select_diocese_view_model.dart';
import '../widgets/adapter_widgets.dart';
import '../widgets/seach_bar_widget.dart';
import '../widgets/text_widget.dart';
import 'detailed_view.dart';

class ChurchView extends StatelessWidget {
  final String title;
  const ChurchView({super.key,required this.title});

  @override
  Widget build(BuildContext context) {
    return  Consumer<SelectChurchViewModel>(
        builder: (_,cv,__) {
          return Scaffold(
              backgroundColor: myWhite,
              appBar: AppBar(
                backgroundColor: myWhite,
                centerTitle: true,
                title: customBoldText(text: title, color: myBlack, fontSize: 18),
              ),
              body: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0,horizontal: 15  ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                       title=="Churches"? Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5.0 ),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 4,
                                child:searchBar(
                                  context: context,
                                  hintText: "Search...",
                                  onChanged: (query) {
                                    cv.searchChurch(query);
                                  },
                                ),
                              ),

                              InkWell(

                                onTap: (){
                                  PersistentNavBarNavigator.pushNewScreen(
                                    context,
                                    screen: const FilterView(),
                                    withNavBar: false,
                                    pageTransitionAnimation:
                                    PageTransitionAnimation.cupertino,
                                  );
                                },
                                child: Container(
                                  width: 30,
                                  margin: EdgeInsets.symmetric(horizontal: 10),
                                  alignment: Alignment.center,
                                  child: Stack(
                                    clipBehavior: Clip.none, // Allows overflow
                                    children: [
                                      Align(
                                        alignment: Alignment.center,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 3.0),
                                          child: Image.asset("assets/images/filter.png"),
                                        ),
                                      ),
                                      cv.dioceseFilter.isNotEmpty?  Align(
                                        alignment: Alignment.topRight, // Top-right alignment
                                        child: Container(
                                          height: 10,
                                          width: 10,
                                          decoration: BoxDecoration(
                                            color: myRed,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                      ):SizedBox()
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ):const SizedBox(),
                        cv.dioceseFilter.isNotEmpty? Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5.0),
                          child: SizedBox(
                            height: 40, // Set a fixed height for the ListView
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal, // Make the ListView horizontal
                              itemCount: cv.dioceseFilter.length, // Number of items in the list
                              itemBuilder: (context, index) {
                                var item=cv.dioceseFilter[index];
                                return Padding(
                                  padding: const EdgeInsets.only(right: 8.0), // Space between items
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: myChipGrey,
                                      border: Border.all(color: buttonBlue),
                                      borderRadius: const BorderRadius.all(Radius.circular(60)),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 15),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          InkWell(
                                              onTap:(){
                                                cv.removeFromFilter(item);
                                              },
                                              child: const Icon(Icons.close, color: buttonBlue, size: 18)),
                                          const SizedBox(width: 8),
                                          customNormalText(
                                            text: item.dioceseName,
                                            color: myChipText,
                                            fontSize: 16,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ):SizedBox(),

                        Expanded(
                          child:Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Consumer<SelectChurchViewModel>(
                              builder: (_, cv, __) {
                                Map<String, List<ChurchModel>> groupedChurches = {};
                                if (cv.isRegionAvailable()) {
                                  for (var church in cv.filteredChurchList) {
                                    String region = church.region.trim();
                                    if (!groupedChurches.containsKey(region)) {
                                      groupedChurches[region] = [];
                                    }
                                    groupedChurches[region]!.add(church);
                                  }
                                }

                                return ListView.builder(
                                  itemCount: cv.isRegionAvailable()
                                      ? groupedChurches.keys.length
                                      : cv.filteredChurchList.length,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    if (cv.isRegionAvailable()) {
                                      // Display regions with grouped churches
                                      String region = groupedChurches.keys.elementAt(index);
                                      List<ChurchModel> churches = groupedChurches[region]!;

                                      return Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                                            child: Text(
                                              region,
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontFamily: "Inter",
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          ListView.builder(
                                            itemCount: churches.length,
                                            shrinkWrap: true,
                                            physics: const NeverScrollableScrollPhysics(),
                                            itemBuilder: (context, churchIndex) {
                                              var item = churches[churchIndex];

                                              return Padding(
                                                padding: const EdgeInsets.symmetric(vertical: 12),
                                                child: Consumer<DetailedViewModel>(
                                                  builder: (_, dv, __) {
                                                    return InkWell(
                                                      onTap: () {
                                                        dv.getChurchDetails(item.churchId);
                                                        PersistentNavBarNavigator.pushNewScreen(
                                                          context,
                                                          screen: const DetailedView(from: "church"),
                                                          withNavBar: false,
                                                          pageTransitionAnimation:
                                                          PageTransitionAnimation.cupertino,
                                                        );
                                                      },
                                                      child: churchAdapter(
                                                        context: context,
                                                        churchName: item.churchName,
                                                        address:"${item.diocese}",
                                                        image: item.image,
                                                      ),
                                                    );
                                                  },
                                                ),
                                              );
                                            },
                                          ),
                                        ],
                                      );
                                    } else {
                                      // Display churches directly when region is not available
                                      var item = cv.filteredChurchList[index];

                                      return Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 12),
                                        child: Consumer<DetailedViewModel>(
                                          builder: (_, dv, __) {
                                            return InkWell(
                                              onTap: () {
                                                dv.getChurchDetails(item.churchId);
                                                PersistentNavBarNavigator.pushNewScreen(
                                                  context,
                                                  screen: const DetailedView(from: "church"),
                                                  withNavBar: false,
                                                  pageTransitionAnimation:
                                                  PageTransitionAnimation.cupertino,
                                                );
                                              },
                                              child: churchAdapter(
                                                context: context,
                                                churchName: item.churchName,
                                                address: "${item.diocese}",
                                                image: item.image,
                                              ),
                                            );
                                          },
                                        ),
                                      );
                                    }
                                  },
                                );
                              },
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 25,
                    right: 15,
                    child: Consumer<SelectChurchViewModel>(
                        builder: (_,cv,__) {
                          return cv.isRegionAvailable()? Padding(
                            padding: const EdgeInsets.all(25.0),
                            child: Align(
                              alignment: Alignment.bottomRight,
                              child: PopupMenuButton(
                                // offset: const Offset(0, -310),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                elevation: 0,
                                color: myBlack,
                                itemBuilder: (context) {
                                  return cv.regionList.map((item) {
                                    return PopupMenuItem(
                                      value: cv.regionList.indexOf(item),
                                      child: Row(
                                        children: [
                                          Text(
                                            item,
                                            style: TextStyle(color: myWhite),
                                          ),
                                        ],
                                      ),
                                    );
                                  }).toList();
                                },
                                onSelected: (value) {
                                  cv.filterByRegion(cv.dioceseFilter[0].dioceseName,cv.regionList[value]);
                                },
                                child: Container(
                                  height: 45,
                                  width: 100,
                                  alignment: Alignment.center,
                                  decoration: const BoxDecoration(
                                    color: myBlack,
                                    borderRadius: BorderRadius.all(Radius.circular(60)),
                                  ),
                                  child: customNormalText(text: "Regions", color: myWhite, fontSize: 14),
                                ),
                              ),
                            ),
                          ):const SizedBox();
                        }
                    ),
                  )

                ],
              )
          );
        }
    );
  }
}
