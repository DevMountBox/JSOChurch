import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jsochurch/models/church_model.dart';
import 'package:jsochurch/models/diocese_model.dart';

import '../utils/globals.dart';

class SelectChurchViewModel extends ChangeNotifier{
  List<ChurchModel> churchList=[];
  List<ChurchModel> filteredChurchList=[];
  List<DioceseModel> dioceseFilter=[];
  List<String> regionList = ["All"];
  DioceseModel? selectedDiocese;
  String? selectedRegion;
  void addToDioceseFilter(List<DioceseModel>diocesesList){
    dioceseFilter.clear();
    dioceseFilter.addAll(diocesesList);
    selectedDiocese=diocesesList[0];
    notifyListeners();
  }

  clearSelectedDiocese(){
    selectedDiocese=null;
    getChurches();
dioceseFilter.clear();
    notifyListeners();
  }

  bool isRegionAvailable(){
    bool isAvailable=false;
    regionList = ["All"];
    if(dioceseFilter.length==1){
      if(dioceseFilter[0].regions.isNotEmpty){
        regionList.addAll(dioceseFilter[0].regions);
        isAvailable=true;
      }
    }
    return isAvailable;
  }

  void clearDioceseFilter(){
    dioceseFilter.clear();
    notifyListeners();

  }
  void removeFromFilter(DioceseModel diocese){
    dioceseFilter.remove(diocese);
    filteredChurches();
    notifyListeners();

  }
  void toggleDioceseFilter(DioceseModel diocese) {
    if (dioceseFilter.contains(diocese)) {
      dioceseFilter.remove(diocese);
    } else {
      dioceseFilter.add(diocese);
    }
    notifyListeners();
  }

  bool dioceseFiltered(DioceseModel diocese){
    bool isFiltered=false;
    if(dioceseFilter.contains(diocese)){
      isFiltered=true;
    }else{
      isFiltered=false;
    }
    return isFiltered;
  }


  Future<void> getChurches() async {
    churchList = [];
    filteredChurchList = [];

    mRoot.child("church").onValue.listen((event) async {
      if (event.snapshot.exists) {
        churchList.clear();
        filteredChurchList.clear();

        Map<dynamic, dynamic> churchMap = event.snapshot.value as Map;

        for (var entry in churchMap.entries) {
          var value = entry.value;

          ChurchModel churchModel = ChurchModel(
            churchId: value["churchId"],
            churchName: value["churchName"] ?? "",
            address: value["address"] ?? "",
            phoneNumber: value["phoneNumber"] ?? "",
            image: value["image"] ?? "",
            primaryVicar: value["primaryVicar"] ?? "",
            diocese: value["diocese"] ?? "",
            dioceseId: value["dioceseId"] ?? "",
            region: value["region"] ?? "",
          );

          churchList.add(churchModel);
          filteredChurchList.add(churchModel);
        }

        // Optionally, sort the lists alphabetically by church name
        churchList.sort((a, b) => a.churchName.compareTo(b.churchName));
        filteredChurchList.sort((a, b) => a.churchName.compareTo(b.churchName));

        notifyListeners();
      }
    });
  }
  Future<void> filteredChurches() async {
    churchList = [];
    filteredChurchList = [];
    notifyListeners();
    await mRoot.child("church").once().then((event){
      if (event.snapshot.exists) {
        Map<dynamic, dynamic> dioceseMap = event.snapshot.value as Map;


        dioceseMap.forEach((key, value) {
          if(dioceseFilter.isNotEmpty){
          if(dioceseFilter.map((e) => e.dioceseId).contains(value["dioceseId"])) {
            ChurchModel churchModel = ChurchModel(
              churchId: value["churchId"],
              churchName: value["churchName"],
              address: value["address"],
              phoneNumber:value["phoneNumber"]??"" ,
              image: value["image"]??"",
              primaryVicar:value["primaryVicar"] ??"",
              diocese: value["diocese"],
              dioceseId: value["dioceseId"]??"",
              region: value["region"]??"",
            );
            churchList.add(churchModel);
            filteredChurchList.add(churchModel);
            churchList.sort((a, b) => a.churchName.trim().toLowerCase().compareTo(b.churchName.trim().toLowerCase()));
            filteredChurchList.sort((a, b) => a.churchName.trim().toLowerCase().compareTo(b.churchName.trim().toLowerCase()));

            notifyListeners();
            print(filteredChurchList.length.toString());

          }
          }else{
            ChurchModel churchModel = ChurchModel(
              churchId: value["churchId"],
              churchName: value["churchName"],
              address: value["address"],
              phoneNumber:value["phoneNumber"]??"" ,
              image: value["image"]??"",
              primaryVicar:value["primaryVicar"] ??"",
              diocese: value["diocese"],
              dioceseId: value["dioceseId"]??"",
              region: value["region"]??"",
            );
            churchList.add(churchModel);
            filteredChurchList.add(churchModel);
            filteredChurchList.sort((a, b) => a.churchName.compareTo(b.churchName));
            notifyListeners();
          }
        });

      }
    });

  }
  Future<void> otherChurches(String otherDiocese) async {
    churchList = [];
    filteredChurchList = [];
    await mRoot.child("church").once().then((event){
      if (event.snapshot.exists) {
        Map<dynamic, dynamic> dioceseMap = event.snapshot.value as Map;


        dioceseMap.forEach((key, value) {
          if(otherDiocese.toLowerCase()==(value["diocese"]).toString().toLowerCase()) {
            ChurchModel churchModel = ChurchModel(
              churchId: value["churchId"],
              churchName: value["churchName"],
              address: value["address"],
              phoneNumber:value["phoneNumber"]??"" ,
              image: value["image"]??"",
              primaryVicar:value["primaryVicar"] ??"",
              diocese: value["diocese"],
              dioceseId: value["dioceseId"]??"",
              region: value["region"]??"",
            );
            churchList.add(churchModel);
            filteredChurchList.add(churchModel);
            notifyListeners();

          }
        });

      }
    });

  }
  void searchChurch(String query) {
    filteredChurchList = churchList.where((church) {
      final churchNameLower = church.churchName.toLowerCase();
      final dioceseLower = church.diocese.toLowerCase();
      final queryLower = query.toLowerCase();

      return churchNameLower.contains(queryLower) ||
          dioceseLower.contains(queryLower);
    }).toList();
    filteredChurchList.sort((a, b) => a.churchName.compareTo(b.churchName));
    notifyListeners();
  }
  void filterByRegion(String query, String region) {
    selectedRegion=region;
    final queryLower = query.toLowerCase();
    final regionLower = region.toLowerCase();

    filteredChurchList = churchList.where((church) {
      final dioceseLower = church.diocese.toLowerCase();
      final churchRegionLower = church.region.toLowerCase();

      final matchesDiocese = dioceseLower.contains(queryLower);
      final matchesRegion = regionLower == "all" || churchRegionLower.contains(regionLower);

      return matchesDiocese && matchesRegion;
    }).toList();

    filteredChurchList.sort((a, b) => a.churchName.compareTo(b.churchName));

    notifyListeners();
  }

  clearRegion(){
    selectedRegion=null;
    filteredChurchList=churchList;
    notifyListeners();
  }

  clearBothDioceseAndRegion(){
    selectedRegion=null;
    selectedDiocese=null;

    notifyListeners();
    print("clear function donw");
  }
}