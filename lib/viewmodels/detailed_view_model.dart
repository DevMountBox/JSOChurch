import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jsochurch/models/church_detail_model.dart';
import 'package:jsochurch/models/diocese_detail_model.dart';
import 'package:jsochurch/models/user_model.dart';

import '../models/multi_diocese_model.dart';
import '../utils/globals.dart';

class DetailedViewModel extends ChangeNotifier{
DioceseDetailModel? dioceseDetailModel;
ChurchDetailModel? churchDetailModel;
UserModel? fatherDetailModel;

UserModel? primaryVicar;
UserModel? secondaryVicar;
UserModel? secondDioceseMetropolitan;


final GlobalKey<ScaffoldState> scaffoldDiocese = GlobalKey<ScaffoldState>();
final GlobalKey<ScaffoldState> scaffoldChurch = GlobalKey<ScaffoldState>();
final GlobalKey<ScaffoldState> scaffoldFather = GlobalKey<ScaffoldState>();
Future<int> getChurchCount(String dioceseId) async {
  final DatabaseReference churchesRef = mRoot
      .child("diocese")
      .child(dioceseId)
      .child("churches");

  final DataSnapshot snapshot = await churchesRef.get();

  if (snapshot.exists) {
    return snapshot.children.length;
  } else {
    return 0;
  }
}
void getDioceseDetails(String dioceseId) {
  primaryVicar=null;
  secondaryVicar=null;
  secondDioceseMetropolitan=null;
  dioceseDetailModel=null;
  notifyListeners();
  mRoot.child("dioceseDetails").child(dioceseId).onValue.listen((event) async {
    if (event.snapshot.exists) {
      Map<dynamic, dynamic> dioceseMap = event.snapshot.value as Map;

      // Extracting the region keys into a list
      List<String> regionList = [];
      if (dioceseMap["region"] != null) {
        Map<dynamic, dynamic> regionMap = dioceseMap["region"];
        regionList = List<String>.from(regionMap.keys);
      }

      int churchCount = await getChurchCount(dioceseMap["dioceseId"]);

      dioceseDetailModel = DioceseDetailModel(
        dioceseId: dioceseMap["dioceseId"] ?? "",
        dioceseName: dioceseMap["dioceseName"] ?? "",
        region: regionList,
        phoneNumber: dioceseMap["phoneNumber"] ?? "",
        website: dioceseMap["website"] ?? "",
        noOfChurches: churchCount.toString(),
        address: dioceseMap["address"] ?? "",
        dioceseMetropolitan: dioceseMap["dioceseMetropolitan"] ?? "",
        dioceseMetropolitanPhone: dioceseMap["metropolitanPhone"] ?? "",
        dioceseMetropolitanId: dioceseMap["metropolitanId"] ?? "",
        dioceseSecretary: dioceseMap["dioceseSecretary"] ?? "",
        dioceseSecretaryPhone: dioceseMap["secretaryPhone"] ?? "",
        dioceseSecretaryId: dioceseMap["secretaryId"] ?? "",
        image: dioceseMap["image"] ?? "",
      );
      if(dioceseMap["metropolitanId"]!=null&&dioceseMap["metropolitanId"]!=""){
        primaryVicar=await getFatherDetailsIn(dioceseMap["metropolitanId"]);

      }
      if(dioceseMap["secretaryId"]!=null&&dioceseMap["secretaryId"]!=""){
        secondaryVicar=await getFatherDetailsIn(dioceseMap["secretaryId"]);

      }
      if (multiDioceseList.any((diocese) => diocese.dioceseId == dioceseId)){
        MultiDioceseModel matchingDiocese = multiDioceseList.firstWhere(
              (diocese) => diocese.dioceseId ==dioceseId,
        );
        secondDioceseMetropolitan=await getFatherDetailsIn(matchingDiocese.metropolitanId);
      }

        notifyListeners();
    }
  });
}
void getChurchDetails(String churchId) {
  primaryVicar=null;
  secondaryVicar=null;
  churchDetailModel=null;
  notifyListeners();
  mRoot.child("churchDetails").child(churchId).onValue.listen((event) async {
    if (event.snapshot.exists) {
      Map<dynamic, dynamic> churchMap = event.snapshot.value as Map;

      churchDetailModel = ChurchDetailModel(
        churchId: churchMap["churchId"] ?? '',
        churchName: churchMap["churchName"] ?? '',
        diocese: churchMap["diocese"] ?? '',
        dioceseId: churchMap["dioceseId"] ?? '',
        phoneNumber: churchMap["phoneNumber"] ?? '',
        emailId: churchMap["emailId"] ?? '',
        website: churchMap["website"] ?? '',
        address: churchMap["address"] ?? '',
        region: churchMap["region"] ?? '',
        primaryVicar: churchMap["primaryVicar"] ?? '',
        primaryVicarPhone: churchMap["primaryVicarPhone"] ?? '',
        primaryVicarId: churchMap["primaryVicarId"] ?? '',
        assistantVicar: churchMap["assistantVicar"] ?? '',
        assistantVicarPhone: churchMap["assistantVicarPhone"] ?? '',
        assistantVicarId: churchMap["assistantVicarId"] ?? '',
        image: churchMap["image"] ?? '',
      );
      if(churchMap["primaryVicarId"]!=null&&churchMap["primaryVicarId"]!=""){
        primaryVicar=await getFatherDetailsIn(churchMap["primaryVicarId"]);

      }
      if(churchMap["assistantVicarId"]!=null&&churchMap["assistantVicarId"]!=""){
        secondaryVicar=await getFatherDetailsIn(churchMap["assistantVicarId"]);
      }

      notifyListeners();
    }
  });
}
void getBigFatherDetails(UserModel bigFather){
  fatherDetailModel = bigFather;
  notifyListeners();

}
void getFatherDetails(String fatherId) {
  fatherDetailModel = null;

  mRoot.child("users").child(fatherId).onValue.listen((event) {
    if (event.snapshot.exists) {
      Map<dynamic, dynamic> userMap = event.snapshot.value as Map;
      String formattedDob = formatDate(userMap['dob']);
      String formattedOrdination = formatDate(userMap['ordinationDate']);

      fatherDetailModel = UserModel(
        userId: userMap['userId'] ?? '',
        fatherName: userMap['fatherName'] ?? '',
        type: userMap['type'] ?? '',
        primaryAt: userMap['primaryAt'] ?? '',
        primaryAtId: userMap['primaryAtId'] ?? '',
        secondaryVicarAt: userMap['secondaryVicarAt'] ?? '',
        secondaryVicarAtId: userMap['secondaryVicarAtId'] ?? '',
        dioceseSecretary: userMap['assistantAt'] ?? '',
        dioceseSecretaryId: userMap['assistantAtId'] ?? '',
        phoneNumber: userMap['phoneNumber'] ?? '',
        secondaryNumber: userMap['secondaryNumber'] ?? '',
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

      notifyListeners();
    }
  });
}
}