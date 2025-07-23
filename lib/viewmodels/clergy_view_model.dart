import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:jsochurch/models/clergy_model.dart';
import 'package:jsochurch/utils/my_functions.dart';

import '../utils/globals.dart';

class ClergyViewModel extends ChangeNotifier{
  List<ClergyModel> clergyList=[];
  List<ClergyModel> filteredClergyList=[];
  List<ClergyModel> clergyListByDiocese=[];
  List<ClergyModel> filteredClergyListByDiocese=[];
  int? tabIndex;
  int inputChipTag = 0;
  String clergy = "";
  List<String> availableClergy=["All","Metropolitans","Corepiscopa","Priest","Ramban","Deacons"];
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
  void searchClergyByDiocese(String query) {
    filteredClergyListByDiocese = clergyListByDiocese.where((church) {
      final fatherNameLower = church.fatherName.toLowerCase();
      final vicarAtLower = church.vicarAt.toLowerCase();
      final queryLower = query.toLowerCase();

      return fatherNameLower.contains(queryLower) ||
          vicarAtLower.contains(queryLower);
    }).toList();

    notifyListeners();
  }
  Future<void> getClergyListByDiocese(String dioceseId) async {
    clergyListByDiocese = [];
    filteredClergyListByDiocese = [];
    notifyListeners();

    // Step 1: Get all church IDs under the given diocese
    final churchesSnapshot = await mRoot
        .child("diocese")
        .child(dioceseId)
        .child("churches")
        .get();

    if (!churchesSnapshot.exists) return;

    final Set<String> churchIds = churchesSnapshot.children
        .map((e) => e.key!)
        .toSet();

    // Step 2: Get all users
    final usersSnapshot = await mRoot.child("users").get();
    if (!usersSnapshot.exists) return;

    // Step 3: Get clergy data
    final clergySnapshot = await mRoot.child("clergy").get();
    if (!clergySnapshot.exists) return;

    for (final user in usersSnapshot.children) {
      final data = user.value as Map<dynamic, dynamic>?;

      if (data == null) continue;

      final userId = user.key;
      final vicarAtId = data['vicarAtId']?.toString();
      final secondaryVicarAtId = data['secondaryVicarAtId']?.toString();
      final assistantId = data['assistantId']?.toString();
      final primaryId = data['primaryId']?.toString();

      final isChurchMatch = (vicarAtId != null && churchIds.contains(vicarAtId)) ||
          (secondaryVicarAtId != null && churchIds.contains(secondaryVicarAtId));

      final isDioceseMatch = (assistantId == dioceseId) || (primaryId == dioceseId);

      if (isChurchMatch || isDioceseMatch) {
        for (final typeNode in clergySnapshot.children) {
          final typeMap = typeNode.value as Map<dynamic, dynamic>;
          if (typeMap.containsKey(userId)) {
            final value = typeMap[userId];

            final clergyModel = ClergyModel(
              fatherId: value["fatherId"] ?? '',
              type: value["type"] ?? typeNode.key ?? '',
              fatherName: value["fatherName"] ?? '',
              vicarAt: value["vicarAt"]?.toString() ?? '',
              address: value["address"] ?? '',
              image: value["image"] ?? '',
              phoneNumber: value["phoneNumber"] ?? '',
              status: value["status"] ?? 0,
              priority: value["priority"] ?? 100,
            );

            clergyListByDiocese.add(clergyModel);
            filteredClergyListByDiocese.add(clergyModel);
            break;
          }
        }
      }
    }

    clergyListByDiocese.sort((a, b) => a.fatherName.compareTo(b.fatherName));
    filteredClergyListByDiocese.sort((a, b) => a.fatherName.compareTo(b.fatherName));

    notifyListeners();
  }
  Future<void> promoteDeaconToPriest(
      BuildContext context,
      BuildContext dialogContext,
      String userId,
      String ordinationBy,
      String ordinationDate,
      ) async {
    final DatabaseReference clergyRef = mRoot.child("clergy");
    final DatabaseReference userRef = mRoot.child("users").child(userId);

    // Get the deacon data from clergy
    final deaconSnapshot = await clergyRef.child("deacons").child(userId).get();
    if (!deaconSnapshot.exists) return;

    final deaconData = deaconSnapshot.value;

    // Move to priest node
    await clergyRef.child("priest").child(userId).set(deaconData);

    // Remove from deacon node
    await clergyRef.child("deacons").child(userId).remove();

    // Update user type and ordination details
    final userSnapshot = await userRef.get();
    if (userSnapshot.exists) {
      await userRef.update({
        "type": "priest",
        "ordinationBy": ordinationBy,
        "ordinationDate": ordinationDate,
      });
    }

    finish(dialogContext);
    finish(context);
  }
  Future<void> clearDobFromUser(String userId) async {
    final DatabaseReference userRef = mRoot.child("users").child(userId);

    try {
      await userRef.update({
        "dob": "",
      });
      print("✅ DOB cleared (set to empty string) for userId: $userId");
    } catch (e) {
      print("❌ Failed to clear DOB: $e");
    }
  }

}