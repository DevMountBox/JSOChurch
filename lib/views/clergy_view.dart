import 'package:flutter/material.dart';
import 'package:jsochurch/utils/my_functions.dart';
import 'package:jsochurch/viewmodels/clergy_view_model.dart';
import 'package:jsochurch/viewmodels/detailed_view_model.dart';
import 'package:jsochurch/views/detailed_view.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:provider/provider.dart';

import '../models/multi_diocese_model.dart';
import '../utils/app_text_styles.dart';
import '../utils/globals.dart';
import '../utils/my_colors.dart';
import '../widgets/adapter_widgets.dart';
import '../widgets/seach_bar_widget.dart';
import '../widgets/text_widget.dart';

class ClergyView extends StatelessWidget {
  const ClergyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ClergyViewModel>(
        builder: (_,cv,__) {
          return DefaultTabController(
            initialIndex: cv.tabIndex!,
            length: 4,
            child: Scaffold(
              backgroundColor: myWhite,
              appBar: AppBar(
                backgroundColor: myWhite,
                centerTitle: true,
                title: customBoldText(
                    text: "Clergy list", color: myBlack, fontSize: 18),
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(90.0),
                  child: Column(
                    children: [
                      // Add the SearchBarWidget here
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: searchBar(
                          context: context,
                          hintText: "Search...",
                          onChanged: (query) {
                            cv.searchClergy(query);
                          },
                        ),
                      ),
                      // TabBar widget remains below the search bar
                      TabBar(
                        onTap: (index) {
                          if (index == 0) {
                            cv.getClergyList("metropolitans");
                            cv.setClergyType("metropolitans");
                          }  else if (index == 1) {
                            cv.getClergyList("corepiscopa");
                            cv.setClergyType("corepiscopa");

                          } else if (index == 2) {
                            cv.getClergyList("ramban");
                            cv.setClergyType("ramban");

                          }else if (index == 3) {
                            cv.getClergyList("priest");
                            cv.setClergyType("priest");

                          }
                        },
                        tabAlignment: TabAlignment.start,
                        labelStyle: AppTextStyles.inter16GreyBoldStyle,
                        unselectedLabelColor: myGreyText,
                        indicatorColor: buttonBlue,
                        indicatorSize: TabBarIndicatorSize.tab,
                        physics: const BouncingScrollPhysics(),
                        isScrollable: true,
                        padding: EdgeInsets.zero,
                        unselectedLabelStyle: AppTextStyles.inter16BlueBoldStyle,
                        labelColor: buttonBlue,
                        tabs: const [
                          Tab(
                            text: 'Metropolitans',
                          ),
                          Tab(text: 'Cor-episcopas'),
                          Tab(text: 'Ramban'),
                          Tab(text: 'Priest'),

                        ],
                      ),
                    ],
                  ),
                ),
              ),
              body: TabBarView(
                children: [
                  metropolitansWidget(context),
                  fatherWidget(context),
                  fatherWidget(context),
                  fatherWidget(context),
                ],
              ),
            ),
          );
        }
    );
  }

  Widget metropolitansWidget(BuildContext context) {
    String father1 =
        "https://s3-alpha-sig.figma.com/img/fdfa/6a70/781e647e4e5d7982f17d666528b5ad6f?Expires=1736121600&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=L5jo9mdyee7z9ogrCFiYWDLrnwmmEg~ucQQ3px1~OMRWPZj8wuIMQVUgASc8~vkRksq1pVhpduCeKZu7eu8QkrplpA8Z~Y3s004Ci8t96ts4Aer30JPCpXK1HlE6GwVuJAmxWQs6hAiULu-2YzkxeAEExuInb~dFPjU57huhY355L7b1bbyAe-ANM9u9tw42XuaqWPFJwqJc8XjvDwQM1xrwYCWK5Q9GUBdUnD5l0jRUAbS0UkvuDxBmciUZJzNn0gc~Q1NP3S-LoSoktzdqvh9h3czTlHAAPY2urDyMxeVH01keURdBuse61X3LIlZYNtm4myaVDXulbsuFQi3c5w__";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Consumer<ClergyViewModel>(builder: (_, cv, __) {
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: ListView.builder(
                itemCount: cv.filteredClergyList.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  var item = cv.filteredClergyList[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Column(
                      children: [
                        Consumer<DetailedViewModel>(builder: (_, dv, __) {
                          MultiDioceseModel matchingDiocese=MultiDioceseModel("", "", "", "", "");
                          if (multiDioceseList.any((diocese) => diocese.metropolitanId == item.fatherId)){
                            matchingDiocese = multiDioceseList.firstWhere(
                                  (diocese) => diocese.metropolitanId == item.fatherId,
                            );
                          }
                            print(matchingDiocese.dioceseName+"  :matchingDiocese.dioceseName  :  "+item.vicarAt);
                          return InkWell(
                              onTap: () {
                                dv.getFatherDetails(item.fatherId);
                                PersistentNavBarNavigator.pushNewScreen(
                                  context,
                                  screen: const DetailedView(from: "metropolitan"),
                                  withNavBar: false,
                                  pageTransitionAnimation:
                                  PageTransitionAnimation.cupertino,
                                );

                              },
                              child: fatherAdapter(
                                context: context,
                                image: item.image,
                                name: item.fatherName,
                                phone: item.phoneNumber,
                                diocese: [
                                  if (item.vicarAt!="") item.vicarAt,
                                  if (matchingDiocese.dioceseName!="") matchingDiocese.dioceseName
                                ].join(", "),
                              ));
                        }),
                      ],
                    ),
                  );
                },
              ),
            ),
          );
        })
      ],
    );
  }

  Widget fatherWidget(BuildContext context) {
    String father1 =
        "https://s3-alpha-sig.figma.com/img/fdfa/6a70/781e647e4e5d7982f17d666528b5ad6f?Expires=1736121600&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=L5jo9mdyee7z9ogrCFiYWDLrnwmmEg~ucQQ3px1~OMRWPZj8wuIMQVUgASc8~vkRksq1pVhpduCeKZu7eu8QkrplpA8Z~Y3s004Ci8t96ts4Aer30JPCpXK1HlE6GwVuJAmxWQs6hAiULu-2YzkxeAEExuInb~dFPjU57huhY355L7b1bbyAe-ANM9u9tw42XuaqWPFJwqJc8XjvDwQM1xrwYCWK5Q9GUBdUnD5l0jRUAbS0UkvuDxBmciUZJzNn0gc~Q1NP3S-LoSoktzdqvh9h3czTlHAAPY2urDyMxeVH01keURdBuse61X3LIlZYNtm4myaVDXulbsuFQi3c5w__";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Consumer<ClergyViewModel>(builder: (_, cv, __) {
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: ListView.builder(
                itemCount: cv.filteredClergyList.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  var item = cv.filteredClergyList[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Column(
                      children: [
                        Consumer<DetailedViewModel>(
                            builder: (_,dv,__) {
                              return InkWell(
                                onTap: (){
                                  dv.getFatherDetails(item.fatherId);
                                  PersistentNavBarNavigator.pushNewScreen(
                                    context,
                                    screen: const DetailedView(from: "father"),
                                    withNavBar: false,
                                    pageTransitionAnimation:
                                    PageTransitionAnimation.cupertino,
                                  );
                                },
                                child: fatherAdapter(
                                    context: context,
                                    image: item.image,
                                    name: item.fatherName,
                                    phone: item.phoneNumber,
                                    diocese: item.vicarAt),
                              );
                            }
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          );
        })
      ],
    );
  }

}
