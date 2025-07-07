import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:jsochurch/models/clergy_model.dart';
import 'package:jsochurch/models/diocese_model.dart';
import 'package:jsochurch/viewmodels/clergy_view_model.dart';
import 'package:jsochurch/viewmodels/select_diocese_view_model.dart';
import 'package:jsochurch/views/edit_father_view.dart';
import 'package:jsochurch/web/view_models/web_view_model.dart';
import 'package:provider/provider.dart';

import '../models/parishEnterModel.dart';
import '../viewmodels/select_church_view_model.dart';
import '../views/select_churches_view.dart';
import '../web/view_models/edit_view_model.dart';
import '../widgets/text_fields.dart';
import '../widgets/text_widget.dart';
import 'my_colors.dart';
import 'my_functions.dart';

class EditDioceseForm extends StatefulWidget {
  const EditDioceseForm({super.key});

  @override
  State<EditDioceseForm> createState() => _EditDioceseFormState();
}

class _EditDioceseFormState extends State<EditDioceseForm> {
  @override
  Widget build(BuildContext context) {
    return Consumer2<WebViewModel,ClergyViewModel>(builder: (_, wv,clv, __) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: [
              Expanded(
                child: textFieldAdd(context, wv.dioceseNameController, "Name *",
                    wv.formDioceseName, "Please enter the name first!",enable: false),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: textFieldAdd(
                    context,
                    wv.dioceseMobileController,
                    "Mobile Number *",
                    wv.formDioceseMobile,
                    "Please enter the Mobile Number"),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                  child: textFieldAdd(context, wv.dioceseWebsiteController,
                      "Website", GlobalKey(), "")),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                  child: textFieldAdd(context, wv.dioceseAddressController,
                      "Address *", wv.formDioceseAddress, "")),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                  child: TypeAheadField<ClergyModel>(
                      controller: wv.diocesePrimaryController,
                      builder: (context, controller, focusNode) =>
                          textFieldAddTypeAhead(
                              context,
                              controller,
                              "Diocese Metropolitan *",
                              wv.formDiocesePrimary,
                              "Please Select the Diocese Metropolitan",
                              focusNode),
                      decorationBuilder: (context, child) => Material(
                        type: MaterialType.card,
                        elevation: 4,
                        borderRadius:
                        const BorderRadius.all(Radius.circular(12)),
                        child: child,
                      ),
                      itemBuilder: (context, father) => ListTile(
                        title: Text(father.fatherName),
                      ),
                      onSelected: (ClergyModel suggestion) {
                        wv.selectDioceseMetropolitan(suggestion);
                      },
                      suggestionsCallback: (pattern) async {
                        return clv.clergyList
                            .where((father) =>father.type == "metropolitans" &&  father.fatherName
                            .toLowerCase()
                            .contains(pattern.toLowerCase()))
                            .toList();
                      })),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                  child: TypeAheadField<ClergyModel>(
                      controller: wv.dioceseSecondaryController,
                      builder: (context, controller, focusNode) =>
                          textFieldAddTypeAhead(
                              context,
                              controller,
                              "Diocese Secretary *",
                              wv.formDioceseSecondary,
                              "Please Select the Diocese Secretary",
                              focusNode),
                      decorationBuilder: (context, child) => Material(
                        type: MaterialType.card,
                        elevation: 4,
                        borderRadius:
                        const BorderRadius.all(Radius.circular(12)),
                        child: child,
                      ),
                      itemBuilder: (context, state) => ListTile(
                        title: Text(state.fatherName),
                      ),
                      onSelected: (ClergyModel suggestion) {
                        wv.selectDioceseSecretary(suggestion);
                      },
                      suggestionsCallback: (pattern) async {
                        return clv.clergyList
                            .where((father) => father.type != "metropolitans" &&father.fatherName
                            .toLowerCase()
                            .contains(pattern.toLowerCase()))
                            .toList();
                      })),
            ],
          ),
          const SizedBox(height: 10),
        ],
      );
    });
  }

  Widget textFieldAdd(BuildContext context, TextEditingController controller,
      String label, GlobalKey<FormState> formKey, String validateString,{bool enable=true}) {
    return Consumer<WebViewModel>(builder: (_, ev, __) {
      return Form(
        key: formKey,
        child: TextFormField(
          controller: controller,
          onTap: () {
            if (label == "Open Date *") {
              // ev.setOpenDate(context);
            }
          },
          inputFormatters: [
            if (label == "Mobile Number *")
              FilteringTextInputFormatter.digitsOnly,
          ],
          readOnly: label == "Open Date *" ? true : false,
          keyboardType: label == "Mobile Number *"
              ? TextInputType.phone
              : TextInputType.text,
          style: const TextStyle(
              color: Colors.black, fontFamily: "Poppins", fontSize: 12),
          maxLength: label == "Mobile Number *" ? 10 : null,
          maxLines: null,

          decoration: InputDecoration(
            enabled: enable,
              counterText: "",
              contentPadding: const EdgeInsets.all(10),
              label: Text(
                label,
                style: const TextStyle(
                    fontFamily: "Poppins", fontSize: 12, color: Colors.black),
              ),
              border: greyBorder,
              enabledBorder: greyBorder),
          validator: (text) {
            if (text == null || text.isEmpty) {
              return validateString; // Return error message for empty field
            }
            if (label == "Mobile Number *" && text.length != 10) {
              return "Enter a valid 10-digit mobile number";
            }
            if (label == "Email ID *" &&
                !RegExp(r"^[a-zA-Z0-9._]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                    .hasMatch(text)) {
              return "Enter a valid email address";
            }
            return null;
          },
        ),
      );
    });
  }

  Widget textFieldAddTypeAhead(
      BuildContext context,
      TextEditingController controller,
      String label,
      GlobalKey<FormState> formKey,
      String validateString,
      FocusNode focusNode) {
    return Consumer<WebViewModel>(builder: (_, wv, __) {
      return Form(
        key: formKey,
        child: TextFormField(
          focusNode: focusNode,
          controller: controller,
          style: const TextStyle(
              color: Colors.black, fontFamily: "Poppins", fontSize: 12),
          maxLength: null,
          maxLines: null,
          decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(10),
              label: Text(
                label,
                style: const TextStyle(
                    fontFamily: "Poppins", fontSize: 12, color: Colors.black),
              ),
              border: greyBorder,
              enabledBorder: greyBorder),
          validator: (text) => text == '' ? validateString : null,
        ),
      );
    });
  }
}

class EditChurchesForm extends StatefulWidget {
  const EditChurchesForm({super.key});

  @override
  State<EditChurchesForm> createState() => _EditChurchesFormState();
}

class _EditChurchesFormState extends State<EditChurchesForm> {
  @override
  Widget build(BuildContext context) {
    return Consumer3<WebViewModel,ClergyViewModel,SelectDioceseViewModel>(builder: (_, wv,clv,dv, __) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: [
              Expanded(
                child: textFieldAdd(context, wv.churchNameController, "Church Name *",
                    wv.formChurchName, "Please enter the name first!"),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: textFieldAdd(
                    context,
                    wv.churchMobileController,
                    "Mobile Number *",
                    wv.formChurchMobile,
                    "Please enter the Mobile Number"),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                  child: textFieldAdd(context, wv.churchEmailController,
                      "Email", GlobalKey(), "")),
              const SizedBox(width: 10),
              Expanded(
                  child: textFieldAdd(context, wv.churchWebsiteController,
                      "Website", GlobalKey(), "")),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                  child: textFieldAdd(context, wv.churchAddressController,
                      "Address *", wv.formChurchAddress, "")),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                  child: TypeAheadField<DioceseModel>(
                      controller: wv.dioceseController,
                      builder: (context, controller, focusNode) =>
                          textFieldAddTypeAhead(
                              context,
                              controller,
                              "Diocese *",
                              wv.formChurchDiocese,
                              "Please Select the Diocese",
                              focusNode),
                      decorationBuilder: (context, child) => Material(
                        type: MaterialType.card,
                        elevation: 4,
                        borderRadius:
                        const BorderRadius.all(Radius.circular(12)),
                        child: child,
                      ),
                      itemBuilder: (context, father) => ListTile(
                        title: Text(father.dioceseName),
                      ),
                      onSelected: (DioceseModel suggestion) {
                        wv.selectDiocese(suggestion);
                      },
                      suggestionsCallback: (pattern) async {
                        return dv.dioceseList
                            .where((branch) => branch.dioceseName
                            .toLowerCase()
                            .contains(pattern.toLowerCase()))
                            .toList();
                      })),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                  child: TypeAheadField<ClergyModel>(
                      controller: wv.churchPrimaryController,
                      builder: (context, controller, focusNode) =>
                          textFieldAddTypeAhead(
                              context,
                              controller,
                              "Church Primary Vicar *",
                              wv.formDiocesePrimary,
                              "Please Select the Church Primary Vicar",
                              focusNode),
                      decorationBuilder: (context, child) => Material(
                        type: MaterialType.card,
                        elevation: 4,
                        borderRadius:
                        const BorderRadius.all(Radius.circular(12)),
                        child: child,
                      ),
                      itemBuilder: (context, father) => ListTile(
                        title: Text(father.fatherName),
                      ),
                      onSelected: (ClergyModel suggestion) {
                        wv.selectPrimaryVicar(suggestion);
                      },
                      suggestionsCallback: (pattern) async {
                        return clv.clergyList
                            .where((branch) => branch.fatherName
                            .toLowerCase()
                            .contains(pattern.toLowerCase()))
                            .toList();
                      })),
            ],
          ),

          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                  child: TypeAheadField<ClergyModel>(
                      controller: wv.churchSecondaryController,
                      builder: (context, controller, focusNode) =>
                          textFieldAddTypeAhead(
                              context,
                              controller,
                              "Church Secondary Vicar *",
                              wv.formChurchSecondary,
                              "Please Select the Church Secondary Vicar",
                              focusNode),
                      decorationBuilder: (context, child) => Material(
                        type: MaterialType.card,
                        elevation: 4,
                        borderRadius:
                        const BorderRadius.all(Radius.circular(12)),
                        child: child,
                      ),
                      itemBuilder: (context, state) => ListTile(
                        title: Text(state.fatherName),
                      ),
                      onSelected: (ClergyModel suggestion) {
                        wv.selectSecondaryVicar(suggestion);
                      },
                      suggestionsCallback: (pattern) async {
                        return clv.clergyList
                            .where((father) => father.fatherName
                            .toLowerCase()
                            .contains(pattern.toLowerCase()))
                            .toList();
                      })),
            ],
          ),
          const SizedBox(height: 10),
        ],
      );
    });
  }

}
Widget textFieldAdd(BuildContext context, TextEditingController controller,
    String label, GlobalKey<FormState> formKey, String validateString) {
  return Consumer<WebViewModel>(builder: (_, ev, __) {
    return Form(
      key: formKey,
      child: TextFormField(
        controller: controller,
        onTap: () {
          if (label == "Open Date *") {
            // ev.setOpenDate(context);
          }
        },
        inputFormatters: [
          if (label == "Mobile Number *")
            FilteringTextInputFormatter.digitsOnly,
        ],
        readOnly: label == "Open Date *" ? true : false,
        keyboardType: label == "Mobile Number *"
            ? TextInputType.phone
            : TextInputType.text,
        style: const TextStyle(
            color: Colors.black, fontFamily: "Poppins", fontSize: 12),
        maxLength: label == "Mobile Number *" ? 10 : null,
        maxLines: null,
        decoration: InputDecoration(
            counterText: "",
            contentPadding: const EdgeInsets.all(10),
            label: Text(
              label,
              style: const TextStyle(
                  fontFamily: "Poppins", fontSize: 12, color: Colors.black),
            ),
            border: greyBorder,
            enabledBorder: greyBorder),
        validator: (text) {
          if (text == null || text.isEmpty) {
            return validateString; // Return error message for empty field
          }
          if (label == "Mobile Number *" && text.length != 10) {
            return "Enter a valid 10-digit mobile number";
          }
          if (label == "Email ID *" &&
              !RegExp(r"^[a-zA-Z0-9._]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                  .hasMatch(text)) {
            return "Enter a valid email address";
          }
          return null;
        },
      ),
    );
  });
}

Widget textFieldAddTypeAhead(
    BuildContext context,
    TextEditingController controller,
    String label,
    GlobalKey<FormState> formKey,
    String validateString,
    FocusNode focusNode) {
  return Consumer<WebViewModel>(builder: (_, wv, __) {
    return Form(
      key: formKey,
      child: TextFormField(
        focusNode: focusNode,
        controller: controller,
        style: const TextStyle(
            color: Colors.black, fontFamily: "Poppins", fontSize: 12),
        maxLength: null,
        maxLines: null,
        decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(10),
            label: Text(
              label,
              style: const TextStyle(
                  fontFamily: "Poppins", fontSize: 12, color: Colors.black),
            ),
            border: greyBorder,
            enabledBorder: greyBorder),
        validator: (text) => text == '' ? validateString : null,
      ),
    );
  });
}


class AddFatherForm extends StatefulWidget {
  const AddFatherForm({super.key});

  @override
  State<AddFatherForm> createState() => _AddFatherFormState();
}

class _AddFatherFormState extends State<AddFatherForm> {
  @override
  Widget build(BuildContext context) {
    return Consumer<EditViewModel>(
      builder: (_,ev,__) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width*.5,
                  height: 50,
                  child: ListView.builder(
                    itemCount: ev.clergyTypeList.length,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (BuildContext context, int index) {
                      var item = ev.clergyTypeList[index];

                      return clergyTypeAdapter(context, item);
                    },
                  ),
                ),
                customBoldText(text: "Name", color: myBlack, fontSize: 14),
                const SizedBox(height: 5),
                textField(
                    context,
                    "",
                    ev.fatherNameController,
                    ev.formFatherName,
                    "Enter Father Name"),
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                customBoldText(text: "Mobile Number", color: myBlack, fontSize: 14),
                const SizedBox(height: 5),
                textField(context, "", ev.primaryPhoneController, ev.formPrimaryPhone, "Enter Phone Number"),
                const SizedBox(height: 15),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                customBoldText(text: "Phone Number", color: myBlack, fontSize: 14),
                const SizedBox(height: 5),
                textField(context, "", ev.secondaryPhoneController, GlobalKey<FormState>(), "Enter secpdnarry number"),
                const SizedBox(height: 15),
              ],
            ),

            const SizedBox(height: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                customBoldText(text: "Status", color: myBlack, fontSize: 14),
                const SizedBox(height: 5),
                Form(
                  key: ev.formStatus,
                  child: DropdownButtonFormField<ParishEnterModel>(
                    // value: ev.selectedStatus,
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
                        child: Container(
                          height: 45,
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(Radius.circular(8)),
                            border: Border.all(color: myGreyText.withOpacity(0.2)),
                            color: myWhite,
                          ),
                          child: customNormalText(text: ev.primaryVicarChurchName, color: myBlack, fontSize: 14),
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
                          child: customNormalText(text: ev.secondaryVicarChurchName, color: myBlack, fontSize: 14),
                        ),
                      );
                    }
                ),

                const SizedBox(height: 15),
              ],
            ):const SizedBox(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                customBoldText(text: "Email", color: myBlack, fontSize: 14),
                const SizedBox(height: 5),
                textField(context, "",ev.emailController, GlobalKey<FormState>(), "validateString"),
                const SizedBox(height: 15),
              ],
            ),
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
        );
      }
    );
  }
  Widget clergyTypeAdapter(BuildContext context, String type) {
    return Consumer<EditViewModel>(builder: (_, ev, __) {
      return SizedBox(
        height: 50,
        width: 150,
        child: RadioListTile(
          contentPadding: EdgeInsets.zero,
          dense: true,
          title: Text(type,style: const TextStyle(fontFamily: "PoppinsB",fontSize: 13),),
          value: type==ev.selectedClergyType? 1 : 2,
          groupValue: type==ev.selectedClergyType ? 1 : 3,
          activeColor: buttonBlue,
          onChanged: (value) {
            ev.changeClergyType(type);
          },
        ),
      );
    });
  }

}
