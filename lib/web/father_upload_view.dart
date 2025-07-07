import 'dart:convert';

import 'package:chips_choice/chips_choice.dart';
import 'package:flutter/material.dart';
import 'package:jsochurch/models/clergy_model.dart';
import 'package:jsochurch/models/user_model.dart';
import 'package:jsochurch/utils/alert_diologs.dart';
import 'package:jsochurch/utils/app_text_styles.dart';
import 'package:jsochurch/viewmodels/detailed_view_model.dart';
import 'package:jsochurch/web/view_models/edit_view_model.dart';
import 'package:jsochurch/web/view_models/web_view_model.dart';
import 'package:provider/provider.dart';

import '../utils/buttons.dart';
import '../utils/excel_to_json.dart';
import '../utils/globals.dart';
import '../utils/my_colors.dart';
import '../utils/my_functions.dart';
import '../viewmodels/clergy_view_model.dart';
import '../viewmodels/report_view_model.dart';
import '../widgets/text_widget.dart';

class FatherUploadView extends StatelessWidget {
  const FatherUploadView({super.key});

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return  Consumer<DetailedViewModel>(
      builder: (_,dv,__) {
        return SelectionArea(
          child: Scaffold(
            key: dv.scaffoldFather,
            backgroundColor: myWhite,
            endDrawer:
            dv.fatherDetailModel != null?Drawer(
              width: width*.3,
              child: fatherView(context),
            ) :  const SizedBox(),
          
            body: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment:CrossAxisAlignment.start ,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Text(
                            'Fathers',
                            style: TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.w600,
                                color: myBlack,
                                fontFamily: "Poppins"
                            ),
                          ),
                          const SizedBox(width: 15,),
                          Consumer2<WebViewModel,ClergyViewModel>(
                            builder: (_,wv,cv,__) {
                              return cv.inputChipTag!=0? MyElevatedButton(
                                height: 30,
                                width: 250,
                                onPressed: () {
                                  // sp.update();
                                  ExcelToJson().convert().then((onValue) {
                                    var jsonResponse = json.decode(onValue.toString());
                                    List<dynamic> map = jsonResponse as List;
                                    wv.uploadFatherToFirebase(map,cv.clergy);
                                  });
                                },
                                borderRadius:
                                const BorderRadius.all(
                                    Radius.circular(60)),
                                child: Text(
                                    "Upload ${cv.clergy} Excel",
                                    style:AppTextStyles.interWhite12BoldStyle
                                ),
                              ):const SizedBox();
                            }
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          MyElevatedButton(
                            height: 30,
                            width: 150,
                            onPressed: () {
                             addFatherDialog(context);
                            },
                            borderRadius:
                            const BorderRadius.all(
                                Radius.circular(60)),
                            child: Text(
                                "+ Add Father",
                                style:AppTextStyles.interWhite12BoldStyle
                            ),
                          ),
                          const SizedBox(width: 20,),
                          Consumer<ClergyViewModel>(
                              builder: (_,value,__) {
                                return SizedBox(
                                  width: width*0.2,
                                  height: 30,
                                  child: TextField(
                                    style: const TextStyle(fontSize: 12,fontFamily: "Poppins"),
                                    decoration: const InputDecoration(
                                      fillColor: Colors.white,
                                      filled: true,
                                      hintText: 'Search father',
                                      hintStyle: TextStyle(fontSize: 10),
                                      contentPadding:
                                      EdgeInsets.symmetric(vertical: 5, horizontal: 2),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.white),
                                        // borderRadius: BorderRadius.circular(25.7),
                                      ),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: Colors.white),
                                        // borderRadius: BorderRadius.circular(25.7),
                                      ),
                                      suffixIcon: Icon(
                                        Icons.search,
                                        color: Colors.black,
                                      ),
                                    ),
                                    onChanged: (item) {
                                      value.searchClergy(item);
                                    },
                                  ),
                                );
                              }
                          ),
                        ],
                      )
          
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: Container(height: 1,color: myGreyText.withOpacity(0.2),),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child:
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Consumer<ClergyViewModel>(builder: (_, value, __) {
                          return ChipsChoice<int>.single(
                            value: value.inputChipTag,
                            onChanged: (val) {
                              value.changeChipType(val);
                            },
                            choiceItems: C2Choice.listFrom<int, String>(
                              source: value.availableClergy,
                              value: (i, v) => i,
                              label: (i, v) => v,
                              tooltip: (i, v) => v,
                            ),
                            choiceCheckmark: true,

                            choiceStyle: C2ChipStyle.filled(
                              foregroundStyle: AppTextStyles.interBlue12BoldStyle,
                              color: myChipGrey,
                              borderRadius: const BorderRadius.all(
                                Radius.circular(30),
                              ),
                              selectedStyle: C2ChipStyle(
                                foregroundStyle: AppTextStyles.interWhite12BoldStyle,
                                backgroundColor: buttonBlue.withOpacity(0.8),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(30),
                                ),
                              ),
                            ),
                          );
                        }),
                        Consumer2<ReportViewModel, ClergyViewModel>(
                            builder: (_, rvm, cvm, __) {
                              return MyElevatedButton(
                                height: 30,
                                width: 250,
                                onPressed: () {
                                  rvm.getFatherDetails(cvm.filteredClergyList);
                                  confirmDownloadDialog(
                                      context: context,
                                      title: "Download Excel",
                                      text: "Do you want to download the Excel file?",
                                      yesText: "Download",
                                      noText: "Cancel",
                                      onNo: () {
                                        finish(context);
                                      },
                                      onYes: () {
                                        rvm.downloadClergyToExcelWeb(context,rvm.fatherReportModelList);
                                      });
                                },
                                borderRadius:
                                const BorderRadius.all(Radius.circular(60)),
                                child: const Text("Download Excel",
                                    style: AppTextStyles.interWhite12BoldStyle),
                              );
                            }),

                      ],
                    ),
                  ),
          
                  Container(
                    height: 45,
                    color: Colors.grey.withOpacity(0.3),
                    padding: EdgeInsets.symmetric(horizontal: 7),
                    child: Row(
                      children: [
                        const Expanded(
                          flex: 1,
                          child: Padding(
                            padding: EdgeInsets.only(right: 8.0, left: 8),
                            child: Text(
                              "FATHER",
                              style: TextStyle(
                                  fontFamily: "PoppinsB",
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                          ),
                        ),
                        const Expanded(
                          flex: 1,
                          child: Text(
                            "PHONE NUMBER",
                            style: TextStyle(
                                fontFamily: "PoppinsB",
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ),
                        const Expanded(
                          flex: 1,
                          child: Text(
                            "IN CHARGE",
                            style: TextStyle(
                                fontFamily: "PoppinsB",
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ),
                        const Expanded(
                          flex: 1,
                          child: Text(
                            "STATUS",
                            style: TextStyle(
                                fontFamily: "PoppinsB",
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ),
                        const Expanded(
                          flex: 1,
                          child: Text(
                            "ADDRESS",
                            style: TextStyle(
                                fontFamily: "PoppinsB",
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ),
                        const Expanded(
                          flex: 1,
                          child: Text(
                            "IMAGE",
                            style: TextStyle(
                                fontFamily: "PoppinsB",
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ),
                        userTypeGlobal==2?   SizedBox(
                          width: 120,
                          child: Text(
                            "ACTION",
                            style: TextStyle(
                                fontFamily: "PoppinsB",
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ):SizedBox(),
                      ],
                    ),
                  ),
          
                  Consumer<ClergyViewModel>(
                      builder: (_,clv,__) {
                        return Expanded(
                          child:ListView.builder(
                            itemCount: clv.filteredClergyList.where((item) => item.fatherName != "Not Assigned").length,
                            shrinkWrap: true,
                            itemBuilder: (BuildContext context, int index) {
                              var filteredList = clv.filteredClergyList.where((item) => item.fatherName != "Not Assigned").toList();
                              var item = filteredList[index];

                              Color backgroundColor = index % 2 == 0 ? Colors.white : Colors.grey[200]!;

                              return Material(
                                color: backgroundColor,
                                child: InkWell(
                                  onTap: () {
                                    dv.getFatherDetails(item.fatherId);
                                    dv.scaffoldFather.currentState!.openEndDrawer();
                                  },
                                  child: father(context, item),
                                ),
                              );
                            },
                          ),
                        );
                      }
                  )
                ],
              ),
            ),
          ),
        );
      }
    );
  }
  Widget father(BuildContext context,ClergyModel clergy){
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      height: 45,
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child:customNormalText(text: clergy.fatherName, color: myBlack, fontSize: 15),
          ),
          Expanded(
            flex: 1,
            child:customNormalText(text: clergy.phoneNumber, color: myBlack, fontSize: 15),
          ),

          Expanded(
            flex: 1,
            child:customNormalText(text: clergy.vicarAt, color: myBlack, fontSize: 15),
          ),
          Consumer<WebViewModel>(
            builder: (_,wv,__) {

              return Expanded(
                flex: 1,
                child:customNormalText(text: wv.showStatus(clergy.status), color: myBlack, fontSize: 15),
              );
            }
          ),
          Expanded(
            flex: 1,
            child:customNormalText(text:clergy.address, color: myBlack, fontSize: 15),
          ),
          Expanded(
            flex: 1,
            child:clergy.image==""?Consumer<WebViewModel>(
              builder: (_,wv,__) {
                return MyElevatedButton(
                  height: 30,
                  width: 250,
                  onPressed: () {
                    UserModel fatherModel=UserModel(userId: clergy.fatherId, fatherName: clergy.fatherName, type: clergy.type, primaryAt: "", primaryAtId: "", secondaryVicarAt: "", secondaryVicarAtId: "", dioceseSecretary: "",dioceseSecretaryId: "",phoneNumber: "", secondaryNumber: "", emailId: "", presentAddress: "", permanentAddress: "", place: "", district: "", state: "", motherParish: "", dob: "", bloodGroup: "", ordination: "", positions: "", status: 0, image: "");
                    wv.getImage(context,from: "father",user:  fatherModel);
                  },
                  borderRadius:
                  const BorderRadius.all(
                      Radius.circular(60)),
                  child: const Text(
                      "upload Image",
                      style:AppTextStyles.interWhite12BoldStyle
                  ),
                );
              }
            ):customNormalText(text:"Image uploaded", color: myBlack, fontSize: 15),
          ),
          userTypeGlobal==2?  Expanded(
            flex: 1,
            child:Consumer2<WebViewModel,EditViewModel>(
              builder: (_,wv,ev,__) {
                return InkWell(
                    onTap: (){
                      print(clergy.fatherId);
                      deleteDialog(context, "Do you want to remove father ${clergy.fatherName}", "Delete", clergy.fatherId);
                    },
                    child: Icon(Icons.delete_sweep,color: myRed,));
              }
            ),
          ):SizedBox(),
        ],
      ),
    );
  }
  Widget fatherView(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return Consumer2<DetailedViewModel,WebViewModel>(builder: (_, dv,wv, __) {
      return Scaffold(
        backgroundColor: myWhite,
        body: SafeArea(
            child: SingleChildScrollView(
              child: dv.fatherDetailModel != null
                  ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          SizedBox(
                            height: 258,
                            width: width,
                            child: dv.fatherDetailModel!.image == ""
                                ? Image.asset(
                              "assets/images/father_place_holder.png",
                              fit: BoxFit.cover,
                              alignment: Alignment.topCenter,
                            )
                                : Image.network(
                              dv.fatherDetailModel!.image,
                              fit: BoxFit.cover,
                              alignment: Alignment.topCenter,
                            ),
                          ),
                          Positioned(
                            bottom: 10, // Adjusts button position
                            child: ElevatedButton.icon(
                              onPressed: () {
                                wv.getImage(context,from: "father",user:  dv.fatherDetailModel!);
                              },
                              icon: Icon(Icons.camera_alt),
                              label: Text("Change Photo"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black.withOpacity(0.6), // Semi-transparent button
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                        ],
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
                                    child: customBoldText(text:ev.showFatherStatus(dv.fatherDetailModel!) , color: buttonBlue, fontSize: 14),
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
                            SizedBox(width:250,
                              child: customBoldText(
                                  text:dv.fatherDetailModel!.fatherName,
                                  color: myBlack,
                                  fontSize: 18),
                            ),
                            Consumer<EditViewModel>(
                                builder: (_,ev,__) {
                                  return InkWell(
                                    onTap: (){
                                      ev.fetchNameDetails(dv.fatherDetailModel!);
                                     editNameDialog(context,father:dv.fatherDetailModel! );
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
                        customNormalText(
                            text: dv.fatherDetailModel!.positions,
                            color: myGreyText,
                            fontSize: 16),
                        const SizedBox(
                          height: 20,
                        ),
                        dv.fatherDetailModel!.primaryAt!=""?Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            customNormalText(
                                text: "Primary Vicar at",
                                color: myGreyText,
                                fontSize: 14),
                            const SizedBox(
                              height: 10,
                            ),
                            customNormalText(
                                text: dv.fatherDetailModel!.primaryAt,
                                color: myBlack,
                                fontSize: 16),
                            const SizedBox(
                              height: 5,
                            ),
                          ],
                        ):const SizedBox(),
                        const SizedBox(height: 8,),
                        dv.fatherDetailModel!.secondaryVicarAt!=""?Column(
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
                                text: dv.fatherDetailModel!.secondaryVicarAt,
                                color: myBlack,
                                fontSize: 16),
                            const SizedBox(
                              height: 5,
                            ),
                          ],
                        ):const SizedBox(),
                        const SizedBox(height: 8,),
                        dv.fatherDetailModel!.dioceseSecretary!=""?Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            customNormalText(
                                text: "Diocese Secretary at",
                                color: myGreyText,
                                fontSize: 14),
                            const SizedBox(
                              height: 10,
                            ),
                            customNormalText(
                                text: "${dv.fatherDetailModel!.dioceseSecretary}",
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
                                      ev.fetchContactDetails( dv.fatherDetailModel!);
                                      editContactDialog(context,father:dv.fatherDetailModel!);
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            detailsAdapter(context, "phone",
                                dv.fatherDetailModel!.phoneNumber),
                            InkWell(
                                onTap: (){
                                  wv.clearNewNumber();
                                  changeNumberDialog(context,father: dv.fatherDetailModel );
                                },
                                child: customNormalText(text: "Change Number", color: buttonBlue, fontSize: 14))
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: detailsAdapter(context, "phone",
                              dv.fatherDetailModel!.secondaryNumber),
                        ),
                        detailsAdapter(
                            context, "mail", dv.fatherDetailModel!.emailId),
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
                                      ev.fetchAddress(dv.fatherDetailModel!);
                                      editAddressDialog(context,father:dv.fatherDetailModel!);
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
                            text: dv.fatherDetailModel!.permanentAddress, color: myBlack, fontSize: 16),
                        SizedBox(height: 10,),
                        customNormalText(
                            text: "Present Address",
                            color: myGreyText,
                            fontSize: 14),
                        const SizedBox(
                          height: 5,
                        ),

                        customNormalText(
                            text: dv.fatherDetailModel!.presentAddress, color: myBlack, fontSize: 16),
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
                            text: dv.fatherDetailModel!.motherParish==""?"Not assigned":dv.fatherDetailModel!.motherParish, color: myBlack, fontSize: 16),
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
                                      ev.fetchOtherDetails(dv.fatherDetailModel!);
                                      editOtherDialog(context,father:dv.fatherDetailModel!);
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
                            text: dv.fatherDetailModel!.dob, color: myBlack, fontSize: 16),
                        SizedBox(height: 10,),
                        customNormalText(
                            text: "Blood Group",
                            color: myGreyText,
                            fontSize: 14),
                        const SizedBox(
                          height: 5,
                        ),

                        customNormalText(
                            text: dv.fatherDetailModel!.bloodGroup, color: myBlack, fontSize: 16),
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
                            text: dv.fatherDetailModel!.ordination, color: myBlack, fontSize: 16),
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

  Widget detailsAdapter(BuildContext context, String asset, String content) {
    return Row(
      children: [
        SizedBox(
            height: 30,
            width: 30,
            child: Image.asset("assets/images/$asset.png")),
        const SizedBox(
          width: 10,
        ),
        customNormalText(text: content, color: myBlack, fontSize: 16)
      ],
    );
  }

}
