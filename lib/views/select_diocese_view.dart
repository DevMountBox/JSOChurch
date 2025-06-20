import 'package:chips_choice/chips_choice.dart';
import 'package:jsochurch/utils/app_text_styles.dart';
import 'package:jsochurch/utils/my_functions.dart';
import 'package:jsochurch/viewmodels/select_church_view_model.dart';
import 'package:jsochurch/views/select_churches_view.dart';
import 'package:jsochurch/widgets/adapter_widgets.dart';
import 'package:jsochurch/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/globals.dart';
import '../utils/my_colors.dart';
import '../viewmodels/login_view_model.dart';
import '../viewmodels/select_diocese_view_model.dart';
import '../widgets/seach_bar_widget.dart';

class SelectDioceseView extends StatelessWidget {
  const SelectDioceseView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: myWhite,
        appBar: AppBar(
          backgroundColor: myWhite,
          centerTitle: true,
          title: customBoldText(
              text: "Select Diocese", color: myBlack, fontSize: 18),
          leading: InkWell(
            onTap: () {
              finish(context);
            },
            child: const Icon(
              Icons.arrow_back_ios,
              color: buttonBlue,
            ),
          ),

          actions:  [
            Padding(
              padding:const EdgeInsets.symmetric(horizontal: 8.0),
              child: Consumer<LoginViewModel>(
                  builder: (_,lv,__) {
                    return InkWell(
                      onTap: (){
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
                              onTap: (){
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
                  }
              ),
            )
          ],
        ),
        body:  diocesesWidget(context));
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
                        Consumer<SelectChurchViewModel>(
                          builder: (_,cv,__) {
                            return InkWell(
                                onTap: () {
                                  cv.addToDioceseFilter([item]);
                                  cv.filteredChurches();
                                  callNext(const SelectChurchesView(from: "diocese",), context);
                                },
                                child: dioceseLocationAdapter(
                                    context: context,
                                    location: "${item.dioceseName}",
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
                          callNext(const SelectChurchesView(from: "diocese",), context);
                        },
                        child: dioceseLocationAdapter(
                            context: context,
                            location: "Thrissur",
                            totalChurches: "47 chrhces"),
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
