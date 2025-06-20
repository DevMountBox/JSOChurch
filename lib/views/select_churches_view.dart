import 'package:chips_choice/chips_choice.dart';
import 'package:flutter/material.dart';
import 'package:jsochurch/viewmodels/select_church_view_model.dart';
import 'package:jsochurch/viewmodels/select_parish_detail_view_model.dart';
import 'package:jsochurch/views/filter_view.dart';
import 'package:jsochurch/views/nav_bar.dart';
import 'package:jsochurch/web/view_models/edit_view_model.dart';
import 'package:provider/provider.dart';

import '../utils/alert_diologs.dart';
import '../utils/globals.dart';
import '../utils/my_colors.dart';

import '../utils/my_functions.dart';
import '../viewmodels/login_view_model.dart';
import '../viewmodels/select_diocese_view_model.dart';
import '../widgets/adapter_widgets.dart';
import '../widgets/seach_bar_widget.dart';
import '../widgets/text_widget.dart';

class SelectChurchesView extends StatelessWidget {
  final String from;

  const SelectChurchesView({super.key, required this.from});

  @override
  Widget build(BuildContext context) {
    return Consumer<SelectChurchViewModel>(builder: (_, cv, __) {


      return Scaffold(
          backgroundColor: myWhite,
          appBar: AppBar(
            backgroundColor: myWhite,
            centerTitle: true,
            title:
                customBoldText(text: "Churches", color: myBlack, fontSize: 18),
            leading: InkWell(
                onTap: () {
                  finish(context);
                },
                child: const Icon(
                  Icons.arrow_back_ios,
                  color: buttonBlue,
                )),
            actions: [
              from == "diocese"
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Consumer<LoginViewModel>(builder: (_, lv, __) {
                        return InkWell(
                          onTap: () {
                            showMenu(
                              context: context,
                              position: const RelativeRect.fromLTRB(
                                100.0,
                                80.0,
                                0.0,
                                0.0,
                              ),
                              items: [
                                PopupMenuItem<String>(
                                  onTap: () {
                                    auth.signOut();
                                    lv.clearSharedPreference();
                                  },
                                  value: 'Logout',
                                  child: const ListTile(
                                    leading: Icon(Icons.logout),
                                    title: Text('Logout'),
                                  ),
                                ),
                              ],
                              elevation: 8.0,
                            ).then((value) {
                              if (value == 'Profile') {
                                // Navigate to Profile page or perform action
                                print("Navigate to Profile");
                              } else if (value == 'Logout') {
                                // Perform Logout action
                                print("Logging out...");
                              }
                            });
                          },
                          child: CircleAvatar(
                            maxRadius: 20,
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
                      }),
                    )
                  : SizedBox()
            ],
          ),
          body: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 4,
                            child: searchBar(
                              context: context,
                              hintText: "Search...",
                              onChanged: (query) {
                                cv.searchChurch(query);
                              },
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              callNext(const FilterView(), context);
                            },
                            child: Container(
                              width: 30,
                              margin: const EdgeInsets.symmetric(horizontal: 10),
                              alignment: Alignment.center,
                              child: Stack(
                                clipBehavior: Clip.none, // Allows overflow
                                children: [
                                  Align(
                                    alignment: Alignment.center,
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.symmetric(vertical: 3.0),
                                      child:
                                          Image.asset("assets/images/filter.png"),
                                    ),
                                  ),
                                  cv.dioceseFilter.isNotEmpty
                                      ? Align(
                                          alignment: Alignment.topRight,
                                          // Top-right alignment
                                          child: Container(
                                            height: 10,
                                            width: 10,
                                            decoration: BoxDecoration(
                                              color: myRed,
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                        )
                                      : SizedBox(),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    cv.dioceseFilter.isNotEmpty
                        ? Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5.0),
                            child: SizedBox(
                              height: 40, // Set a fixed height for the ListView
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                // Make the ListView horizontal
                                itemCount: cv.dioceseFilter.length,
                                // Number of items in the list
                                itemBuilder: (context, index) {
                                  var item = cv.dioceseFilter[index];
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    // Space between items
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: myChipGrey,
                                        border: Border.all(color: buttonBlue),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(60)),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 6.0, horizontal: 15),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            InkWell(
                                                onTap: () {
                                                  cv.removeFromFilter(item);
                                                },
                                                child: const Icon(Icons.close,
                                                    color: buttonBlue, size: 18)),
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
                          )
                        : SizedBox(),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: ListView.builder(
                          itemCount: cv.filteredChurchList.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            var item = cv.filteredChurchList[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              child: Column(
                                children: [
                                  Consumer2<SelectParishDetailViewModel,
                                      EditViewModel>(builder: (_, pv, ev, __) {
                                    return InkWell(
                                        onTap: () {
                                          if (from == "diocese") {
                                            pv.setSelectedMotherParish(item);
                                            selectWorkingParish(
                                                context,
                                                "Are you sure to make you working parish as ${item.churchName}?",
                                                "Confirm");
                                          } else if (from == "vicar1") {
                                            ev.setVicar1(item);
                                            finish(context);
                                          } else if (from == "vicar2") {
                                            ev.setVicar2(item);
                                            finish(context);
                                          } else if (from == "motherParish") {
                                            ev.setMotherParish(item);
                                            finish(context);
                                          }
                                        },
                                        child: churchAdapter(
                                            context: context,
                                            churchName: item.churchName,
                                            address: item.address,
                                            image: item.image));
                                  }),
                                ],
                              ),
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
          ));
    });
  }
}
