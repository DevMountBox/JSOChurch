import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jsochurch/models/church_model.dart';
import 'package:jsochurch/utils/globals.dart';

import '../../models/parishEnterModel.dart';
import '../../models/user_model.dart';
import '../../utils/my_functions.dart';

class EditViewModel extends ChangeNotifier {
  TextEditingController fatherNameController = TextEditingController();
  GlobalKey<FormState> formFatherName = GlobalKey<FormState>();
  List<TextEditingController> positionControllerList = [];
  List<ParishEnterModel> statusList = [
    ParishEnterModel("--select--", 0),
    ParishEnterModel("Active", 1),
    ParishEnterModel("Retired", 2),
    ParishEnterModel("Not Assigned", 3),
  ];
  GlobalKey<FormState> formStatus = GlobalKey<FormState>();
  ParishEnterModel selectedStatus = ParishEnterModel("--select--", 0);
  String primaryVicarChurchName = "";
  String secondaryVicarChurchName = "";
  ChurchModel? primaryVicarChurch;
  ChurchModel? secondaryVicarChurch;

  TextEditingController primaryPhoneController = TextEditingController();
  GlobalKey<FormState> formPrimaryPhone = GlobalKey<FormState>();
  TextEditingController secondaryPhoneController = TextEditingController();
  GlobalKey<FormState> formSecondaryPhone = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  GlobalKey<FormState> formEmail = GlobalKey<FormState>();

  TextEditingController permanentAddressController = TextEditingController();
  GlobalKey<FormState> formPermanentAddress = GlobalKey<FormState>();
  TextEditingController presentAddressController = TextEditingController();
  GlobalKey<FormState> formPresentAddress = GlobalKey<FormState>();
  ChurchModel? motherParishChurch;
  String motherParishChurchName = "";
  String age="";
  TextEditingController dobController = TextEditingController();
  DateTime? dobDate;
  GlobalKey<FormState> formDob = GlobalKey<FormState>();
  GlobalKey<FormState> formBlood = GlobalKey<FormState>();
  List<String> bloodGroupList = [
    '--select--',
    'A+',
    'A-',
    'B+',
    'B-',
    'AB+',
    'AB-',
    'O+',
    'O-'
  ];
  String selectedBloodGroup = "--select--";
  TextEditingController ordinationDateController = TextEditingController();
  DateTime? ordinationDate;
  TextEditingController ordinationPriestController = TextEditingController();
  bool isAddress=false;

  List<String> clergyTypeList = [
    "metropolitans",
    "corepiscopa",
    "priest",
    "ramban",
    "deacons"
  ];
  String selectedClergyType="";
  getChurchDetailsAndStatus() async {
    if(loginUser!.primaryAtId!=""){
      primaryVicarChurch=await getChurchById(loginUser!.primaryAtId);
    }
    if(loginUser!.secondaryVicarAtId!=""){
      secondaryVicarChurch=await getChurchById(loginUser!.secondaryVicarAtId);
    }
    selectedStatus=statusList.singleWhere((element) => element.id==loginUser!.status,);
  }
  changeClergyType(String type){
    selectedClergyType=type;
    notifyListeners();
  }
  String showStatus(){
    String status="";
  if(loginUser!.status==1||loginUser!.status==4){
    status="Active";
  }else if(loginUser!.status==2){
    status="Retired";
  }else if(loginUser!.status==3){
    status="Unassigned";
  }
    return status;
  }
  String showFatherStatus(UserModel father){
    String status="";
  if(father.status==1){
    status="Active";
  }else if(father.status==2){
    status="Retired";
  }else if(father.status==3){
    status="Unassigned";
  }
    return status;
  }

  void sameAddress(){

    if(permanentAddressController.text.isNotEmpty) {
      isAddress = !isAddress;
      notifyListeners();
      presentAddressController.text = permanentAddressController.text;
      if(!isAddress){
        presentAddressController.clear();
        notifyListeners();
      }
    }else{
      showToast("Please add your permanent address");
    }
  }

  void addPosition(){
    positionControllerList.add(TextEditingController());
    notifyListeners();
  }

  void removePosition(int index){
    positionControllerList.removeAt(index);
    notifyListeners();
  }

  void setStatus(ParishEnterModel status){
    selectedStatus=status;
    notifyListeners();
  }
  void fetchNameDetails(UserModel father) {
    positionControllerList.clear();
    fatherNameController.text = father.fatherName;
    father.positions.split(',').forEach((position) {
      positionControllerList.add(TextEditingController(text: position.trim()));
    });
    selectedStatus = statusList.singleWhere(
      (element) => element.id == father.status,
    );
    primaryVicarChurchName = father.primaryAt;
    secondaryVicarChurchName= father.secondaryVicarAt;
    notifyListeners();
  }

  void fetchContactDetails(UserModel father) {
    primaryPhoneController.text = father.phoneNumber;
    secondaryPhoneController.text = father.secondaryNumber;
    emailController.text = father.emailId;
    notifyListeners();
  }

  void fetchAddress(UserModel father) {
    permanentAddressController.text = father.permanentAddress;
    presentAddressController.text = father.presentAddress;
    motherParishChurchName = father.motherParish;
    notifyListeners();
  }

  void fetchOtherDetails(UserModel father) {
    dobController.text = father.dob;
    age=father.dob!=""?calculateAge(father.dob):"0";
    dobDate=father.dob!=""?DateFormat('dd-MM-yyyy').parse(father.dob):null;
    ordinationDate=extractText(father.ordination,isDate: true)!=""?DateFormat('dd-MM-yyyy').parse(extractText(father.ordination,isDate: true)):null;
    selectedBloodGroup = father.bloodGroup!="-"?father.bloodGroup: "--select--";
    ordinationPriestController.text = extractText(father.ordination,isDate: false);
    ordinationDateController.text = extractText(father.ordination,isDate: true);
    notifyListeners();
  }

  setBloodGroup(String blood){
    selectedBloodGroup=blood;
    notifyListeners();
  }
  setAge(TextEditingController controller){
    age=calculateAge(controller.text);
    notifyListeners();
  }
  setPickedDate(DateTime date,String label){
    if(label=="dob"){
      dobDate=date;
      notifyListeners();
    }else{
      ordinationDate=date;
      notifyListeners();
    }
  }
  void setVicar1(ChurchModel church){
    primaryVicarChurch=church;
    primaryVicarChurchName=church.churchName;
    notifyListeners();

  }
  void clearVicar1(){
    primaryVicarChurch=null;
    primaryVicarChurchName="";
    notifyListeners();

  }
  void setVicar2(ChurchModel church){
    secondaryVicarChurch=church;
    secondaryVicarChurchName=church.churchName;
    notifyListeners();

  }
  void clearVicar2(){
    secondaryVicarChurch=null;
    secondaryVicarChurchName="";
    notifyListeners();

  }
  void setMotherParish(ChurchModel church){
    motherParishChurch=church;
    motherParishChurchName=church.churchName;
    notifyListeners();

  }
  Map<String, dynamic> setNameData() {
    Map<String, dynamic> updateData = {};
    updateData["fatherName"] = fatherNameController.text;
    updateData["positions"] =
        positionControllerList.map((controller) => controller.text).join(", ");
    updateData["status"] = selectedStatus.id;
    if(selectedStatus.id==1) {
      if(primaryVicarChurch!=null){
        updateData["primaryAtId"] = primaryVicarChurch!.churchId;
      }
      updateData["primaryAt"] = primaryVicarChurchName;
      if(secondaryVicarChurch!=null){
        updateData["secondaryVicarAtId"] = secondaryVicarChurch!.churchId;
      }
      updateData["secondaryVicarAt"] = secondaryVicarChurchName;
    }else{
      updateData["primaryAt"] = "";
      updateData["primaryAtId"] = "";
      updateData["secondaryVicarAt"] ="";
      updateData["secondaryVicarAtId"]  ="";

    }
    return updateData;
  }

  Map<String, dynamic> setContactData() {
    Map<String, dynamic> updateData = {};
    updateData["secondaryNumber"] = secondaryPhoneController.text;
    updateData["emailId"] = emailController.text;
    return updateData;
  }

  Map<String, dynamic> setAddressData() {
    Map<String, dynamic> updateData = {};
    updateData["permanentAddress"] = permanentAddressController.text;
    updateData["presentAddress"] = presentAddressController.text;
    updateData["motherParish"] = motherParishChurchName;
    if(motherParishChurch!=null){
      updateData["motherParishId"] = motherParishChurch!.churchId;

    }
    return updateData;
  }

  Map<String, dynamic> setOtherData() {
    Map<String, dynamic> updateData = {};
    updateData["dob"] = dobDate.toString();
    updateData["bloodGroup"] = selectedBloodGroup;
    updateData["ordinationDate"] = ordinationDate.toString();
    updateData["ordinationBy"] =
        ordinationPriestController.text;
    return updateData;
  }

  Map<String, dynamic> setFatherData() {
    Map<String, dynamic> updateData = {};

    updateData["type"] = selectedClergyType;
    updateData["fatherName"] = fatherNameController.text;
    updateData["positions"] =
        positionControllerList.map((controller) => controller.text).join(", ");
    updateData["status"] = selectedStatus.id;

    if (selectedStatus.id == 1) {
      if (primaryVicarChurch != null) {
        updateData["primaryAtId"] = primaryVicarChurch!.churchId;
      }
      updateData["primaryAt"] = primaryVicarChurchName;
      if (secondaryVicarChurch != null) {
        updateData["secondaryVicarAtId"] = secondaryVicarChurch!.churchId;
      }
      updateData["secondaryVicarAt"] = secondaryVicarChurchName;
    } else {
      updateData["primaryAt"] = "";
      updateData["primaryAtId"] = "";
      updateData["secondaryVicarAt"] = "";
      updateData["secondaryVicarAtId"] = "";
    }

    // Contact Data
    updateData["phoneNumber"] = primaryPhoneController.text;
    updateData["secondaryNumber"] = secondaryPhoneController.text;
    updateData["emailId"] = emailController.text;

    // Address Data
    updateData["permanentAddress"] = permanentAddressController.text;
    updateData["presentAddress"] = presentAddressController.text;
    updateData["motherParish"] = motherParishChurchName;
    if (motherParishChurch != null) {
      updateData["motherParishId"] = motherParishChurch!.churchId;
    }

    // Other Data
    updateData["dob"] = dobDate.toString();
    updateData["bloodGroup"] = selectedBloodGroup;
    updateData["ordinationDate"] = ordinationDate.toString();
    updateData["ordinationBy"] = ordinationPriestController.text;

    return updateData;
  }

  Future<void> updateUserProfile(BuildContext context,Map<String, dynamic> updateData,UserModel father) async {
    String userid = father.userId;
    String type = father.type;
    Map<String, dynamic> clergyData={};
    Map<String, dynamic> primaryVicarData={};
    Map<String, dynamic> secondaryVicarData={};
    Map<String, dynamic> primaryVicarChurchData={};

    if(updateData["presentAddress"]!=null){
      clergyData["address"]=updateData["presentAddress"];
    }
    if(updateData["fatherName"]!=null){
      clergyData["fatherName"]=updateData["fatherName"];
    }
    if(updateData["primaryAt"]!=null){
      clergyData["vicarAt"]=updateData["primaryAt"];
    }

    await mRoot.child("users").child(userid).update(updateData);
    await mRoot.child("clergy").child(type).child(userid).update(clergyData);
    if(selectedStatus.id==1) {
      if(primaryVicarChurch!=null){
        primaryVicarData["primaryVicarId"] = userid;
        primaryVicarData["primaryVicar"] = fatherNameController.text;
        await mRoot.child("churchDetails").child(primaryVicarChurch!.churchId).update(primaryVicarData);
        await mRoot.child("church").child(primaryVicarChurch!.churchId).update(primaryVicarData);

      }else{
        if(father.primaryAtId!=""){
          String churchId=father.primaryAtId;
          await mRoot.child("churchDetails").child(churchId).update({
            "primaryVicar": "",
            "primaryVicarId": "",
            "primaryVicarPhone": "",
          });
          await mRoot.child("church").child(churchId).update({
            "primaryVicar": "",
            "primaryVicarId": "",
          });
        }

      }
      if(secondaryVicarChurch!=null){
        secondaryVicarData["assistantVicarId"] = userid;
        secondaryVicarData["assistantVicar"] =  fatherNameController.text;
        await mRoot.child("churchDetails").child(secondaryVicarChurch!.churchId).update(secondaryVicarData);
        await mRoot.child("church").child(secondaryVicarChurch!.churchId).update(secondaryVicarData);

      }else{
        if(father.secondaryVicarAtId!=""){
          String churchId=father.secondaryVicarAtId;
          await mRoot.child("churchDetails").child(churchId).update({
            "assistantVicar": "",
            "assistantVicarId": "",
            "assistantVicarPhone": "",
          });
          await mRoot.child("church").child(churchId).update({
            "assistantVicar": "",
            "assistantVicarId": "",
          });
        }
      }
    }else{
      await mRoot.child("users").child(userid).update({
        "primaryAt": "",
        "primaryAtId": "",
        "secondaryVicarAt": "",
        "secondaryVicarAtId": ""
      });
      await mRoot.child("clergy").child(type).child(userid).update({
        "vicarAt": "",
        "vicarAtId": "",
        "secondaryVicarAt": "",
        "secondaryVicarAtId": ""
      });
    }
    DatabaseEvent userEvent = await mRoot.child("users").child(userid).once();
    Map<dynamic, dynamic> userMap = userEvent.snapshot.value as Map;
    String formattedDob = formatDate(userMap['dob']);
    String formattedOrdination = formatDate(userMap['ordinationDate']);

    father = UserModel(
      userId: userid,
      fatherName: userMap['fatherName'] ?? '',
      type: userMap['type'] ?? '',
      primaryAt: userMap['primaryAt'] ?? '',
      primaryAtId: userMap['primaryAtId'] ?? '',
      secondaryVicarAt: userMap['secondaryVicarAt'] ?? '',
      secondaryVicarAtId: userMap['secondaryVicarAtId'] ?? '',
      phoneNumber: userMap['phoneNumber'] ?? '',
      secondaryNumber: userMap['secondaryNumber'] ?? '',
      dioceseSecretary: userMap['assistantAt'] ?? '',
      dioceseSecretaryId: userMap['assistantAtId'] ?? '',
      emailId: userMap['emailId'] ?? '',
      presentAddress: userMap['presentAddress'] ?? '',
      permanentAddress: userMap['permanentAddress'] ?? '',
      place: userMap['place'] ?? '',
      district: userMap['district'] ?? '',
      state: userMap['state'] ?? '',
      motherParish: userMap['motherParish'] ?? '',
      dob: formattedDob ?? '',
      bloodGroup: userMap['bloodGroup'] ?? '',
      ordination: "${userMap['ordinationBy'] ?? ''} on ${formattedOrdination ?? ''}",
      positions: userMap['positions'] ?? '',
      status: userMap['status'] ?? 0,
      image: userMap['image'] ?? '',
    );
    if(!kIsWeb){
      loginUser=father;
      notifyListeners();
    }
    notifyListeners();
    showToast("Updated successfully");
    finish(context);
  }
  Future<void> addUserProfile(BuildContext context, Map<String, dynamic> updateData) async {
    String userId = mRoot.push().key!;
    String phoneNumber = updateData["phoneNumber"]?.toString() ?? "";
    String type = updateData["type"]?.toString().toLowerCase() ?? "";

    if (type.isEmpty) {
      showToast("Please select father type");
      return;
    }

    // Build consistent user map
    Map<String, dynamic> userMap = {
      "userId": userId,
      "fatherName": updateData["fatherName"] ?? "",
      "type": type,
      "phoneNumber": phoneNumber,
      "secondaryNumber": updateData["secondaryNumber"] ?? "",
      "emailId": updateData["emailId"] ?? "",
      "presentAddress": updateData["presentAddress"] ?? "",
      "permanentAddress": updateData["permanentAddress"] ?? "",
      "dob": updateData["dob"] ?? "",
      "bloodGroup": updateData["bloodGroup"] ?? "",
      "ordinationDate": updateData["ordinationDate"] ?? "",
      "ordinationBy": updateData["ordinationBy"] ?? "",
      "positions": updateData["positions"] ?? "",
      "status": updateData["status"] ?? 1, // default status = 1 (active)
      "primaryAt": "",
      "primaryAtId": "",
      "secondaryVicarAt": "",
      "secondaryVicarAtId": ""
    };

    // Clergy node (basic info)
    Map<String, dynamic> clergyMap = {
      "fatherId": userId,
      "fatherName": updateData["fatherName"] ?? "",
      "phoneNumber": phoneNumber,
      "status": updateData["status"] ?? 1,
      "address": updateData["presentAddress"] ?? "",
      "type": type,
      "vicarAt": "",
      "vicarAtId": "",
      "secondaryVicarAt": "",
      "secondaryVicarAtId": ""
    };

    // Login info
    Map<String, dynamic> loginMap = {
      "userId": userId,
      "phoneNumber": phoneNumber,
    };

    // Firebase write operations
    try {
      await mRoot.child("logins").child(phoneNumber).set(loginMap);
      await mRoot.child("users").child(userId).set(userMap);
      await mRoot.child("clergy").child(type).child(userId).set(clergyMap);

      // Handle vicar assignments
      if (selectedStatus.id == 1) {
        if (primaryVicarChurch != null) {
          Map<String, dynamic> primaryVicarData = {
            "primaryVicarId": userId,
            "primaryVicar": updateData["fatherName"] ?? "",
          };
          await mRoot.child("churchDetails").child(primaryVicarChurch!.churchId).update(primaryVicarData);
          await mRoot.child("church").child(primaryVicarChurch!.churchId).update(primaryVicarData);
        }

        if (secondaryVicarChurch != null) {
          Map<String, dynamic> secondaryVicarData = {
            "assistantVicarId": userId,
            "assistantVicar": updateData["fatherName"] ?? "",
          };
          await mRoot.child("churchDetails").child(secondaryVicarChurch!.churchId).update(secondaryVicarData);
          await mRoot.child("church").child(secondaryVicarChurch!.churchId).update(secondaryVicarData);
        }
      }

      notifyListeners();
      showToast("Father added successfully");
      finish(context);
    } catch (e) {
      print("Error adding user: $e");
      showToast("Error adding father. Please try again.");
    }
  }
  Future<void> deleteUserProfile(String userId) async {
    print("fatherID:    "+userId);
    try {
      final userSnapshot = await mRoot.child("users").child(userId).once();
      final userData = userSnapshot.snapshot.value as Map?;

      if (userData == null) {
        showToast("User not found");
        return;
      }

      String phoneNumber = userData["phoneNumber"] ?? "";
      String type = userData["type"] ?? "";

      // Delete from /users
      await mRoot.child("users").child(userId).remove();

      // Delete from /logins
      if (phoneNumber.isNotEmpty) {
        await mRoot.child("logins").child(phoneNumber).remove();
      }

      // Delete from /clergy
      if (type.isNotEmpty) {
        await mRoot.child("clergy").child(type).child(userId).remove();
      }

      // Optional: clear church roles if needed
      await clearVicarFromChurchIfAssigned(userId);

      showToast("User deleted successfully");
      notifyListeners();
    } catch (e) {
      print("Error deleting user by userId: $e");
      showToast("Error deleting user");
    }
  }
  Future<void> clearVicarFromChurchIfAssigned(String userId) async {
    final churchesSnapshot = await mRoot.child("church").once();
    final churches = churchesSnapshot.snapshot.value as Map?;

    if (churches != null) {
      churches.forEach((churchId, data) async {
        final church = data as Map;

        if (church["primaryVicarId"] == userId) {
          await mRoot.child("church").child(churchId).update({
            "primaryVicar": "",
            "primaryVicarId": "",
          });
          await mRoot.child("churchDetails").child(churchId).update({
            "primaryVicar": "",
            "primaryVicarId": "",
          });
        }

        if (church["assistantVicarId"] == userId) {
          await mRoot.child("church").child(churchId).update({
            "assistantVicar": "",
            "assistantVicarId": "",
          });
          await mRoot.child("churchDetails").child(churchId).update({
            "assistantVicar": "",
            "assistantVicarId": "",
          });
        }
      });
    }
  }

}
