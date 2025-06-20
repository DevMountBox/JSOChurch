import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jsochurch/models/church_detail_model.dart';
import 'package:jsochurch/models/church_model.dart';
import 'package:jsochurch/models/diocese_model.dart';
import 'package:jsochurch/utils/alert_diologs.dart';
import 'package:jsochurch/utils/my_functions.dart';
import 'package:jsochurch/viewmodels/clergy_view_model.dart';
import 'package:jsochurch/viewmodels/detailed_view_model.dart';
import 'package:jsochurch/viewmodels/report_view_model.dart';
import 'package:jsochurch/viewmodels/select_church_view_model.dart';
import 'package:jsochurch/viewmodels/select_diocese_view_model.dart';
import 'package:jsochurch/web/view_models/web_view_model.dart';
import 'package:provider/provider.dart';

import '../utils/app_text_styles.dart';
import '../utils/buttons.dart';
import '../utils/excel_to_json.dart';
import '../utils/globals.dart';
import '../utils/my_colors.dart';
import '../widgets/adapter_widgets.dart';
import '../widgets/text_fields.dart';
import '../widgets/text_widget.dart';

class ChurchUploadView extends StatelessWidget {
  const ChurchUploadView({super.key});

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return Consumer<DetailedViewModel>(builder: (_, dv, __) {
      return SelectionArea(
        child: Scaffold(
          key: dv.scaffoldChurch,
          backgroundColor: myWhite,
          endDrawer: dv.churchDetailModel != null
              ? Drawer(
                  width: width * .3,
                  child: churchView(context),
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
                          'Churches',
                          style: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.w600,
                              color: myBlack,
                              fontFamily: "Poppins"),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Consumer3<WebViewModel, SelectDioceseViewModel,
                            ClergyViewModel>(builder: (_, wv, sdv, cv, __) {
                          return MyElevatedButton(
                            height: 30,
                            width: 250,
                            onPressed: () {
                              cv.getAllClergyList();
                              ExcelToJson().convert().then((onValue) {
                                var jsonResponse =
                                    json.decode(onValue.toString());
                                List<dynamic> map = jsonResponse as List;
                                wv.uploadChurchesToFirebase(
                                    map, sdv.dioceseList, cv);
                              });
                            },
                            borderRadius:
                                const BorderRadius.all(Radius.circular(60)),
                            child: const Text("Upload Churches Excel",
                                style: AppTextStyles.interWhite12BoldStyle),
                          );
                        }),
                        const SizedBox(
                          width: 15,
                        ),
                        Consumer2<SelectDioceseViewModel,
                            SelectChurchViewModel>(builder: (_, sdv, scv, __) {
                          return !isSecretaryAdminLogin
                              ? Container(
                                  width: 200,
                                  height: 45,
                                  decoration: BoxDecoration(
                                      color: const Color.fromARGB(
                                          255, 254, 254, 254),
                                      borderRadius: BorderRadius.circular(5)),
                                  // margin: EdgeInsets.all(10),
                                  child: DropdownButtonHideUnderline(
                                    child: Stack(
                                      alignment: Alignment.centerRight,
                                      // Aligns close button to the right
                                      children: [
                                        DropdownButton<DioceseModel>(
                                          isExpanded: true,
                                          isDense: true,
                                          value: scv.selectedDiocese,
                                          hint: const Text("Select diocese"),
                                          items: sdv.dioceseList.map((diocese) {
                                            return DropdownMenuItem<
                                                DioceseModel>(
                                              value: diocese,
                                              child: Text(
                                                diocese.dioceseName,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            );
                                          }).toList(),
                                          onChanged: (value) {
                                            scv.addToDioceseFilter([value!]);
                                            scv.filteredChurches();
                                          },
                                          menuWidth: 300,
                                        ),
                                        // Clear button
                                        if (scv.selectedDiocese != null)
                                          Positioned(
                                            right: 8, // Adjust position
                                            child: GestureDetector(
                                              onTap: () {
                                                scv.clearSelectedDiocese();
                                              },
                                              child: Container(
                                                padding: EdgeInsets.all(4),
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Colors.grey[
                                                      300], // Background color
                                                ),
                                                child: const Icon(
                                                  Icons.close,
                                                  size: 18,
                                                  color: Colors.black54,
                                                ),
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ))
                              : SizedBox();
                        }),
                        SizedBox(
                          width: 15,
                        ),
                        Consumer2<SelectDioceseViewModel,
                            SelectChurchViewModel>(builder: (_, sdv, scv, __) {
                          return scv.isRegionAvailable()
                              ? Container(
                                  width: 200,
                                  height: 45,
                                  decoration: BoxDecoration(
                                      color: const Color.fromARGB(
                                          255, 254, 254, 254),
                                      borderRadius: BorderRadius.circular(5)),
                                  // margin: EdgeInsets.all(10),
                                  child: DropdownButtonHideUnderline(
                                    child: Stack(
                                      alignment: Alignment.centerRight,
                                      // Aligns close button to the right
                                      children: [
                                        DropdownButton<String>(
                                          isExpanded: true,
                                          isDense: true,
                                          value: scv.selectedRegion,
                                          hint: const Text("Select Region"),
                                          items: scv.regionList.map((region) {
                                            return DropdownMenuItem<String>(
                                              value: region,
                                              child: Text(
                                                region,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            );
                                          }).toList(),
                                          onChanged: (value) {
                                            scv.filterByRegion(
                                                scv.dioceseFilter[0]
                                                    .dioceseName,
                                                value!);
                                          },
                                          menuWidth: 300,
                                        ),
                                        // Clear button
                                        if (scv.selectedRegion != null)
                                          Positioned(
                                            right: 8, // Adjust position
                                            child: GestureDetector(
                                              onTap: () {
                                                scv.clearRegion();
                                              },
                                              child: Container(
                                                padding: EdgeInsets.all(4),
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Colors.grey[
                                                      300], // Background color
                                                ),
                                                child: const Icon(
                                                  Icons.close,
                                                  size: 18,
                                                  color: Colors.black54,
                                                ),
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ))
                              : SizedBox();
                        }),
                      ],
                    ),
                    Row(
                      children: [
                        // MyElevatedButton(
                        //   height: 30,
                        //   width: 150,
                        //   onPressed: () {
                        //     addChurchDialog(context);
                        //   },
                        //   borderRadius:
                        //   const BorderRadius.all(
                        //       Radius.circular(60)),
                        //   child: Text(
                        //       "+ Add Church",
                        //       style:AppTextStyles.interWhite12BoldStyle
                        //   ),
                        // ),
                        SizedBox(
                          width: 20,
                        ),
                        Consumer<SelectChurchViewModel>(
                            builder: (_, value, __) {
                          return SizedBox(
                            width: width * 0.2,
                            height: 30,
                            child: TextField(
                              style: const TextStyle(
                                  fontSize: 12, fontFamily: "Poppins"),
                              decoration: const InputDecoration(
                                fillColor: Colors.white,
                                filled: true,
                                hintText: 'Search church',
                                hintStyle: TextStyle(fontSize: 10),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 2),
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
                                value.searchChurch(item);
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
                    Consumer2<ReportViewModel, SelectChurchViewModel>(
                        builder: (_, rvm, cv, __) {
                      return MyElevatedButton(
                        height: 30,
                        width: 250,
                        onPressed: () {
                          rvm.getChurchDetails(cv.filteredChurchList);
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
                                rvm.downloadChurchesToExcelWeb(context,rvm.churchReportModelList);
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
                            "CHURCH",
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
                          "DIOCESE",
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
                          "REGION",
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
                          "VICAR",
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
                Consumer<SelectChurchViewModel>(builder: (_, cv, __) {
                  return Expanded(
                    child: ListView.builder(
                      itemCount: cv.filteredChurchList.length,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        var item = cv.filteredChurchList[index];

                        Color backgroundColor =
                            index % 2 == 0 ? Colors.white : Colors.grey[200]!;

                        return Material(
                          color: backgroundColor,
                          child: InkWell(
                              onTap: () {
                                dv.getChurchDetails(item.churchId);
                                dv.scaffoldChurch.currentState!.openEndDrawer();
                              },
                              child: church(context, item)),
                        );
                      },
                    ),
                  );
                })
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget church(BuildContext context, ChurchModel church) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      height: 45,
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: customNormalText(
                text: "${church.churchName}", color: myBlack, fontSize: 15),
          ),
          Expanded(
            flex: 1,
            child: customNormalText(
                text: church.phoneNumber, color: myBlack, fontSize: 15),
          ),
          Expanded(
            flex: 1,
            child: customNormalText(
                text: church.diocese, color: myBlack, fontSize: 15),
          ),
          Expanded(
            flex: 1,
            child: customNormalText(
                text: church.region, color: myBlack, fontSize: 15),
          ),
          Expanded(
            flex: 1,
            child: customNormalText(
                text: church.primaryVicar, color: myBlack, fontSize: 15),
          ),
          Expanded(
            flex: 1,
            child: customNormalText(
                text: church.address, color: myBlack, fontSize: 15),
          ),
          Expanded(
            flex: 1,
            child: church.image == ""
                ? Consumer<WebViewModel>(builder: (_, wv, __) {
                    return MyElevatedButton(
                      height: 30,
                      width: 250,
                      onPressed: () {
                        ChurchDetailModel churchModel = ChurchDetailModel(
                            churchId: church.churchId,
                            churchName: church.churchName,
                            diocese: church.diocese,
                            dioceseId: church.dioceseId,
                            phoneNumber: "",
                            emailId: "",
                            website: "",
                            address: "",
                            region: "",
                            primaryVicar: "",
                            primaryVicarPhone: "",
                            primaryVicarId: "",
                            assistantVicar: "",
                            assistantVicarPhone: "",
                            assistantVicarId: "",
                            image: "");
                        wv.getImage(context,
                            from: "church", church: churchModel);
                      },
                      borderRadius: const BorderRadius.all(Radius.circular(60)),
                      child: const Text("upload Image",
                          style: AppTextStyles.interWhite12BoldStyle),
                    );
                  })
                : customNormalText(
                    text: "Image uploaded", color: myBlack, fontSize: 15),
          ),
        ],
      ),
    );
  }

  Widget churchView(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return Consumer2<DetailedViewModel, WebViewModel>(builder: (_, dv, wv, __) {
      return Scaffold(
        backgroundColor: myWhite,
        body: SafeArea(
            child: SingleChildScrollView(
          child: dv.churchDetailModel != null
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
                              child: dv.churchDetailModel!.image == ""
                                  ? Image.asset(
                                      "assets/images/church_place_holder.png",
                                      fit: BoxFit.cover,
                                    )
                                  : Image.network(
                                      dv.churchDetailModel!.image,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                            Positioned(
                              bottom: 10,
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  wv.getImage(context,
                                      from: "church",
                                      church: dv.churchDetailModel!);
                                },
                                icon: Icon(Icons.camera_alt),
                                label: Text("Change Photo"),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black54,
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
                          child: Consumer3<WebViewModel, ClergyViewModel,
                                  SelectDioceseViewModel>(
                              builder: (_, wv, cv, sdv, __) {
                            return InkWell(
                              onTap: () async {
                                cv.getAllClergyList();
                                sdv.getDioceses();
                                Future.delayed(
                                    const Duration(milliseconds: 500), () {
                                  wv.setChurchEdit(cv,
                                      church: dv.churchDetailModel!);
                                  editChurchDialog(context,
                                      church: dv.churchDetailModel);
                                });
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
                          }),
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
                              text: dv.churchDetailModel!.churchName,
                              color: myBlack,
                              fontSize: 24),
                          const SizedBox(
                            height: 5,
                          ),
                          customNormalText(
                              text: dv.churchDetailModel!.address,
                              color: myGreyText,
                              fontSize: 16),
                          const SizedBox(
                            height: 20,
                          ),
                          detailsAdapter(context, "phone",
                              dv.churchDetailModel!.phoneNumber),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: detailsAdapter(
                                context, "mail", dv.churchDetailModel!.emailId),
                          ),
                          detailsAdapterUrl(context, "website",
                              dv.churchDetailModel!.website),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: detailsAdapter(context, "dioceses",
                                dv.churchDetailModel!.diocese),
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
                              text: "Church Vicar",
                              color: myBlack,
                              fontSize: 18),
                          const SizedBox(
                            height: 10,
                          ),
                          fatherPositionedAdapterWeb(
                              context: context,
                              image: "",
                              name: dv.churchDetailModel!.primaryVicar,
                              phone: dv.churchDetailModel!.primaryVicarPhone,
                              position: "Primary Vicar"),
                          const SizedBox(
                            height: 8,
                          ),
                          fatherPositionedAdapterWeb(
                              context: context,
                              image: "",
                              phone: dv.churchDetailModel!.assistantVicarPhone,
                              name: dv.churchDetailModel!.assistantVicar,
                              position: "Secondary Vicar"),
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
                ),
        )),
      );
    });
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
