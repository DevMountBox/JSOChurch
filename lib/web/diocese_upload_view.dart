import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jsochurch/models/diocese_detail_model.dart';
import 'package:jsochurch/models/diocese_model.dart';
import 'package:jsochurch/utils/my_colors.dart';
import 'package:jsochurch/viewmodels/clergy_view_model.dart';
import 'package:jsochurch/viewmodels/select_church_view_model.dart';
import 'package:jsochurch/viewmodels/select_diocese_view_model.dart';
import 'package:jsochurch/web/view_models/web_view_model.dart';
import 'package:jsochurch/widgets/text_widget.dart';
import 'package:provider/provider.dart';

import '../utils/alert_diologs.dart';
import '../utils/app_text_styles.dart';
import '../utils/buttons.dart';
import '../utils/excel_to_json.dart';
import '../utils/my_functions.dart';
import '../viewmodels/detailed_view_model.dart';
import '../viewmodels/report_view_model.dart';
import '../widgets/adapter_widgets.dart';

class DioceseUploadView extends StatelessWidget {
  const DioceseUploadView({super.key});

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return Consumer<DetailedViewModel>(builder: (_, dv, __) {
      return SelectionArea(
        child: Scaffold(
          key: dv.scaffoldDiocese,
          backgroundColor: myWhite,
          endDrawer: dv.dioceseDetailModel != null
              ? Drawer(
                  width: width * .3,
                  child: dioceseView(context),
                )
              : const SizedBox(),
          body: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Text(
                          'Dioceses',
                          style: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.w600,
                              color: myBlack,
                              fontFamily: "Poppins"),
                        ),
                        const SizedBox(width: 15,),
                        Consumer2<WebViewModel,ClergyViewModel>(
                          builder: (_,wv,cv,__) {
                            return MyElevatedButton(
                              height: 30,
                              width: 250,
                              onPressed: () {
                                cv.getAllClergyList();
                                ExcelToJson().convert().then((onValue) {
                                  var jsonResponse = json.decode(onValue.toString());
                                  List<dynamic> map = jsonResponse as List;
                                  wv.uploadDioceseToFirebase(map,cv);
                                });
                              },
                              borderRadius:
                              const BorderRadius.all(
                                  Radius.circular(60)),
                              child:const Text(
                                  "Upload Diocese Excel",
                                  style:AppTextStyles.interWhite12BoldStyle
                              ),
                            );
                          }
                        ),
        
                      ],
                    ),
                    Row(
                      children: [
                        // MyElevatedButton(
                        //   height: 30,
                        //   width: 150,
                        //   onPressed: () {
                        //     addDioceseDialog(context);
                        //   },
                        //   borderRadius:
                        //   const BorderRadius.all(
                        //       Radius.circular(60)),
                        //   child: Text(
                        //       "+ Add Diocese",
                        //       style:AppTextStyles.interWhite12BoldStyle
                        //   ),
                        // ),
                        SizedBox(width: 20,),

                        Consumer<SelectDioceseViewModel>(builder: (_, value, __) {
                          return SizedBox(
                            width: width * 0.2,
                            height: 30,
                            child: TextField(
                              style: const TextStyle(
                                  fontSize: 12, fontFamily: "Poppins"),
                              decoration: const InputDecoration(
                                fillColor: Colors.white,
                                filled: true,
                                hintText: 'Search Diocese',
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
                                value.searchDiocese(item);
                              },
                            ),
                          );
                        }),
                      ],
                    )
                  ],
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: Container(
                    height: 1,
                    color: myGreyText.withOpacity(0.2),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Consumer2<ReportViewModel, SelectDioceseViewModel>(
                        builder: (_, rvm, dv, __) {
                          return MyElevatedButton(
                            height: 30,
                            width: 250,
                            onPressed: () {
                              rvm.getDioceseDetails(dv.filteredDioceseList);
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
                                    rvm.downloadDioceseToExcelWeb(context,rvm.dioceseReportModelList);
                                  });
                            },
                            borderRadius:
                            const BorderRadius.all(Radius.circular(60)),
                            child: const Text("Download Excel",
                                style: AppTextStyles.interWhite12BoldStyle),
                          );
                        })
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  height: 45,
                  color: Colors.grey.withOpacity(0.3),
                  padding: EdgeInsets.symmetric(horizontal: 7),
                  child: const Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: EdgeInsets.only(right: 8.0, left: 8),
                          child: Text(
                            "DIOCESE",
                            style: TextStyle(
                                fontFamily: "PoppinsB",
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ),
                      ),
                      Expanded(
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
                      Expanded(
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
                      Expanded(
                        flex: 1,
                        child: Text(
                          "NO. OF CHURCHES",
                          style: TextStyle(
                              fontFamily: "PoppinsB",
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                      ),
                      Expanded(
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
                      Expanded(
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
                    ],
                  ),
                ),
                Consumer<SelectDioceseViewModel>(builder: (_, dv, __) {
                  return Expanded(
                      child: ListView.builder(
                    itemCount: dv.filteredDioceseList.length,
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      var item = dv.filteredDioceseList[index];
        
                      Color backgroundColor =
                          index % 2 == 0 ? Colors.white : Colors.grey[200]!;
        
                      return Material(
                        color: backgroundColor,
                        child: Consumer<DetailedViewModel>(builder: (_, dv, __) {
                          return InkWell(
                              onTap: () {
                                dv.getDioceseDetails(item.dioceseId);
                                dv.scaffoldDiocese.currentState!.openEndDrawer();
                              },
                              child: diocese(context, item));
                        }),
                      );
                    },
                  ));
                })
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget diocese(BuildContext context, DioceseModel diocese) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      height: 45,
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: customNormalText(
                text: diocese.dioceseName, color: myBlack, fontSize: 15),
          ),
          Expanded(
            flex: 1,
            child: customNormalText(
                text: diocese.phoneNumber, color: myBlack, fontSize: 15),
          ),
          Expanded(
            flex: 1,
            child: customNormalText(
                text:diocese.dioceseMetropolitan, color: myBlack, fontSize: 15),
          ),
          Expanded(
            flex: 1,
            child: customNormalText(
                text: diocese.churchCount.toString(),
                color: myBlack,
                fontSize: 15),
          ),
          Expanded(
            flex: 1,
            child:
                customNormalText(text:diocese.address, color: myBlack, fontSize: 15),
          ),
          Expanded(
            flex: 1,
            child:diocese.image==""?Consumer<WebViewModel>(
                builder: (_,wv,__) {
                  return MyElevatedButton(
                    height: 30,
                    width: 250,
                    onPressed: () {
                      DioceseDetailModel dioceseModel=DioceseDetailModel(dioceseId: diocese.dioceseId, dioceseName: diocese.dioceseName, region: [], phoneNumber: '', website: "", noOfChurches: "", address: "", dioceseMetropolitan: "", dioceseMetropolitanPhone: "", dioceseMetropolitanId: "", dioceseSecretary: "", dioceseSecretaryPhone: "", dioceseSecretaryId: "", image: "");
                      wv.getImage(context,from: "diocese",diocese:  dioceseModel);
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

        ],
      ),
    );
  }

  Widget dioceseView(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: myWhite,
      body: SafeArea(child: SingleChildScrollView(
        child: Consumer2<DetailedViewModel,WebViewModel>(builder: (_, dv,wv, __) {
          return dv.dioceseDetailModel != null
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
                child: dv.dioceseDetailModel!.image == ""
                    ? Image.asset("assets/images/diocese_place_holder.png", fit: BoxFit.cover)
                    : Image.network(
                  dv.dioceseDetailModel!.image,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                bottom: 10, // Adjusts button position
                child: ElevatedButton.icon(
                  onPressed: () {
                    wv.getImage(context,from: "diocese",diocese:  dv.dioceseDetailModel!);

                  },
                  icon: Icon(Icons.camera_alt),
                  label: Text("Change Photo"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.withOpacity(0.6),
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
                          right: 10,
                          child: Consumer2<WebViewModel,ClergyViewModel>(
                            builder: (_,wv,cv,__) {
                              return InkWell(
                                onTap: () {
                                  cv.getAllClergyList();
                                  wv.setDioceseEdit(diocese:dv.dioceseDetailModel!);
                                  editDioceseDialog(context,diocese:dv.dioceseDetailModel );
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

                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15.0, vertical: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          customBoldText(
                              text: dv.dioceseDetailModel!.dioceseName,
                              color: myBlack,
                              fontSize: 24),
                          const SizedBox(
                            height: 5,
                          ),
                          customNormalText(
                              text: dv.dioceseDetailModel!.address,
                              color: myGreyText,
                              fontSize: 16),
                          const SizedBox(
                            height: 20,
                          ),
                          detailsAdapter(context, "phone",
                              dv.dioceseDetailModel!.phoneNumber),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: detailsAdapterUrl(context, "website",
                                dv.dioceseDetailModel!.website),
                          ),
                          Consumer3<WebViewModel,SelectChurchViewModel,SelectDioceseViewModel>(
                            builder: (_,wv,scv,sdv,__) {
                              return InkWell(

                                onTap: (){

                                  scv.addToDioceseFilter([sdv.dioceseList.singleWhere((element) => element.dioceseId== dv.dioceseDetailModel!.dioceseId,)]);
                                  scv.filteredChurches();
                                  wv.changeNavPage(1);
                                },

                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                                  child: detailsAdapter(context, "dioceses",
                                      "${dv.dioceseDetailModel!.noOfChurches} churches"),
                                ),
                              );
                            }
                          ),
                          Divider(
                            color: myChipText.withOpacity(.25),
                            indent: 5,
                            endIndent: 5,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          customBoldText(
                              text: "Diocese Metropolitan",
                              color: myBlack,
                              fontSize: 18),
                          const SizedBox(
                            height: 10,
                          ),
                          diocesePositionedFatherAdapterWeb(
                              context: context,
                              phone:dv.dioceseDetailModel!.phoneNumber ,
                              image:
                              "",
                              name: dv.dioceseDetailModel!.dioceseMetropolitan),
                          const SizedBox(
                            height: 20,
                          ),
                          customBoldText(
                              text: "Diocese Secretary",
                              color: myBlack,
                              fontSize: 18),
                          const SizedBox(
                            height: 10,
                          ),
                          diocesePositionedFatherAdapterWeb(
                              context: context,
                              phone:"",
                              image:
                              "",
                              name: dv.dioceseDetailModel!.dioceseSecretary),
                        ],
                      ),
                    ),
                  ],
                )
              : const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(child: CircularProgressIndicator()),
                  ],
                );
        }),
      )),
    );
  }

  Widget detailsAdapterUrl(BuildContext context, String asset, String content) {
    return Row(
      children: [
        SizedBox(
          height: 30,
          width: 30,
          child: Image.asset("assets/images/$asset.png"),
        ),
        const SizedBox(width: 10),
        customHyperlinkText(text: content, color: Colors.blue, fontSize: 16),
      ],
    );
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
