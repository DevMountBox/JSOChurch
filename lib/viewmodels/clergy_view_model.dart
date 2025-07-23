import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:jsochurch/models/clergy_model.dart';

import '../utils/globals.dart';

class ClergyViewModel extends ChangeNotifier{
  List<ClergyModel> clergyList=[];
  List<ClergyModel> filteredClergyList=[];
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
  Future<void> getClergyListByDiocese(String dioceseId) async {
    print("🔍 Fetching churches for dioceseId: $dioceseId");

    clergyList = [];
    filteredClergyList = [];
    notifyListeners();

    // Step 1: Get all church IDs under the given diocese
    final churchesSnapshot = await mRoot
        .child("diocese")
        .child(dioceseId)
        .child("churches")
        .get();

    if (!churchesSnapshot.exists) {
      print("⚠️ No churches found under this diocese.");
      return;
    }

    final Set<String> churchIds = churchesSnapshot.children
        .map((e) => e.key!)
        .toSet();

    print("🏛️ Churches found under diocese: $churchIds");

    // Step 2: Get all users
    final usersSnapshot = await mRoot.child("users").get();
    if (!usersSnapshot.exists) {
      print("⚠️ No users found.");
      return;
    }

    // Step 3: Get clergy data
    final clergySnapshot = await mRoot.child("clergy").get();
    if (!clergySnapshot.exists) {
      print("⚠️ No clergy data found.");
      return;
    }

    print("👤 Checking each user...");

    int matchedCount = 0;

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
        print("✅ Matched user: $userId");

        // Search in each type (subnode) under clergy
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

            clergyList.add(clergyModel);
            filteredClergyList.add(clergyModel);
            matchedCount++;

            print("📥 Added clergy: ${clergyModel.fatherName} (${clergyModel.fatherId})");
            break;
          }
        }
      } else {
        print("⛔ No match for user: $userId");
      }
    }

    // Sort alphabetically
    clergyList.sort((a, b) => a.fatherName.compareTo(b.fatherName));
    filteredClergyList.sort((a, b) => a.fatherName.compareTo(b.fatherName));

    print("🎯 Total clergy added: $matchedCount");
    notifyListeners();
  }
  Future<int> getFathersCountByDiocese(String dioceseId) async {
    print("🔍 Fetching churches for dioceseId: $dioceseId");

    // Step 1: Get all church IDs under the given diocese
    final churchesSnapshot = await mRoot
        .child("diocese")
        .child(dioceseId)
        .child("churches")
        .get();

    if (!churchesSnapshot.exists) {
      print("⚠️ No churches found under this diocese.");
      return 0;
    }

    final Set<String> churchIds = churchesSnapshot.children
        .map((e) => e.key!)
        .toSet();

    print("🏛️ Churches found under diocese: $churchIds");

    // Step 2: Get all users
    final usersSnapshot = await mRoot.child("users").get();
    if (!usersSnapshot.exists) {
      print("⚠️ No users found.");
      return 0;
    }

    int count = 0;

    print("👤 Checking each user...");

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
        print("✅ Matched user: $userId");
        print("   - vicarAtId: $vicarAtId");
        print("   - secondaryVicarAtId: $secondaryVicarAtId");
        print("   - assistantId: $assistantId");
        print("   - primaryId: $primaryId");

        count++;
      } else {
        print("⛔ No match for user: $userId");
      }
    }

    print("✅ Total matched fathers: $count");
    return count;
  }
  Future<void> promoteDeaconToPriest(String userId) async {
    final DatabaseReference clergyRef = mRoot.child("clergy");
    final DatabaseReference userRef = mRoot.child("users").child(userId);

    // Step 1: Get the deacon data from clergy
    final deaconSnapshot = await clergyRef.child("deacons").child(userId).get();

    if (!deaconSnapshot.exists) {
      print("❌ Deacon with ID $userId does not exist.");
      return;
    }

    final deaconData = deaconSnapshot.value;

    // Step 2: Move to priest node
    await clergyRef.child("priest").child(userId).set(deaconData);
    print("✅ Moved to priest node.");

    // Step 3: Remove from deacon node
    await clergyRef.child("deacons").child(userId).remove();
    print("🗑️ Removed from deacon node.");

    // Step 4: Update user type
    final userSnapshot = await userRef.get();
    if (userSnapshot.exists) {
      await userRef.update({
        "type": "priest",
      });
      print("🔁 User type updated to 'priest'.");
    } else {
      print("⚠️ User with ID $userId not found in users node.");
    }
  }

}