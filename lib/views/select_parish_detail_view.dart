import 'package:jsochurch/utils/my_colors.dart';
import 'package:jsochurch/utils/my_functions.dart';
import 'package:jsochurch/viewmodels/login_view_model.dart';
import 'package:jsochurch/viewmodels/select_diocese_view_model.dart';
import 'package:jsochurch/views/nav_bar.dart';
import 'package:jsochurch/views/select_diocese_view.dart';
import 'package:jsochurch/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/app_text_styles.dart';
import '../utils/buttons.dart';
import '../utils/globals.dart';
import '../viewmodels/select_parish_detail_view_model.dart';

class SelectParishDetailView extends StatelessWidget {
  const SelectParishDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: myWhite,
      appBar: AppBar(
        backgroundColor: myWhite,
        leading: const Icon(Icons.arrow_back_ios,color: buttonBlue,),
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
      bottomNavigationBar: Consumer<SelectParishDetailViewModel>(
        builder: (_,sv,__) {
          return BottomAppBar(
            height: 100,
            padding: EdgeInsets.symmetric(vertical: 5),
            color: myWhite,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0,vertical: 20),
              child: Center(
                child: Consumer<SelectDioceseViewModel>(
                  builder: (_,dv,__) {
                    return MyElevatedButton(
                      height: 45,
                      width: double.infinity,
                      onPressed: () {
                        if(sv.selectedOption!=null){
                          if(sv.selectedOption!.id==1){
                            dv.getDioceses();
                            callNext(SelectDioceseView(), context);
                          }else {
                            sv.updateParishDetails(context);
                          }
                        }else{
                          showToast("Please choose one");
                        }
                      },
                      borderRadius:
                      const BorderRadius.all(
                          Radius.circular(60)),
                      child:const Text(
                          "Proceed",
                          style:AppTextStyles.inter16WhiteStyle
                      ),
                    );
                  }
                ),
              ),
            )
            ,
          );
        }
      ),
      body: SafeArea(child: 
      SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 20),
          child: Consumer<SelectParishDetailViewModel>(
            builder: (_,sv,__) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      customBoldText(text: "Select your Parish\ndetails", color: myBlack, fontSize: 32),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5.0),
                        child: customNormalText(text: "Please choose one of the options below to proceed", color: myGreyText, fontSize: 16),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: ListView.builder(
                          itemCount: sv.parishLoginStatus.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: sv.selectedOption == sv.parishLoginStatus[index]
                                      ? buttonBlue
                                      : Colors.grey.shade300,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ListTile(
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                                title: customBoldText(
                                  text: sv.parishLoginStatus[index].parishEnterType,
                                  color: myBlack,
                                  fontSize: 16,
                                ),
                                leading: Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: CircleAvatar(
                                    radius: 12,
                                    backgroundColor: sv.selectedOption == sv.parishLoginStatus[index]
                                        ? buttonBlue
                                        : Colors.grey.shade300,
                                    child: sv.selectedOption == sv.parishLoginStatus[index]
                                        ? const Icon(
                                      Icons.check,
                                      color: Colors.white,
                                      size: 14,
                                    )
                                        : null,
                                  ),
                                ),
                                onTap: () {
                                  sv.setSelectedOption(sv.parishLoginStatus[index]);
                                },
                              ),
                            );
                          },
                        ),
                      )
                    ],
                  ),
                ],
              );
            }
          ),
        ),
      )),
    );
  }
}
