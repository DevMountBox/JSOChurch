import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'package:jsochurch/models/user_model.dart';

import '../models/appModel.dart';
import '../models/church_detail_model.dart';
import '../models/church_model.dart';
import '../models/diocese_detail_model.dart';
import '../models/multi_diocese_model.dart';

final DatabaseReference mRoot=FirebaseDatabase.instance.ref();
final FirebaseAuth auth = FirebaseAuth.instance;
UserModel? loginUser;
String father1="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT6nJUeUzxV7ajoS2ST8ZXP-6tQW6ktjO5fWg&s";
AppModel? appModel;
List<MultiDioceseModel> multiDioceseList=[];
bool isSecretaryAdminLogin=false;
String secretaryDioceseIdAdmin="";
int userTypeGlobal=0;
int fatherCountByDiocese=0;
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
Future<int> getFathersCountByDiocese(String dioceseId) async {
  // Step 1: Get all church IDs under the given diocese
  final churchesSnapshot = await mRoot
      .child("diocese")
      .child(dioceseId)
      .child("churches")
      .get();

  if (!churchesSnapshot.exists) return 0;

  final Set<String> churchIds =
  churchesSnapshot.children.map((e) => e.key!).toSet();

  // Step 2: Get all users
  final usersSnapshot = await mRoot.child("users").get();
  if (!usersSnapshot.exists) return 0;

  int count = 0;

  for (final user in usersSnapshot.children) {
    final data = user.value as Map<dynamic, dynamic>?;
    if (data == null) continue;

    final vicarAtId = data['vicarAtId']?.toString();
    final secondaryVicarAtId = data['secondaryVicarAtId']?.toString();
    final assistantId = data['assistantId']?.toString();
    final primaryId = data['primaryId']?.toString();

    final isChurchMatch = (vicarAtId != null && churchIds.contains(vicarAtId)) ||
        (secondaryVicarAtId != null && churchIds.contains(secondaryVicarAtId));

    final isDioceseMatch = (assistantId == dioceseId) || (primaryId == dioceseId);

    if (isChurchMatch || isDioceseMatch) {
      count++;
    }
  }

  return count;
}
Future<DioceseDetailModel?> getDioceseDetailsIn(String dioceseId) async {
  DatabaseEvent event = await mRoot.child("dioceseDetails").child(dioceseId).once();

  if (event.snapshot.exists) {
    Map<dynamic, dynamic> dioceseMap = event.snapshot.value as Map;

    List<String> regionList = [];
    if (dioceseMap["region"] != null) {
      Map<dynamic, dynamic> regionMap = dioceseMap["region"];
      regionList = List<String>.from(regionMap.keys);
    }

    int churchCount = await getChurchCount(dioceseMap["dioceseId"]);

    return DioceseDetailModel(
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
  }
  return null;
}
Future<ChurchModel?> getChurchById(String churchId) async {
  DataSnapshot snapshot = await mRoot.child("church").child(churchId).get();

  if (snapshot.exists) {
    Map<String, dynamic> churchData = Map<String, dynamic>.from(snapshot.value as Map);
    return ChurchModel.fromJson(churchData);
  }
  return null; // Return null if churchId doesn't exist
}
Future<ChurchDetailModel?> getChurchDetailsIn(String churchId) async {
  DatabaseEvent event = await mRoot.child("churchDetails").child(churchId).once();

  if (event.snapshot.exists) {
    Map<dynamic, dynamic> churchMap = event.snapshot.value as Map;

    return ChurchDetailModel(
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
  }
  return null;
}
String formatDate(dynamic date) {
  if (date != null && date.toString().isNotEmpty) {
    try {
      return DateFormat('dd-MM-yyyy').format(DateTime.parse(date.toString()));
    } catch (e) {
      return "";
    }
  }
  return "";
}

Future<UserModel?> getFatherDetailsIn(String fatherId) async {
  DatabaseEvent event = await mRoot.child("users").child(fatherId).once();

  if (event.snapshot.exists) {
    Map<dynamic, dynamic> userMap = event.snapshot.value as Map;
    String formattedDob = formatDate(userMap['dob']);
    String formattedOrdination = formatDate(userMap['ordinationDate']);
    return UserModel(
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
  }
  return null;
}
String extractText(String? input, {required bool isDate}) {
  if (input == null || input.isEmpty) {
    return "";
  }
  if(isDate){
    return input.split(" on ").last;

  }else{
    return input.split(" on ").first;

  }
}

String calculateAge(String dob) {
  try {
    // Parse the input date string
    DateTime birthDate = DateFormat('dd-MM-yyyy').parse(dob);
    DateTime today = DateTime.now();

    // Calculate age
    int age = today.year - birthDate.year;

    // Adjust if birthday hasn't occurred this year yet
    if (today.month < birthDate.month ||
        (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }

    return "$age years";
  } catch (e) {
    return "Invalid date";
  }
}