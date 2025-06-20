import 'package:flutter/material.dart';
import 'package:jsochurch/utils/globals.dart';
import 'package:jsochurch/viewmodels/select_church_view_model.dart';
import 'package:jsochurch/viewmodels/select_diocese_view_model.dart';
import 'package:jsochurch/views/select_churches_view.dart';
import 'package:jsochurch/web/view_models/edit_view_model.dart';
import 'package:jsochurch/widgets/text_fields.dart';
import 'package:provider/provider.dart';

import '../models/parishEnterModel.dart';
import '../utils/alert_diologs.dart';
import '../utils/app_text_styles.dart';
import '../utils/buttons.dart';
import '../utils/my_colors.dart';
import '../utils/my_functions.dart';
import '../widgets/text_widget.dart';

class EditFatherView extends StatelessWidget {
  final String from;

  const EditFatherView({super.key,required this.from});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: myWhite,
      appBar: AppBar(
        backgroundColor: myWhite,
        centerTitle: true,
        title: customBoldText(text:from=="name"? "Edit Account":from=="contact"?"Edit Contact info":from=="address"?"Edit Address":from=="other"?"Other Details":"Edit Father info", color: myBlack, fontSize: 18),
        leading:  InkWell(
            onTap: () {
              finish(context);
            },child: const Icon(Icons.arrow_back_ios,color: buttonBlue,)),
      ),
      bottomNavigationBar: Consumer<EditViewModel>(
          builder: (_,sv,__) {
            return BottomAppBar(
              height: 100,
              padding: const EdgeInsets.symmetric(vertical: 5),
              color: myWhite,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0,vertical: 20),
                child: Center(
                  child: Consumer<EditViewModel>(
                    builder: (_,ev,__) {
                      return MyElevatedButton(
                        height: 45,
                        width: double.infinity,
                        onPressed: () async {
                          Map<String, dynamic> updateData={};

                          if(from=="name"){
                            updateData=ev.setNameData();
                          }else if(from=="contact"){
                            updateData=ev.setContactData();

                          }else if(from=="address"){
                            updateData=ev.setAddressData();

                          }else if(from=="other"){
                            updateData=ev.setOtherData();
                          }
                         updateProfileAlert(context,"are you sure to update your $from details ?","confirm",updateData,loginUser!);
                        },
                        borderRadius:
                        const BorderRadius.all(
                            Radius.circular(60)),
                        child:const Text(
                            "Update",
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


      body: SafeArea(child:from=="name"?editNameInfo(context):from=="contact"?editContactInfo(context):from=="address"?editAddressInfo(context):from=="other"?editOtherInfo(context):const SizedBox()),
    );
  }


}
Widget editNameInfo(BuildContext context) {
  return Consumer<EditViewModel>(
    builder: (_, ev, __) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  customBoldText(text: "Name", color: myBlack, fontSize: 14),
                  const SizedBox(height: 5),
                  textField(
                      context,
                      "",
                      ev.fatherNameController,
                      ev.formFatherName,
                      "validateString"),
                  const SizedBox(height: 15),
                ],
              ),
              // customBoldText(text: "Positions", color: myBlack, fontSize: 14),
              // const SizedBox(height: 5),
              // ListView.builder(
              //   padding: EdgeInsets.zero,
              //   itemCount: ev.positionControllerList.length,
              //   shrinkWrap: true,
              //   physics: const NeverScrollableScrollPhysics(),
              //   itemBuilder: (context, index) {
              //     var item = ev.positionControllerList[index];
              //     return Padding(
              //       padding: const EdgeInsets.only(bottom: 5),
              //       child: Row(
              //         children: [
              //           Expanded(
              //             child: textField(context, "", item,
              //                 GlobalKey<FormState>(), "validateString"),
              //           ),
              //           const SizedBox(width: 8),
              //           InkWell(
              //             onTap:(){
              //               if(index==0){
              //                 ev.addPosition();
              //               }else{
              //                 ev.removePosition(index);
              //               }
              //             },
              //             child: Container(
              //               height: 45,
              //               width: 45,
              //               decoration:  BoxDecoration(
              //                 shape: BoxShape.circle,
              //                 color: index>0?Colors.red: buttonBlue,
              //               ),
              //               child:  Icon(
              //                 index>0?Icons.remove:Icons.add,
              //                 color: myWhite,
              //                 size: 20,
              //               ),
              //             ),
              //           ),
              //         ],
              //       ),
              //     );
              //   },
              // ),
              const SizedBox(height: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  customBoldText(text: "Status", color: myBlack, fontSize: 14),
                  const SizedBox(height: 5),
                  Form(
                    key: ev.formStatus,
                    child: DropdownButtonFormField<ParishEnterModel>(
                      value: ev.selectedStatus,
                      style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 12,
                          color: myBlack),
                      isExpanded: true,
                      hint: const Text(
                        "-select-",
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 12,
                            color: myBlack),
                      ),
                      elevation: 30,
                      decoration: InputDecoration(
                        isDense: true,
                        filled: true,
                        fillColor: myWhite,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 12),
                        focusedBorder: greyBorder,
                        enabledBorder: greyBorder,
                        errorBorder: greyBorder,
                        disabledBorder: greyBorder,
                      ),
                      validator: (item) {
                        if (item == null ||
                            item.parishEnterType == "--select--") {
                          return 'Please select a Status';
                        } else {
                          return null;
                        }
                      },
                      onChanged: (ParishEnterModel? newValue) {
                        ev.setStatus(newValue!);
                      },
                      items: ev.statusList
                          .map<DropdownMenuItem<ParishEnterModel>>(
                              (ParishEnterModel value) {
                            return DropdownMenuItem<ParishEnterModel>(
                              value: value,
                              child: Text(value.parishEnterType,
                                  overflow: TextOverflow.ellipsis),
                            );
                          }).toList(),
                    ),
                  ),
                  const SizedBox(height: 15),
                ],
              ),
              ev.selectedStatus.id==1? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  customBoldText(
                      text: "Primary Vicar at", color: myBlack, fontSize: 14),
                  const SizedBox(height: 5),
                  Consumer2<SelectChurchViewModel,SelectDioceseViewModel>(
                      builder: (_,cv,dv,__) {
                        return InkWell(
                          onTap: (){
                            dv.getDioceses();
                            cv.getChurches();
                            callNext(const SelectChurchesView(from: "vicar1",), context);
                          },
                          child:Container(
                            height: 45,
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(Radius.circular(8)),
                              border: Border.all(color: myGreyText.withOpacity(0.2)),
                              color: myWhite,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween, // Ensures spacing
                              children: [
                                customNormalText(
                                  text: ev.primaryVicarChurchName.isNotEmpty
                                      ? ev.primaryVicarChurchName
                                      : "Not Assigned", // Show "Not Assigned" when empty
                                  color: myBlack,
                                  fontSize: 14,
                                ),
                                if (ev.primaryVicarChurchName.isNotEmpty)
                                  GestureDetector(
                                    onTap: () {
                                      ev.clearVicar1();
                                    },
                                    child: Icon(Icons.close, color: myGreyText),
                                  ),
                              ],
                            ),
                          ),
                        );
                      }
                  ),

                  const SizedBox(height: 15),
                ],
              ):const SizedBox(),
              ev.selectedStatus.id==1?   Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  customBoldText(
                      text: "Secondary vicar at", color: myBlack, fontSize: 14),
                  const SizedBox(height: 5),
                  Consumer2<SelectChurchViewModel,SelectDioceseViewModel>(
                      builder: (_,cv,dv,__) {
                        return InkWell(
                          onTap: (){
                            dv.getDioceses();
                            cv.getChurches();
                            callNext(const SelectChurchesView(from: "vicar2",), context);
                          },
                          child: Container(
                            height: 45,
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(Radius.circular(8)),
                              border: Border.all(color: myGreyText.withOpacity(0.2)),
                              color: myWhite,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                customNormalText(
                                  text: ev.secondaryVicarChurchName.isNotEmpty
                                      ? ev.secondaryVicarChurchName
                                      : "Not Assigned",
                                  color: myBlack,
                                  fontSize: 14,
                                ),
                                if (ev.secondaryVicarChurchName.isNotEmpty)
                                  GestureDetector(
                                    onTap: () {
                                      ev.clearVicar2();
                                    },
                                    child: Icon(Icons.close, color: myGreyText),
                                  ),
                              ],
                            ),
                          ),
                        );
                      }
                  ),

                  const SizedBox(height: 15),
                ],
              ):const SizedBox(),
            ],
          ),
        ),
      );
    },
  );
}
Widget editContactInfo(BuildContext context) {
  return Consumer<EditViewModel>(
      builder: (_,ev,__) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  customBoldText(text: "Mobile Number", color: myBlack, fontSize: 14),
                  const SizedBox(height: 5),
                  textField(enabled: false,context, "", ev.primaryPhoneController, GlobalKey<FormState>(), "validateString"),
                  const SizedBox(height: 15),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  customBoldText(text: "Phone Number", color: myBlack, fontSize: 14),
                  const SizedBox(height: 5),
                  textField(context, "", ev.secondaryPhoneController, GlobalKey<FormState>(), "validateString"),
                  const SizedBox(height: 15),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  customBoldText(text: "Email", color: myBlack, fontSize: 14),
                  const SizedBox(height: 5),
                  textField(context, "",ev.emailController, GlobalKey<FormState>(), "validateString"),
                  const SizedBox(height: 15),
                ],
              ),
            ],
          ),
        );
      }
  );
}
Widget editAddressInfo(BuildContext context) {
  return Consumer<EditViewModel>(
    builder: (_, ev, __) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
        child: SingleChildScrollView( // Wrap everything to make it scrollable
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  customBoldText(text: "Permanent Address", color: myBlack, fontSize: 14),
                  const SizedBox(height: 5),
                  textField(context, "", ev.permanentAddressController, GlobalKey<FormState>(), "validateString"),
                  const SizedBox(height: 5),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Theme(
                    data: Theme.of(context).copyWith(
                      checkboxTheme: CheckboxThemeData(
                        side: BorderSide(color: myGreyText.withOpacity(0.25), width: 1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                    child: Transform.scale(
                      scale: 1.2,
                      child: Checkbox(
                        value: ev.isAddress,
                        onChanged: (value) {
                          ev.sameAddress();
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: customBoldText(text: "Same as Above", color: myBlack, fontSize: 14),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  customBoldText(text: "Present Address", color: myBlack, fontSize: 14),
                  const SizedBox(height: 5),
                  textField(context, "", ev.presentAddressController, GlobalKey<FormState>(), "validateString"),
                  const SizedBox(height: 15),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  customBoldText(text: "Mother Parish", color: myBlack, fontSize: 14),
                  const SizedBox(height: 5),
                  Consumer2<SelectChurchViewModel,SelectDioceseViewModel>(
                      builder: (_,cv,dv,__) {
                        return InkWell(
                          onTap: (){
                            dv.getDioceses();
                            cv.getChurches();
                            callNext(const SelectChurchesView(from: "motherParish",), context);
                          },
                          child: Container(
                            height: 45,
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(Radius.circular(8)),
                              border: Border.all(color: myGreyText.withOpacity(0.2)),
                              color: myWhite,
                            ),
                            child: customNormalText(text: ev.motherParishChurchName, color: myBlack, fontSize: 14),
                          ),
                        );
                      }
                  ),
                  const SizedBox(height: 15),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}
Widget editOtherInfo(BuildContext context) {
  return Consumer<EditViewModel>(
      builder: (_,ev,__) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  customBoldText(text: "Date of Birth", color: myBlack, fontSize: 14),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Expanded(
                        flex: 4,
                        child: dateField(context, "dob", ev.dobController, GlobalKey<FormState>(), "validateString",ev.dobDate ?? DateTime.now()),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        flex: 1,
                        child: Container(
                          height: 45,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(Radius.circular(8)),
                            border: Border.all(color: myGreyText.withOpacity(0.2)),
                            color: myChipGrey,
                          ),
                          child: customNormalText(text: ev.age, color: myBlack, fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  customBoldText(text: "Blood Group", color: myBlack, fontSize: 14),
                  const SizedBox(height: 5),
                  Form(
                    key:ev.formBlood,
                    child: DropdownButtonFormField<String>(
                      value: ev.selectedBloodGroup,
                      style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 12,
                          color: myBlack),
                      isExpanded: true,
                      hint: const Text(
                        "-select-",
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 12,
                            color: myBlack),
                      ),
                      elevation: 30,
                      decoration: InputDecoration(
                        isDense: true,
                        filled: true,
                        fillColor: myWhite,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 12),
                        focusedBorder: greyBorder,
                        enabledBorder: greyBorder.copyWith(
                            borderSide: const BorderSide(color: myChipGrey)),
                        errorBorder: greyBorder,
                        disabledBorder: greyBorder,
                      ),
                      validator: (item) {
                        if (item == null ||
                            item == "--select--") {
                          return 'Please select a blood group';
                        } else {
                          return null;
                        }
                      },
                      onChanged: (String? newValue) {
                        ev.setBloodGroup(newValue!);

                      },
                      items: ev.bloodGroupList
                          .map<DropdownMenuItem<String>>(
                              (String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value,
                                  overflow: TextOverflow.ellipsis),
                            );
                          }).toList(),
                    ),
                  ),
                  const SizedBox(height: 15),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  customBoldText(text: "Ordination date", color: myBlack, fontSize: 14),
                  const SizedBox(height: 5),
                  dateField(context, "", ev.ordinationDateController, GlobalKey<FormState>(), "validateString",ev.ordinationDate ?? DateTime.now()),
                  const SizedBox(height: 15),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  customBoldText(text: "Ordination as priest", color: myBlack, fontSize: 14),
                  const SizedBox(height: 5),
                  textField(context, "",ev.ordinationPriestController, GlobalKey<FormState>(), "validateString"),
                  const SizedBox(height: 15),
                ],
              ),
            ],
          ),
        );
      }
  );
}
