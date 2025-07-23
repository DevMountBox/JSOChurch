import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:jsochurch/models/other_church_dashboard_model.dart';
import 'package:jsochurch/models/user_model.dart';
import 'package:jsochurch/utils/globals.dart';
import 'package:jsochurch/utils/my_colors.dart';

import '../models/clergy_dashboard_model.dart';
import '../models/multi_diocese_model.dart';

class HomeViewModel extends ChangeNotifier {
  String father1 =
      "https://s3-alpha-sig.figma.com/img/fdfa/6a70/781e647e4e5d7982f17d666528b5ad6f?Expires=1736121600&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=L5jo9mdyee7z9ogrCFiYWDLrnwmmEg~ucQQ3px1~OMRWPZj8wuIMQVUgASc8~vkRksq1pVhpduCeKZu7eu8QkrplpA8Z~Y3s004Ci8t96ts4Aer30JPCpXK1HlE6GwVuJAmxWQs6hAiULu-2YzkxeAEExuInb~dFPjU57huhY355L7b1bbyAe-ANM9u9tw42XuaqWPFJwqJc8XjvDwQM1xrwYCWK5Q9GUBdUnD5l0jRUAbS0UkvuDxBmciUZJzNn0gc~Q1NP3S-LoSoktzdqvh9h3czTlHAAPY2urDyMxeVH01keURdBuse61X3LIlZYNtm4myaVDXulbsuFQi3c5w__";
  String father2 =
      "https://s3-alpha-sig.figma.com/img/b1e3/20d3/2f2a5bac345b38da3c3b814cc9fd2640?Expires=1736121600&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=TPC91lEogThXIsTtO2OWuAccg8cSMFTX4FArbQNX1J3YqLNAYg30pVIgNlekjadZhsNq1jvuIuD7YV5vQXMzuriHs0yznhvR-no6lVD0I7eIMwhNb8fYHfiHBpxIsfB0Nvnh1wcSZxqK-yWq3CFi8CbaJPzrSZiPaIboyfhvxJzrBafEi3YwMbhU~giRfdxwwmqRFcRF7cCXRLOiRKkK-C5QDh~oA~DrcV6KmaCCHyoeRkmzxi0Xg2d3SWq3~2o76QaySdbAW389SZFlxSTL7iNd1qtahFK2Y5AdPNOJIcPhvteFt~IOLDMZv9oSFEGv8Xvhyn~psLKg14UTsc3Tcw__";

  List<ClergyDashboardModal> clergyList = [
    ClergyDashboardModal(
        "Metropolitans", "5", "metropolitans", "metropolitans", myClergy1),
    ClergyDashboardModal("Priests", "5", "priest", "priest", myClergy2),
    ClergyDashboardModal(
        "Cor-episcopa", "5", "episcopa", "corepiscopa", myClergy3),
    ClergyDashboardModal("Ramban", "5", "ramban", "ramban", myClergy4),
    ClergyDashboardModal("Deacons", "5", "ramban", "deacons", myClergy5),
  ];

  List<OtherChurchDashboardModel> otherChurchList = [
    OtherChurchDashboardModel("Honnavar", "0","honnavar", myOtherChurch1),
    OtherChurchDashboardModel("EAE", "0","eae", myOtherChurch2),
    OtherChurchDashboardModel("Mission", "0","missionpriests", myOtherChurch3),
    OtherChurchDashboardModel("Simhsana", "0","simhasanachurches", myOtherChurch4),
  ];

  String dioceseCount = "0";
  List<UserModel> bigFathersList=[];
  String welcomeString() {
    String welcome = "";
    String fatherString = loginUser!.fatherName;
    String father = "${fatherString[0].toUpperCase()}${fatherString.substring(1)}";

    if (loginUser!.type.toLowerCase() == "metropolitans") {
      welcome = "Welcome His Grace\n$father";
    }else if(loginUser!.type.toLowerCase() == "corepiscopa"){
      welcome="Very.Rev. Cor Episcopa\n$father";
    } else if(loginUser!.type.toLowerCase() == "ramban"){
      welcome="Very. Rev. Ramban\n$father";
    } else {
      welcome = "Rev.Priest\n$father";
    }
    return welcome;
  }

  void updateOtherChurchCounts() {
    for (var diocese in otherChurchList) {
      final DatabaseReference dioceseRef =
          mRoot.child("diocese").child(diocese.getDataString).child("churches");

      dioceseRef.onValue.listen((event) {
        if (event.snapshot.exists) {
          final int count = event.snapshot.children.length;
          diocese.churchCount = count.toString();
          notifyListeners();
        } else {
          diocese.churchCount = '0';
          notifyListeners();
        }
      });
    }
  }

  void updateClergyCounts() {
    for (var clergy in clergyList) {
      final DatabaseReference clergyRef =
          mRoot.child("clergy").child(clergy.getDataString);

      clergyRef.onValue.listen((event) {
        if (event.snapshot.exists) {
          final int count = event.snapshot.children.length;
          clergy.churchCount = count.toString();
          notifyListeners();
        } else {
          clergy.churchCount = '0';
          notifyListeners();
        }
      });
    }
  }

  void updateDioceseCount() {
    final DatabaseReference dioceseRef = mRoot.child("diocese");

    dioceseRef.onValue.listen((event) {
      if (event.snapshot.exists) {
        final int count = event.snapshot.children.length;

        dioceseCount = count.toString();
        notifyListeners();
      } else {
        dioceseCount = "0";
        notifyListeners();
      }
    });
  }

  Future<void> getBigFathers() async {
    bigFathersList.clear();
    notifyListeners();
    mRoot.child("bigFathers").onValue.listen((event) async {
      if (event.snapshot.exists) {
        bigFathersList.clear();
        notifyListeners();
        Map<dynamic, dynamic> dioceseMap = event.snapshot.value as Map;

        for (var entry in dioceseMap.entries) {
          var key = entry.key;
          var userMap = entry.value;
          String formattedDob = formatDate(userMap['dob']);
          String formattedOrdination = formatDate(userMap['ordinationDate']);

          UserModel fatherDetailModel = UserModel(
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
          bigFathersList.add(fatherDetailModel);

        }
        bigFathersList.sort((a, b) => a.userId.compareTo(b.userId));

        notifyListeners();

      }
    print("bigFathersList:  ${bigFathersList.length}");
    });

  }

  Future<void> multiDioceseData() async {
    multiDioceseList.clear();
    notifyListeners();
    mRoot.child("multiDiocese").onValue.listen((event) async {
      if (event.snapshot.exists) {
        multiDioceseList.clear();
        notifyListeners();
        Map<dynamic, dynamic> dioceseMap = event.snapshot.value as Map;

        for (var entry in dioceseMap.entries) {
          var multiDioceseMap = entry.value;
          MultiDioceseModel dioceseModel=MultiDioceseModel(multiDioceseMap['dioceseName'], multiDioceseMap['dioceseId'], multiDioceseMap['dioceseMetropolitan'], multiDioceseMap['dioceseMetropolitanId'], multiDioceseMap['metropolitanNo']);
          multiDioceseList.add(dioceseModel);

        }

        notifyListeners();

      }
    });

  }



}
