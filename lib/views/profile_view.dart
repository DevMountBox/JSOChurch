import 'package:flutter/material.dart';
import 'package:jsochurch/utils/globals.dart';
import 'package:jsochurch/viewmodels/profile_view_model.dart';
import 'package:jsochurch/viewmodels/splash_view_model.dart';
import 'package:jsochurch/web/view_models/edit_view_model.dart';
import 'package:provider/provider.dart';

import '../utils/alert_diologs.dart';
import '../utils/my_colors.dart';
import '../utils/my_functions.dart';
import '../widgets/adapter_widgets.dart';
import '../widgets/bluerd_image_widget.dart';
import '../widgets/text_widget.dart';
import 'edit_father_view.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return Consumer2<ProfileViewModel,EditViewModel>(builder: (_, dv,ev, __) {
      return Scaffold(
        backgroundColor: myWhite,
        body: SafeArea(
            child: SingleChildScrollView(
              child: loginUser != null
                  ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      BlurredImageWidget(
                        imageUrl: loginUser!.image,
                        placeholderImage: "assets/images/father_place_holder.png",
                        height: 258,
                        width: MediaQuery.of(context).size.width,
                      ),
                      Positioned(
                        top: 15,
                        left: 10,
                        child: InkWell(
                          onTap: () {
                            finish(context);
                          },
                          child: const CircleAvatar(
                            backgroundColor: myWhite,
                            maxRadius: 15,
                            child: Padding(
                              padding: EdgeInsets.only(left: 5.0),
                              child: Icon(
                                Icons.arrow_back_ios,
                                size: 18,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 15,
                        right: 10,
                        child: Consumer<ProfileViewModel>(
                          builder: (_,pv,__) {
                            return InkWell(
                              onTap: () {
                               pv.getImageForProfile(context,loginUser!);
                              },
                              child: const CircleAvatar(
                                backgroundColor: gradientLightBlue,
                                maxRadius: 15,
                                child: Padding(
                                  padding: EdgeInsets.only(left: 5.0),
                                  child: Icon(
                                    Icons.edit,
                                    color: buttonBlue,
                                    size: 15,
                                  ),
                                ),
                              ),
                            );
                          }
                        ),
                      ),
                      Positioned(
                        top: 220,
                        left: 10,
                        child: InkWell(
                          onTap: () {
                            // finish(context);
                          },
                          child: Container(
                            height: 30,
                            width: 80,
                            alignment: Alignment.center,
                            decoration: const BoxDecoration(
                              color: gradientLightBlue,
                              borderRadius: BorderRadius.all(Radius.circular(100)),
                            ),
                            child: Consumer<EditViewModel>(
                              builder: (_,ev,__) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 5.0,horizontal: 12),
                                  child: customBoldText(text:ev.showStatus() , color: buttonBlue, fontSize: 14),
                                );
                              }
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15.0, vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width:width*.8,
                              child: customBoldText(
                                  text:loginUser!.fatherName,
                                  color: myBlack,
                                  fontSize: 24),
                            ),
                            Consumer<EditViewModel>(
                              builder: (_,ev,__) {
                                return InkWell(
                                  onTap: (){
                                    ev.fetchNameDetails(loginUser!);
                                    callNext(const EditFatherView(from: "name",), context);
                                  },
                                  child: const CircleAvatar(
                                    backgroundColor: gradientLightBlue,
                                    maxRadius: 15,
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 5.0),
                                      child: Icon(
                                        Icons.edit,
                                        color: buttonBlue,
                                        size: 15,
                                      ),
                                    ),
                                  ),
                                );
                              }
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        loginUser!.positions!=""? customNormalText(
                            text: loginUser!.positions,
                            color: myGreyText,
                            fontSize: 16):SizedBox(),
                        loginUser!.primaryAt!=""?Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            customNormalText(
                                text: "Primary Vicar at",
                                color: myGreyText,
                                fontSize: 14),
                            const SizedBox(
                              height: 10,
                            ),
                            customNormalText(
                                text: loginUser!.primaryAt,
                                color: myBlack,
                                fontSize: 16),
                            const SizedBox(
                              height: 5,
                            ),
                          ],
                        ):const SizedBox(),
                        const SizedBox(height: 8,),
                        loginUser!.secondaryVicarAt!=""?Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            customNormalText(
                                text: "Secondary Vicar at",
                                color: myGreyText,
                                fontSize: 14),
                            const SizedBox(
                              height: 10,
                            ),
                            customNormalText(
                                text: loginUser!.secondaryVicarAt,
                                color: myBlack,
                                fontSize: 16),
                            const SizedBox(
                              height: 5,
                            ),
                          ],
                        ):const SizedBox(),
                        Divider(
                          color: myChipText.withOpacity(.25),
                          indent: 5,
                          endIndent: 5,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            customBoldText(
                                text: "Contact Info",
                                color: myBlack,
                                fontSize: 16),
                            Consumer<EditViewModel>(
                              builder: (_,ev,__) {
                                return InkWell(
                                  onTap: (){
                                    ev.fetchContactDetails(loginUser!);
                                    callNext(const EditFatherView(from: "contact",), context);
                                  },
                                  child: const CircleAvatar(
                                    backgroundColor: gradientLightBlue,
                                    maxRadius: 15,
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 5.0),
                                      child: Icon(
                                        Icons.edit,
                                        color: buttonBlue,
                                        size: 15,
                                      ),
                                    ),
                                  ),
                                );
                              }
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        detailsAdapter(context, "phone",
                            loginUser!.phoneNumber),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: detailsAdapter(context, "phone",
                              loginUser!.secondaryNumber),
                        ),
                        detailsAdapter(
                            context, "mail", loginUser!.emailId),
                        const SizedBox(
                          height: 5,
                        ),
                        Divider(
                          color: myChipText.withOpacity(.25),
                          indent: 5,
                          endIndent: 5,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            customBoldText(
                                text: "Address",
                                color: myBlack,
                                fontSize: 16),
                            Consumer<EditViewModel>(
                              builder: (_,ev,__) {
                                return InkWell(
                                  onTap: (){
                                    ev.fetchAddress(loginUser!);
                                    callNext(const EditFatherView(from: "address",), context);
                                  },
                                  child: const CircleAvatar(
                                    backgroundColor: gradientLightBlue,
                                    maxRadius: 15,
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 5.0),
                                      child: Icon(
                                        Icons.edit,
                                        color: buttonBlue,
                                        size: 15,
                                      ),
                                    ),
                                  ),
                                );
                              }
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        customNormalText(
                            text: "Permanent Address",
                            color: myGreyText,
                            fontSize: 14),
                        const SizedBox(
                          height: 5,
                        ),

                        customNormalText(
                            text: loginUser!.permanentAddress, color: myBlack, fontSize: 16),
                        SizedBox(height: 10,),
                        customNormalText(
                            text: "Present Address",
                            color: myGreyText,
                            fontSize: 14),
                        const SizedBox(
                          height: 5,
                        ),

                        customNormalText(
                            text: loginUser!.presentAddress, color: myBlack, fontSize: 16),
                        const SizedBox(
                          height: 10,
                        ),


                        customNormalText(
                            text: "Mother Parish",
                            color: myGreyText,
                            fontSize: 14),
                        const SizedBox(
                          height: 5,
                        ),

                        customNormalText(
                            text: loginUser!.motherParish, color: myBlack, fontSize: 16),
                        const SizedBox(
                          height: 5,
                        ),
                        Divider(
                          color: myChipText.withOpacity(.25),
                          indent: 5,
                          endIndent: 5,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            customBoldText(
                                text: "Other Details",
                                color: myBlack,
                                fontSize: 16),
                            Consumer<EditViewModel>(
                              builder: (_,ev,__) {
                                return InkWell(
                                  onTap: (){
                                    ev.fetchOtherDetails(loginUser!);
                                    callNext(const EditFatherView(from: "other",), context);
                                  },
                                  child: const CircleAvatar(
                                    backgroundColor: gradientLightBlue,
                                    maxRadius: 15,
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 5.0),
                                      child: Icon(
                                        Icons.edit,
                                        color: buttonBlue,
                                        size: 15,
                                      ),
                                    ),
                                  ),
                                );
                              }
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        customNormalText(
                            text: "Age & Date of Birth",
                            color: myGreyText,
                            fontSize: 14),
                        const SizedBox(
                          height: 5,
                        ),

                        customNormalText(
                            text: loginUser!.dob, color: myBlack, fontSize: 16),
                        SizedBox(height: 10,),
                        customNormalText(
                            text: "Blood Group",
                            color: myGreyText,
                            fontSize: 14),
                        const SizedBox(
                          height: 5,
                        ),

                        customNormalText(
                            text: loginUser!.bloodGroup, color: myBlack, fontSize: 16),
                        const SizedBox(
                          height: 10,
                        ),


                        customNormalText(
                            text: "Ordination as priest",
                            color: myGreyText,
                            fontSize: 14),
                        const SizedBox(
                          height: 5,
                        ),

                        customNormalText(
                            text: loginUser!.ordination, color: myBlack, fontSize: 16),
                        const SizedBox(
                          height: 5,
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    color: myChipText.withOpacity(.25),
                    indent: 5,
                    endIndent: 5,
                  ),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () {
                        logoutDialog(context, "Do you want to Logout?", "Logout");
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.logout,color: myRed,),
                          SizedBox(width: 10,),
                          Text(
                            "Logout",
                            style: TextStyle(
                              fontFamily: "InterB",
                              color: myRed
                            ),
                          )
                        ],
                      ),
                    ),
                  ),

                  Divider(
                    color: myChipText.withOpacity(.25),
                    indent: 5,
                    endIndent: 5,
                  ),

                ],
              )
                  : const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(child: CircularProgressIndicator()),
                ],
              ),
            )),
      );
    });
  }
}
