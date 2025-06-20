import 'package:chips_choice/chips_choice.dart';
import 'package:jsochurch/utils/app_text_styles.dart';
import 'package:jsochurch/utils/my_functions.dart';
import 'package:jsochurch/viewmodels/detailed_view_model.dart';
import 'package:jsochurch/views/detailed_view.dart';
import 'package:jsochurch/views/select_churches_view.dart';
import 'package:jsochurch/widgets/adapter_widgets.dart';
import 'package:jsochurch/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:provider/provider.dart';

import '../utils/my_colors.dart';
import '../viewmodels/select_diocese_view_model.dart';
import '../widgets/seach_bar_widget.dart';

class DioceseView extends StatelessWidget {
  const DioceseView({super.key});

  @override
  Widget build(BuildContext context) {

    return Consumer<SelectDioceseViewModel>(builder: (_, dv, __) {

      return Scaffold(
        backgroundColor: myWhite,
        appBar: AppBar(
          backgroundColor: myWhite,
          centerTitle: true,
          title: customBoldText(text: "Diocese", color: myBlack, fontSize: 18),
        ),
        body: diocesesWidget(context),
      );
    });
  }

  Widget diocesesWidget(BuildContext context) {
    return Consumer<SelectDioceseViewModel>(builder: (_, dv, __) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 15),
            child: searchBar(
              context: context,
              hintText: "Search by diocese name",
              onChanged: (query) {
               dv.searchDiocese(query);
              },
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: ListView.builder(
                itemCount: dv.filteredDioceseList.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  var item = dv.filteredDioceseList[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15.0, vertical: 5),
                    child: Column(
                      children: [
                        Consumer<DetailedViewModel>(
                          builder: (_,dv,__) {
                            return InkWell(
                                onTap: () {
                                  dv.getDioceseDetails(item.dioceseId);
                                  PersistentNavBarNavigator.pushNewScreen(
                                    context,
                                    screen: const DetailedView(from: "diocese"),
                                    withNavBar: false,
                                    pageTransitionAnimation:
                                    PageTransitionAnimation.cupertino,
                                  );

                                },
                                child: dioceseLocationAdapter(
                                    context: context,
                                    location: item.dioceseName,
                                    totalChurches: item.churchCount.toString(),
                                    isArrow: false));
                          }
                        ),
                        Divider(
                          color: myChipText.withOpacity(.25),
                          indent: 5,
                          endIndent: 5,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          )
        ],
      );
    });
  }

  Widget otherChurchGroupWidget(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: ListView.builder(
              itemCount: 10,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
                  child: Column(
                    children: [
                      InkWell(
                        onTap: () {
                          callNext(
                              const DetailedView(from: "diocese"), context);
                        },
                        child: dioceseLocationAdapter(
                            context: context,
                            location: "Thrissur",
                            totalChurches: "47 chrhces",
                            isArrow: false),
                      ),
                      Divider(
                        color: myChipText.withOpacity(.25),
                        indent: 5,
                        endIndent: 5,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        )
      ],
    );
  }
}
