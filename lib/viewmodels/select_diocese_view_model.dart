import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:jsochurch/models/diocese_model.dart';

import '../utils/globals.dart';

class SelectDioceseViewModel extends ChangeNotifier {
  int selectedDioceseCat = 0;
  List<DioceseModel> dioceseList = [];
  List<DioceseModel> filteredDioceseList = [];
  Future<void> getDioceses() async {
    dioceseList = [];
    filteredDioceseList = [];
    notifyListeners();
    mRoot.child("diocese").onValue.listen((event) async {
      if (event.snapshot.exists) {
        dioceseList.clear();
        filteredDioceseList .clear();
        notifyListeners();
        Map<dynamic, dynamic> dioceseMap = event.snapshot.value as Map;

        for (var entry in dioceseMap.entries) {
          var key = entry.key;
          var value = entry.value;
            List<String> regionList=[];
            if(value["region"]!=null){
              Map<dynamic, dynamic> regionMap = value["region"] as Map;

              regionMap.forEach((key, value) {
                regionList.add(key.toString());
              });
            }
          int churchCount = await getChurchCount(value["dioceseId"]);
          DioceseModel dioceseModel = DioceseModel(
            dioceseId: value["dioceseId"],
            dioceseName: value["dioceseName"] ?? "",
            phoneNumber: value["phoneNumber"] ?? "",
            dioceseMetropolitan: value["dioceseMetropolitan"] ?? "",
            churchCount: churchCount.toString(),
            address: value["address"] ?? "",
            image: value["image"] ?? "",
            regions: regionList

          );
          dioceseList.add(dioceseModel);
          filteredDioceseList.add(dioceseModel);

        }

        dioceseList.sort((a, b) => a.dioceseName.compareTo(b.dioceseName));
        filteredDioceseList.sort((a, b) => a.dioceseName.compareTo(b.dioceseName));
        if (isSecretaryAdminLogin) {
          dioceseList = dioceseList.where((d) => d.dioceseId == secretaryDioceseIdAdmin).toList();
          filteredDioceseList = filteredDioceseList.where((d) => d.dioceseId == secretaryDioceseIdAdmin).toList();
        }
        notifyListeners();

      }

    });

  }
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
  void searchDiocese(String query) {
    filteredDioceseList = dioceseList.where((product) {
      final productLower = product.dioceseName.toLowerCase();
      final queryLower = query.toLowerCase();
      return productLower.contains(queryLower);
    }).toList();
    filteredDioceseList.sort((a, b) => a.dioceseName.compareTo(b.dioceseName));
    notifyListeners();
  }
}
