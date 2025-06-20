import 'package:flutter/cupertino.dart';
import 'package:jsochurch/models/clergy_model.dart';

import '../utils/globals.dart';

class ClergyViewModel extends ChangeNotifier{
  List<ClergyModel> clergyList=[];
  List<ClergyModel> filteredClergyList=[];
  int? tabIndex;
  int inputChipTag = 0;
  String clergy = "";
  List<String> availableClergy=["All","Metropolitans","Corepiscopa","Priest","Ramban"];
  String clergyType="metropolitans";

  void setTabIndex(int tab){
    tabIndex=tab;
    notifyListeners();
  }
  void setClergyType(String tab){
    clergyType=tab;
    notifyListeners();
  }
  void changeChipType(int selected) {
    inputChipTag = selected;
    clergy = availableClergy[selected].toLowerCase();
    if(inputChipTag==0){
      getAllClergyList();
    }else{
      getClergyList(clergy);
    }
    notifyListeners();
  }

  void getClergyList(String type) {
    clergyList = [];
    filteredClergyList = [];
    notifyListeners();
    mRoot.child("clergy").child(type).onValue.listen((event) {
      if (event.snapshot.exists) {
        Map<dynamic, dynamic> fatherMap = event.snapshot.value as Map;

        clergyList.clear();
        filteredClergyList.clear();

        fatherMap.forEach((key, value) {
          ClergyModel clergyModel = ClergyModel(
            fatherId: value["fatherId"] ?? '',
            type: value["type"] ?? '',
            fatherName: value["fatherName"] ?? '',
            vicarAt: value["vicarAt"] ?? '',
            address: value["address"] ?? '',
            image: value["image"] ?? '',
            phoneNumber: value["phoneNumber"] ?? '',
            status: value["status"] ?? 0,
            priority: value["priority"] ?? 100,
          );
          clergyList.add(clergyModel);
          filteredClergyList.add(clergyModel);

          if(type!="metropolitans") {
            clergyList.sort((a, b) => a.fatherName.compareTo(b.fatherName));

            filteredClergyList.sort((a, b) =>
                a.fatherName.compareTo(b.fatherName));
          }else{
            clergyList.sort((a, b) => a.priority.compareTo(b.priority));
            filteredClergyList.sort((a, b) =>
                a.priority.compareTo(b.priority));

          }
        });

        notifyListeners();
      }
    });
  }
  void getAllClergyList() {
    mRoot.child("clergy").onValue.listen((event) {
      if (event.snapshot.exists) {
        clergyList.clear();
        filteredClergyList.clear();

        Map<dynamic, dynamic> clergyMap = event.snapshot.value as Map;

        clergyMap.forEach((key, value) {
          Map<dynamic, dynamic> fatherMap = value as Map;

          fatherMap.forEach((key, value) {
            ClergyModel churchModel = ClergyModel(
              fatherId: value["fatherId"] ?? '',
              type: value["type"] ?? '',
              fatherName: value["fatherName"] ?? '',
              vicarAt: value["vicarAt"] ?? '',
              address: value["address"] ?? '',
              image: value["image"] ?? '',
              phoneNumber: value["phoneNumber"] ?? '',
              status: value["status"] ?? 0,
              priority: value["priority"] ?? 0,
            );
            clergyList.add(churchModel);
            filteredClergyList.add(churchModel);
            clergyList.sort((a, b) => a.fatherName == "Not Assigned" ? -1 : b.fatherName == "Not Assigned" ? 1 : 0);
            filteredClergyList.sort((a, b) => a.fatherName == "Not Assigned" ? -1 : b.fatherName == "Not Assigned" ? 1 : 0);

          });
        });

        notifyListeners();
      }
    });
  }
  void searchClergy(String query) {
    filteredClergyList = clergyList.where((church) {
      final fatherNameLower = church.fatherName.toLowerCase();
      final vicarAtLower = church.vicarAt.toLowerCase();
      final queryLower = query.toLowerCase();

      return fatherNameLower.contains(queryLower) ||
          vicarAtLower.contains(queryLower);
    }).toList();

    notifyListeners();
  }

}