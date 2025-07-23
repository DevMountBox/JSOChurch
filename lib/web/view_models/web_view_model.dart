import 'dart:collection';
import 'dart:io';
import 'dart:typed_data';
import 'package:crop_image/crop_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jsochurch/models/diocese_detail_model.dart';
import 'package:jsochurch/models/diocese_model.dart';
import 'package:jsochurch/models/user_model.dart';
import 'package:jsochurch/viewmodels/clergy_view_model.dart';
import 'package:path_provider/path_provider.dart';
import '../../models/church_detail_model.dart';
import '../../models/clergy_model.dart';
import '../../utils/globals.dart';
import '../../utils/my_functions.dart';
import '../../views/cropscreen.dart';
import 'dart:ui' as ui;

class WebViewModel extends ChangeNotifier {
  int currentPage = 0;
  final ImagePicker picker = ImagePicker();
  File? uploadedFile;
  Uint8List? fileBytes;
  Image? cropedImage;

  final controller = CropController(
    aspectRatio: 3/4,
    defaultCrop: const Rect.fromLTRB(0.1, 0.1, 0.9, 0.9),
  );

  ///diocese edit
  TextEditingController dioceseNameController = TextEditingController();
  GlobalKey<FormState> formDioceseName = GlobalKey<FormState>();
  TextEditingController dioceseMobileController = TextEditingController();
  GlobalKey<FormState> formDioceseMobile = GlobalKey<FormState>();
  TextEditingController dioceseWebsiteController = TextEditingController();
  TextEditingController dioceseAddressController = TextEditingController();
  GlobalKey<FormState> formDioceseAddress = GlobalKey<FormState>();
  TextEditingController diocesePrimaryController = TextEditingController();
  GlobalKey<FormState> formDiocesePrimary = GlobalKey<FormState>();
  TextEditingController dioceseSecondaryController = TextEditingController();
  GlobalKey<FormState> formDioceseSecondary = GlobalKey<FormState>();
  ClergyModel? selectedMetropolitan;
  ClergyModel? selectedAssistant;
  ///church edit
  TextEditingController churchNameController = TextEditingController();
  GlobalKey<FormState> formChurchName = GlobalKey<FormState>();
  TextEditingController churchMobileController = TextEditingController();
  GlobalKey<FormState> formChurchMobile = GlobalKey<FormState>();
  TextEditingController churchEmailController = TextEditingController();
  TextEditingController churchWebsiteController = TextEditingController();
  TextEditingController churchAddressController = TextEditingController();
  TextEditingController dioceseController = TextEditingController();
  GlobalKey<FormState> formChurchAddress = GlobalKey<FormState>();
  GlobalKey<FormState> formChurchDiocese = GlobalKey<FormState>();
  TextEditingController churchPrimaryController = TextEditingController();
  GlobalKey<FormState> formChurchPrimary = GlobalKey<FormState>();
  TextEditingController churchSecondaryController = TextEditingController();
  GlobalKey<FormState> formChurchSecondary = GlobalKey<FormState>();
  ClergyModel? selectedPrimary;
  ClergyModel? selectedSecondary;

  ClergyModel? previousPrimary;
  ClergyModel? previousSecondary;

  DioceseModel? selectedDiocese;
  String setChurchEditDioceseId="";

  TextEditingController newMobileNumber = TextEditingController();
  GlobalKey<FormState> formNewMobile = GlobalKey<FormState>();

  void selectDiocese(DioceseModel diocese){
    selectedDiocese=diocese;
    dioceseController.text=diocese.dioceseName;
    notifyListeners();
  }

  void selectPrimaryVicar(ClergyModel clergy){
    selectedPrimary=clergy;
    churchPrimaryController.text=clergy.fatherName;
    notifyListeners();
  }
  void selectSecondaryVicar(ClergyModel clergy){
    selectedSecondary=clergy;
    churchSecondaryController.text=clergy.fatherName;
    notifyListeners();
  }
  void selectDioceseMetropolitan(ClergyModel clergy){
    selectedMetropolitan=clergy;
    diocesePrimaryController.text=clergy.fatherName;
    notifyListeners();
  }
  void selectDioceseSecretary(ClergyModel clergy){
    selectedAssistant=clergy;
    dioceseSecondaryController.text=clergy.fatherName;
    notifyListeners();
  }

  void setDioceseEdit({required DioceseDetailModel diocese}) {
    dioceseNameController.text = diocese.dioceseName;
    dioceseMobileController.text = diocese.phoneNumber;
    dioceseWebsiteController.text = diocese.website;
    dioceseAddressController.text = diocese.address;
    diocesePrimaryController.text = diocese.dioceseMetropolitan;
    dioceseSecondaryController.text = diocese.dioceseSecretary;

    selectedMetropolitan = ClergyModel(
      fatherId: diocese.dioceseMetropolitanId,
      fatherName: diocese.dioceseMetropolitan,
      phoneNumber: diocese.dioceseMetropolitanPhone,
      type: "", // You can set the type accordingly
      vicarAt: "",
      address: "",
      image: "",
      status: 1,
      priority: 0
    );

    selectedAssistant = ClergyModel(
      fatherId: diocese.dioceseSecretaryId,
      fatherName: diocese.dioceseSecretary,
      phoneNumber: diocese.dioceseSecretaryPhone,
      type: "",
      vicarAt: "",
      address: "",
      image: "",
      status: 1,
      priority: 0
    );
  }
  void setChurchEdit(ClergyViewModel cv,{required ChurchDetailModel church}) {
    churchNameController.text = church.churchName;
    churchMobileController.text = church.phoneNumber;
    churchEmailController.text = church.emailId;
    churchWebsiteController.text = church.website;
    churchAddressController.text = church.address;
    dioceseController.text = church.diocese;
    churchPrimaryController.text = church.primaryVicar;
    churchSecondaryController.text = church.assistantVicar;
    setChurchEditDioceseId=church.dioceseId;
    selectedPrimary =church.primaryVicarId!=""? cv.clergyList.singleWhere((element) => element.fatherId==church.primaryVicarId):null;
    previousPrimary =church.primaryVicarId!=""? cv.clergyList.singleWhere((element) => element.fatherId==church.primaryVicarId):null;

    selectedSecondary =church.assistantVicarId!=""? cv.clergyList.singleWhere((element) => element.fatherId==church.assistantVicarId):null;
    previousSecondary =church.assistantVicarId!=""? cv.clergyList.singleWhere((element) => element.fatherId==church.assistantVicarId):null;
  }

  Future<void> updateDioceseDetails(BuildContext context,String dioceseId) async {
    if (dioceseId.isEmpty) return;

    final DatabaseReference mRoot = FirebaseDatabase.instance.ref();
    Map<String, dynamic> clergyData = {
      "vicarAt":dioceseNameController.text,
      "vicarAtId":dioceseId
    };
    Map<String, dynamic> userPrimaryData = {
      "primaryAt":dioceseNameController.text,
      "primaryAtId":dioceseId
    };
    Map<String, dynamic> userSecondaryData = {
      "assistantAt":dioceseNameController.text,
      "assistantAtId":dioceseId
    };
    Map<String, dynamic> dioceseData = {
      "dioceseName": dioceseNameController.text,
      "phoneNumber": dioceseMobileController.text,
      "dioceseMetropolitan": diocesePrimaryController.text,
      "address": dioceseAddressController.text,
    };
    Map<String, dynamic> dioceseDetailData = {
      "dioceseName": dioceseNameController.text,
      "phoneNumber": dioceseMobileController.text,
      "website": dioceseWebsiteController.text,
      "address": dioceseAddressController.text,
      "dioceseMetropolitan": diocesePrimaryController.text,
      "metropolitanPhone": selectedMetropolitan?.phoneNumber ?? "",
      "metropolitanId": selectedMetropolitan?.fatherId ?? "",
      "dioceseSecretary": dioceseSecondaryController.text,
      "secretaryPhone": selectedAssistant?.phoneNumber ?? "",
      "secretaryId": selectedAssistant?.fatherId ?? "",
    };

    try {
      await mRoot.child("dioceseDetails").child(dioceseId).update(dioceseDetailData);
      await mRoot.child("diocese").child(dioceseId).update(dioceseData);
      if(selectedMetropolitan!.type!=""){
        await mRoot.child("clergy").child(selectedMetropolitan!.type).child(selectedMetropolitan!.fatherId).update(clergyData);
        await mRoot.child("users").child(selectedMetropolitan!.fatherId).update(userPrimaryData);
      }
      if(selectedAssistant!.type!=""){
        await mRoot.child("clergy").child(selectedAssistant!.type).child(selectedAssistant!.fatherId).update(clergyData);
        await mRoot.child("users").child(selectedAssistant!.fatherId).update(userSecondaryData);
      }
      print("Diocese details updated successfully.");
    } catch (e) {
      print("Failed to update diocese details: $e");
    }
    finish(context);
  }

  Future<void> updateChurchDetails(BuildContext context,String churchId) async {
    if (churchId.isEmpty) return;


    // Construct the church detail data from controllers
    Map<String, dynamic> clergyData = {
      "vicarAt":churchNameController.text,
      "vicarAtId":churchId
    };
    Map<String, dynamic> userPrimaryData = {
      "primaryAt":churchNameController.text,
      "primaryAtId":churchId
    };
    Map<String, dynamic> userSecondaryData = {
      "secondaryVicarAt":churchNameController.text,
      "secondaryVicarAtId":churchId
    };

    Map<String, dynamic> churchData = {
      "primaryVicar": churchPrimaryController.text,
      "phoneNumber": churchMobileController.text,
      "churchName": churchNameController.text,
      "address": churchAddressController.text,
      "diocese": dioceseController.text,
      "dioceseId": selectedDiocese?.dioceseId??setChurchEditDioceseId,
    };
    Map<String, dynamic> churchDetailData = {
      "churchName": churchNameController.text,
      "phoneNumber": churchMobileController.text,
      "emailId": churchEmailController.text,
      "website": churchWebsiteController.text,
      "address": churchAddressController.text,
      "diocese": dioceseController.text,
      "dioceseId": selectedDiocese?.dioceseId??setChurchEditDioceseId,
      "primaryVicar": churchPrimaryController.text,
      "primaryVicarPhone": selectedPrimary?.phoneNumber ?? "",
      "primaryVicarId": selectedPrimary?.fatherId ?? "",
      "assistantVicar": churchSecondaryController.text,
      "assistantVicarPhone": selectedSecondary?.phoneNumber ?? "",
      "assistantVicarId": selectedSecondary?.fatherId ?? "",
    };

    try {
      await mRoot.child("churchDetails").child(churchId).update(churchDetailData);
      await mRoot.child("church").child(churchId).update(churchData);
      if(selectedPrimary!.type!=""){
        await mRoot.child("clergy").child(selectedPrimary!.type).child(selectedPrimary!.fatherId).update(clergyData);
        await mRoot.child("users").child(selectedPrimary!.fatherId).update(userPrimaryData);
      }
        if(previousPrimary!.type!="") {
          await mRoot.child("clergy").child(previousPrimary!.type).child(
              previousPrimary!.fatherId).update({
            "vicarAt":"",
            "vicarAtId":""
          });
          await mRoot.child("users").child(previousPrimary!.fatherId).update(
              {
                "primaryAt":"",
                "primaryAtId":""
              });
        }

      if(selectedSecondary!.type!=""){
        await mRoot.child("clergy").child(selectedSecondary!.type).child(selectedSecondary!.fatherId).update(clergyData);
        await mRoot.child("users").child(selectedSecondary!.fatherId).update(userSecondaryData);
      }
      if(previousSecondary!.type!="") {
          await mRoot.child("clergy").child(previousSecondary!.type).child(
              previousSecondary!.fatherId).update({
            "vicarAt":"",
            "vicarAtId":""
          });
          await mRoot.child("users").child(previousSecondary!.fatherId).update(
              {
                "secondaryVicarAt":"",
                "secondaryVicarAtId":""
              });
        }

      showToast("Church details updated successfully.");
      finish(context);
    } catch (e) {
      print("Failed to update church details: $e");
    }
  }
  changeNavPage(int index) {
    currentPage = index;
    notifyListeners();
  }
  bool _isImageFile(String filePath) {
    final imageExtensions = [
      'jpg',
      'jpeg',
      'png',
      'gif',
      'bmp'
    ];
    final extension = filePath.split('.').last.toLowerCase();
    return imageExtensions.contains(extension);
  }
  Future<void> getImage(BuildContext context, {required String from,UserModel? user,ChurchDetailModel? church,DioceseDetailModel? diocese}) async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);

    if (result != null && result.files.isNotEmpty) {
      final pickedFile = result.files.first;
      fileBytes = pickedFile.bytes;

      if (fileBytes != null) {
        var fileSize = fileBytes!.length / (1024 * 1024);
        if (fileSize < 5) {
          print("weoooooooooooooooooooooooooooorking");
          if(from=="father"){
            callNext(
              CropPage(
                title: "Crop Image",
                from: from,
                user: user,
              ),
              context,
            );
          }else if(from=="church"){
            print("church");
            callNext(
              CropPage(
                title: "Crop Image",
                from: "webChurch",
                churchDetail: church,
              ),
              context,
            );
          }else{
            print("diocese");

            callNext(
              CropPage(
                title: "Crop Image",
                from: "webDiocese",
                dioceseDetail: diocese,
              ),
              context,
            );
          }

        } else {
          showToast("The Size of Image Limited as 3 MB");
        }
      }
    } else {
      print('No image selected.');
    }
  }
  Future<void> retrieveLostData() async {
    final LostDataResponse response = await picker.retrieveLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      uploadedFile = File(response.file!.path);
      fileBytes = await uploadedFile!.readAsBytes();
      notifyListeners();
    }
  }

  String showStatus(int currentStatus) {
    String status = "";
    if (currentStatus == 1) {
      status = "Active";
    } else if (currentStatus == 2) {
      status = "Retired";
    } else if (currentStatus == 3) {
      status = "Unassigned";
    }
    return status;
  }

  Future<void> changePrimaryNumber(UserModel user) async {
    if(newMobileNumber.text.length==10) {
      String newMobileNo = newMobileNumber.text;
      String oldMobileNumber=user.phoneNumber;
      String userId=user.userId;
      String type=user.type;
      Map<String, dynamic> updateData={};

      updateData["phoneNumber"]=newMobileNo;
      updateData["userId"]=userId;
      await mRoot.child("logins").child(newMobileNo).update(updateData);
      await mRoot.child("logins").child(oldMobileNumber).remove();
      await mRoot.child("users").child(userId).child("phoneNumber").set(newMobileNo);
      await mRoot.child("clergy").child(type).child(userId).child("phoneNumber").set(newMobileNo);

      showToast("Mobile Number updated Successfully");

    }else{
      showToast("Please enter valid Mobile Number");
    }

  }

  clearNewNumber(){
    newMobileNumber.clear();
    notifyListeners();
  }
  Future<void> makeProfileImage(
      Image cropped, ui.Image bitmap, UserModel user) async {
    // Convert bitmap to bytes
    ByteData? byteData = await bitmap.toByteData(format: ui.ImageByteFormat.png);
    if (byteData == null) return;

    Uint8List fileBytes = byteData.buffer.asUint8List();
    String fileName = "${user.userId}.png"; // Use user ID for file name

    // Upload to Firebase Storage directly from memory (Uint8List)
    Reference storageRef =
    FirebaseStorage.instance.ref().child('profile_images/$fileName');

    UploadTask uploadTask = storageRef.putData(fileBytes);
    TaskSnapshot snapshot = await uploadTask;

    // Get the image URL
    String url = await snapshot.ref.getDownloadURL();

    // Update user image URL in database
    user.image = url;
    FirebaseDatabase.instance.ref("users/${user.userId}/image").set(url);
    FirebaseDatabase.instance.ref("clergy/${user.type}/${user.userId}/image").set(url);

    // Update UI
    cropedImage = cropped;
    notifyListeners();
  }
  Future<void> makeChurchImage(
      Image cropped, ui.Image bitmap, ChurchDetailModel church) async {
    // Convert bitmap to bytes
    ByteData? byteData = await bitmap.toByteData(format: ui.ImageByteFormat.png);
    if (byteData == null) return;

    Uint8List fileBytes = byteData.buffer.asUint8List();
    String fileName = "${church.churchId}.png"; // Use church ID for file name

    // Upload to Firebase Storage directly from memory (Uint8List)
    Reference storageRef =
    FirebaseStorage.instance.ref().child('profile_church_images/$fileName');

    UploadTask uploadTask = storageRef.putData(fileBytes);
    TaskSnapshot snapshot = await uploadTask;

    // Get the image URL
    String url = await snapshot.ref.getDownloadURL();

    // Update church image URL in database
    church.image = url;
    FirebaseDatabase.instance.ref("churchDetails/${church.churchId}/image").set(url);
    FirebaseDatabase.instance.ref("church/${church.churchId}/image").set(url);

    // Update UI
    cropedImage = cropped;
    notifyListeners();
  }
  Future<void> makeDioceseImage(
      Image cropped, ui.Image bitmap, DioceseDetailModel diocese) async {
    // Convert bitmap to bytes
    ByteData? byteData = await bitmap.toByteData(format: ui.ImageByteFormat.png);
    if (byteData == null) return;

    Uint8List fileBytes = byteData.buffer.asUint8List();
    String fileName = "${diocese.dioceseId}.png"; // Use diocese ID for file name

    // Upload to Firebase Storage directly from memory (Uint8List)
    Reference storageRef =
    FirebaseStorage.instance.ref().child('diocese_images/$fileName');

    UploadTask uploadTask = storageRef.putData(fileBytes);
    TaskSnapshot snapshot = await uploadTask;

    // Get the image URL
    String url = await snapshot.ref.getDownloadURL();

    // Update diocese image URL in database
    diocese.image = url;
    FirebaseDatabase.instance
        .ref("dioceseDetails/${diocese.dioceseId}/image")
        .set(url);
    FirebaseDatabase.instance
        .ref("diocese/${diocese.dioceseId}/image")
        .set(url);

    // Update UI
    cropedImage = cropped;
    notifyListeners();
  }
  Future<void> uploadDioceseToFirebase(List<dynamic> map, ClergyViewModel cv) async {
    List<String> otherDioceses = ["simhasanachurches", "eae", "missionpriests", "honnavar"];

    for (var a in map) {
      try {
        String dioceseName = (a["Diocese Name"] ?? "").toString().trim().toLowerCase().replaceAll(' ', '');
        String diocese = (a["Diocese Name"] ?? "").toString().trim();
        String dioceseMetropolitan = (a["Diocese Metropolitan"] ?? "").toString().trim();
        String dioceseSecretary = (a["Diocese Secretary"] ?? "").toString().trim();

        // Check if this diocese already exists in Firebase under dioceseDetails node
        DatabaseEvent event = await mRoot.child("dioceseDetails")
            .orderByChild('dioceseName')
            .equalTo(diocese)
            .once();

        if (event.snapshot.value != null) {
          print("Skipping upload: Diocese with name '$dioceseName' already exists.");
          continue;
        }

        bool fatherExists = cv.clergyList
            .any((clergy) => clergy.fatherName == dioceseMetropolitan) &&
            cv.clergyList.any((clergy) => clergy.fatherName == dioceseSecretary);

        if (!fatherExists) {
          print("Skipping upload: Metropolitan or Secretary not found for $dioceseName");
          continue;
        }

        bool primaryExists = dioceseMetropolitan.isEmpty ||
            cv.clergyList.any((clergy) => clergy.fatherName == dioceseMetropolitan);

        bool assistantExists = dioceseSecretary.isEmpty ||
            cv.clergyList.any((clergy) => clergy.fatherName == dioceseSecretary);

        if ((dioceseMetropolitan.isNotEmpty || dioceseSecretary.isNotEmpty) &&
            !(primaryExists && assistantExists)) {
          print('Skipping upload: Primary Vicar "$dioceseMetropolitan" or Assistant Vicar "$dioceseSecretary" not found in clergy list for church: ${a["Church Name"]}');
          continue;
        }

        HashMap<String, Object> metropolitanMap = HashMap();
        HashMap<String, Object> secretaryMap = HashMap();

        String metropolitanId = cv.clergyList
            .firstWhere((clergy) => clergy.fatherName == dioceseMetropolitan)
            .fatherId;
        String metropolitanPhone = cv.clergyList
            .firstWhere((clergy) => clergy.fatherName == dioceseMetropolitan)
            .phoneNumber;
        String metropolitanType = cv.clergyList
            .firstWhere((clergy) => clergy.fatherName == dioceseMetropolitan)
            .type;

        String secretaryPhone = cv.clergyList
            .firstWhere((clergy) => clergy.fatherName == dioceseSecretary)
            .phoneNumber;
        String secretaryId = cv.clergyList
            .firstWhere((clergy) => clergy.fatherName == dioceseSecretary)
            .fatherId;
        String secretaryType = cv.clergyList
            .firstWhere((clergy) => clergy.fatherName == dioceseSecretary)
            .type;

        String key = otherDioceses.contains(dioceseName)
            ? dioceseName
            : mRoot.push().key.toString();

        // Process and trim the region data
        String regionRaw = (a["Region"] ?? "").toString().trim();
        Map<String, bool> regionMap = {};

        RegExp forbiddenChars = RegExp(r'[.#$/\[\]]');

        regionRaw
            .split(',')
            .map((e) => e.trim()) // Trim extra spaces in region names
            .where((e) => e.isNotEmpty) // Remove empty entries
            .forEach((e) {
          String sanitizedRegion = e.replaceAll(forbiddenChars, '');
          if (sanitizedRegion.isNotEmpty) {
            regionMap[sanitizedRegion] = true;
          }
        });

        Map<String, Object> dioceseData = {
          "dioceseId": key,
          "dioceseName": a["Diocese Name"]?.toString().trim() ?? "",
          "phoneNumber": a["Phone Number"]?.toString().trim() ?? "",
          "dioceseMetropolitan": dioceseMetropolitan,
          "address": a["Address"]?.toString().trim() ?? "",
          "region": regionMap,
        };

        Map<String, Object> dioceseDetailData = {
          ...dioceseData,
          "website": a["Website"]?.toString().trim() ?? "",
          "metropolitanId": metropolitanId,
          "metropolitanPhone": metropolitanPhone,
          "secretaryId": secretaryId,
          "secretaryPhone": secretaryPhone,
          "dioceseSecretary": dioceseSecretary,
        };
        metropolitanMap["primaryAtId"] = key;
        metropolitanMap["primaryAt"] = a["Diocese Name"].toString().trim();
        metropolitanMap["isPrimary"] = true;
        secretaryMap["assistantAtId"] = key;
        secretaryMap["assistantAt"] = a["Diocese Name"].toString().trim();
        secretaryMap["isAssistant"] = true;

        print("Updating diocese data with key: $key, data: $dioceseData");
        print("Updating diocese detail data with key: $key, data: $dioceseDetailData");

        await Future.wait([
          mRoot.child("dioceseDetails").child(key).update(dioceseDetailData),
          mRoot.child("diocese").child(key).update(dioceseData),
        ]);
        if (metropolitanType != "") {
          await mRoot.child("users").child(metropolitanId).update(metropolitanMap);
          await mRoot.child("clergy").child(metropolitanType).child(metropolitanId).update(
              {"vicarAt": diocese});
        }
        if (secretaryType != "") {
          await mRoot.child("users").child(secretaryId).update(secretaryMap);
          await mRoot.child("clergy").child(secretaryType).child(secretaryId).update(
              {"vicarAt": diocese});
        }
        print("Diocese uploaded successfully");

      } catch (e) {
        print("Error uploading diocese data: $e");
      }
    }
  }

  Future<bool> doesFatherNameExist(String fatherName) async {
    DatabaseReference usersRef = FirebaseDatabase.instance.ref().child("users");

    Query query = usersRef.orderByChild("fatherName").equalTo(fatherName);
    DatabaseEvent event = await query.once();

    return event.snapshot.exists;
  }

  Future<void> uploadFatherToFirebase(List<dynamic> map, String clergy) async {
    List<String> availableClergy = [
      "metropolitans",
      "corepiscopa",
      "priest",
      "ramban",
      "deacons"
    ];

    for (var a in map) {
      try {
        String fatherName = a["Father Name"].toString();
        bool exists = await doesFatherNameExist(fatherName);

        if (exists) {
          print("Father Name '$fatherName' already exists. Skipping upload.");
          continue; // Skip this entry
        }

        HashMap<String, Object> clergyMap = HashMap();
        HashMap<String, Object> userMap = HashMap();
        HashMap<String, Object> loginMap = HashMap();

        String key = mRoot.push().key.toString();
        String type = clergy.toLowerCase();
        String phone = a["Phone Number"].toString();
        int status = _getStatusValue(a["Status"].toString());

        userMap["userId"] = key;
        userMap["fatherName"] = fatherName;
        userMap["type"] = type;
        userMap["phoneNumber"] = a["Phone Number"];
        userMap["secondaryNumber"] = a["Secondary Number"];
        userMap["emailId"] = a["Email Id"]??"";
        userMap["presentAddress"] = a["Present Address"]??"";
        userMap["permanentAddress"] = a["Permanent Address"];
        userMap["dob"] = a["DOB"]??"";
        userMap["bloodGroup"] = a["Blood Group"]??"";
        userMap["ordinationDate"] = a["Ordination Date"];
        userMap["ordinationBy"] = a["Ordination By Whom"];
        userMap["positions"] = a["Positions"];
        userMap["status"] = status;

        clergyMap["fatherId"] = key;
        clergyMap["fatherName"] = fatherName;
        clergyMap["phoneNumber"] = a["Phone Number"];
        clergyMap["status"] = status;
        clergyMap["address"] = a["Present Address"];
        // clergyMap["priority"] = a["Priority"];
        clergyMap["type"] = type;

        loginMap["userId"] = key;
        loginMap["phoneNumber"] = a["Phone Number"];

        if (availableClergy.contains(type)) {
          await mRoot.child("logins").child(phone).update(loginMap);
          await mRoot.child("users").child(key).update(userMap);
          await mRoot.child("clergy").child(type).child(key).update(clergyMap);
          print("Successfully uploaded: $fatherName");
        }
      } catch (e) {
        print(e);
        print('Error uploading data');
      }
    }
  }
  int _getStatusValue(String status) {
    switch (status.toLowerCase()) {
      case "active":
        return 1;
      case "retired":
        return 2;
      case "not assigned":
        return 3;
      default:
        return 0; // Default value for unknown statuses
    }
  }

  Future<void> uploadChurchesToFirebase(
      List<dynamic> map, List<DioceseModel> dioceseList, ClergyViewModel cv) async {
    for (var a in map) {
      try {
        String dioceseName = (a["Diocese"] ?? "").toString().trim();
        String churchName = (a["Church Name"] ?? "").toString().trim();
        String primaryVicar = (a["Primary Vicar"] ?? "").toString().trim();
        String assistantVicar = (a["Assistant Vicar"] ?? "").toString().trim();
        // Check if the church name already exists in the churchDetails node
        DatabaseEvent event = await mRoot.child("churchDetails")
            .orderByChild("churchName")
            .equalTo(churchName)
            .once();

        if (event.snapshot.exists) {
          print('Church "$churchName" already exists in churchDetails. Skipping upload.');
          continue;
        }

        bool dioceseExists =
        dioceseList.any((diocese) => diocese.dioceseName == dioceseName);
        String dioceseId = '';
        for (var diocese in dioceseList) {
          if (diocese.dioceseName == dioceseName) {
            dioceseId = diocese.dioceseId;
            break;
          }
        }

        if (!dioceseExists) {
          print(
              'Diocese "$dioceseName" does not exist in the diocese list. Skipping church upload.');
          continue;
        }


        bool primaryExists = primaryVicar.isEmpty ||
            cv.clergyList.any((clergy) => clergy.fatherName == primaryVicar);

        bool assistantExists = assistantVicar.isEmpty ||
            cv.clergyList.any((clergy) => clergy.fatherName == assistantVicar);

        if ((primaryVicar.isNotEmpty || assistantVicar.isNotEmpty) &&
            !(primaryExists && assistantExists)) {
          print('Skipping upload: Primary Vicar "$primaryVicar" or Assistant Vicar "$assistantVicar" not found in clergy list for church: ${a["Church Name"]}');
          continue;
        }

        String primaryVicarId = cv.clergyList
            .firstWhere((clergy) => clergy.fatherName == primaryVicar, orElse: () => ClergyModel.empty())
            .fatherId;
        String primaryVicarPhone = cv.clergyList
            .firstWhere((clergy) => clergy.fatherName == primaryVicar, orElse: () => ClergyModel.empty())
            .phoneNumber;

        String primaryVicarType = cv.clergyList
            .firstWhere((clergy) => clergy.fatherName == primaryVicar, orElse: () => ClergyModel.empty())
            .type;

        String assistantVicarId = cv.clergyList
            .firstWhere((clergy) => clergy.fatherName == assistantVicar, orElse: () => ClergyModel.empty())
            .fatherId;
        String assistantVicarPhone = cv.clergyList
            .firstWhere((clergy) => clergy.fatherName == assistantVicar, orElse: () => ClergyModel.empty())
            .phoneNumber;

        String assistantVicarType = cv.clergyList
            .firstWhere((clergy) => clergy.fatherName == assistantVicar, orElse: () => ClergyModel.empty())
            .type;

        HashMap<String, Object> churchDetailMap = HashMap();
        HashMap<String, Object> churchMap = HashMap();
        HashMap<String, Object> primaryVicarMap = HashMap();
        HashMap<String, Object> assistantVicarMap = HashMap();
        HashMap<String, Object> dioceseMap = HashMap();
        String key = mRoot.push().key.toString();

        dioceseMap["churchId"] = key;
        dioceseMap["churchName"] = churchName;

        churchMap["churchId"] = key;
        churchMap["churchName"] = churchName;
        churchMap["diocese"] = dioceseName;
        churchMap["dioceseId"] = dioceseId;
        churchMap["phoneNumber"] = (a["Phone Number"] ?? "").toString().trim();
        churchMap["address"] = (a["Address"] ?? "").toString().trim();
        churchMap["region"] = (a["Region"] ?? "").toString().trim();
        churchMap["primaryVicar"] = primaryVicar;

        churchDetailMap["churchId"] = key;
        churchDetailMap["churchName"] = churchName;
        churchDetailMap["dioceseId"] = dioceseId;
        churchDetailMap["diocese"] = dioceseName;
        churchDetailMap["phoneNumber"] = (a["Phone Number"] ?? "").toString().trim();
        churchDetailMap["emailId"] = (a["Email Id"] ?? "").toString().trim();
        churchDetailMap["website"] = (a["Website"] ?? "").toString().trim();
        churchDetailMap["address"] = (a["Address"] ?? "").toString().trim();
        churchDetailMap["region"] = (a["Region"] ?? "").toString().trim();
        churchDetailMap["primaryVicarId"] = primaryVicarId;
        churchDetailMap["primaryVicar"] = primaryVicar;
        churchDetailMap["primaryVicarPhone"] = primaryVicarPhone;
        churchDetailMap["assistantVicarId"] = assistantVicarId;
        churchDetailMap["assistantVicar"] = assistantVicar;
        churchDetailMap["assistantVicarPhone"] = assistantVicarPhone;

        primaryVicarMap["primaryAtId"] = key;
        primaryVicarMap["primaryAt"] = churchName;
        primaryVicarMap["isPrimary"] = true;
        assistantVicarMap["assistantAtId"] = key;
        assistantVicarMap["assistantAt"] = churchName;
        assistantVicarMap["isAssistant"] = true;

        await mRoot
            .child("diocese")
            .child(dioceseId)
            .child("churches")
            .child(key)
            .update(dioceseMap);

        await mRoot.child("churchDetails").child(key).update(churchDetailMap);

        await mRoot.child("church").child(key).update(churchMap);
        if (primaryVicarType != "") {
          await mRoot.child("clergy").child(primaryVicarType).child(primaryVicarId).update(
              {"vicarAt": churchName});
          await mRoot.child("users").child(primaryVicarId).update(primaryVicarMap);
        }
        if (assistantVicarType != "") {
          await mRoot.child("clergy").child(assistantVicarType).child(assistantVicarId).update(
              {"vicarAt": churchName});
          await mRoot.child("users").child(assistantVicarId).update(assistantVicarMap);
        }
      } catch (e) {
        print(e);
        print('Error uploading church data');
      }
    }
  }


  Future<void> uploadFirebase(List<dynamic> map) async {
    print(map.toString());
    for (var a in map) {
      try {
        HashMap<String, Object> dioceseMap = HashMap();
        String key = mRoot.push().key.toString();

        String imagePath = a["Image"];
        // String? newI  =await uploadImage(File(imagePath),"image");
        print("newI" + imagePath);
        // await mRoot
        //     .child("upload")
        //     .child("image")
        //     .update(dioceseMap);
      } catch (e) {
        print(e);
        print('Error uploading church data');
      }
    }
  }
}
