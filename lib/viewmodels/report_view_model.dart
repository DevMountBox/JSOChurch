// import 'dart:io';
// import 'dart:js_interop' as web;

import 'package:excel/excel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jsochurch/models/church_model.dart';
import 'package:jsochurch/models/clergy_model.dart';
import 'package:jsochurch/models/diocese_detail_model.dart';
import 'package:jsochurch/models/diocese_model.dart';
import 'package:jsochurch/models/user_model.dart';

import '../models/church_detail_model.dart';
import '../utils/globals.dart';
// import 'package:js/js_util.dart' as js_util;
// import 'package:web/web.dart' as web;
// import 'dart:typed_data';

class ReportViewModel extends ChangeNotifier {
  List<ChurchDetailModel> churchReportModelList = [];
  List<DioceseDetailModel> dioceseReportModelList = [];
  List<UserModel> fatherReportModelList = [];

  void getChurchDetails(List<ChurchModel> filteredChurches) {
    mRoot.child("churchDetails").onValue.listen((event) async {
      if (event.snapshot.exists) {
        Map<dynamic, dynamic> allChurchValue = event.snapshot.value as Map;

        for (var entry in allChurchValue.entries) {
          var key = entry.key;
          var value = entry.value;
          if (filteredChurches.map((e) => e.churchId).contains(key)) {
            ChurchDetailModel churchReportModel = ChurchDetailModel(
              churchId: value["churchId"] ?? '',
              churchName: value["churchName"] ?? '',
              diocese: value["diocese"] ?? '',
              dioceseId: value["dioceseId"] ?? '',
              phoneNumber: value["phoneNumber"] ?? '',
              emailId: value["emailId"] ?? '',
              website: value["website"] ?? '',
              address: value["address"] ?? '',
              region: value["region"] ?? '',
              primaryVicar: value["primaryVicar"] ?? '',
              primaryVicarPhone: value["primaryVicarPhone"] ?? '',
              primaryVicarId: value["primaryVicarId"] ?? '',
              assistantVicar: value["assistantVicar"] ?? '',
              assistantVicarPhone: value["assistantVicarPhone"] ?? '',
              assistantVicarId: value["assistantVicarId"] ?? '',
              image: value["image"] ?? '',
            );
            // if (value["primaryVicarId"] != null &&
            //     value["primaryVicarId"] != "") {
            //   value = await getFatherDetailsIn(value["primaryVicarId"]);
            // }
            // if (value["assistantVicarId"] != null &&
            //     value["assistantVicarId"] != "") {
            //   value = await getFatherDetailsIn(value["assistantVicarId"]);
            // }
            churchReportModelList.add(churchReportModel);
          }
        }
        notifyListeners();
      }
    });
  }

  void getDioceseDetails(List<DioceseModel> filteredDiocese) {
    mRoot.child("dioceseDetails").onValue.listen((event) async {
      if (event.snapshot.exists) {
        Map<dynamic, dynamic> allDioceseValue = event.snapshot.value as Map;

        for (var entry in allDioceseValue.entries) {
          var key = entry.key;
          var dioceseMap = entry.value;
          if (filteredDiocese.map((e) => e.dioceseId).contains(key)) {
            List<String> regionList = [];
        if (dioceseMap["region"] != null) {
          Map<dynamic, dynamic> regionMap = dioceseMap["region"];
          regionList = List<String>.from(regionMap.keys);
        }

        int churchCount = await getChurchCount(dioceseMap["dioceseId"]);

            DioceseDetailModel dioceseDetailModel = DioceseDetailModel(
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
        //
        // if(dioceseMap["metropolitanId"]!=null&&dioceseMap["metropolitanId"]!=""){
        //   primaryVicar=await getFatherDetailsIn(dioceseMap["metropolitanId"]);
        //
        // }
        // if(dioceseMap["secretaryId"]!=null&&dioceseMap["secretaryId"]!=""){
        //   secondaryVicar=await getFatherDetailsIn(dioceseMap["secretaryId"]);
        //
        // }
        // if (multiDioceseList.any((diocese) => diocese.dioceseId == dioceseId)){
        //   MultiDioceseModel matchingDiocese = multiDioceseList.firstWhere(
        //         (diocese) => diocese.dioceseId ==dioceseId,
        //   );
        //   secondDioceseMetropolitan=await getFatherDetailsIn(matchingDiocese.metropolitanId);
        // }
        dioceseReportModelList.add(dioceseDetailModel);
        notifyListeners();
      }
      }
      }
    });
  }

  void getFatherDetails(List<ClergyModel> filteredClergy) {

    mRoot.child("users").onValue.listen((event) {
      if (event.snapshot.exists) {
        Map<dynamic, dynamic> allUserValue = event.snapshot.value as Map;
        for (var entry in allUserValue.entries) {
          var key = entry.key;
          var userMap = entry.value;
          String formattedDob = formatDate(userMap['dob']);
          String formattedOrdination = formatDate(userMap['ordinationDate']);

          if (filteredClergy.map((e) => e.fatherId).contains(key)) {
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

        fatherReportModelList.add(fatherDetailModel);
        notifyListeners();
      }
      }
      }
    });
  }

  // void downloadChurchesToExcelWeb(
  //     BuildContext context, List<ChurchDetailModel> churches) async
  // {
  //   // Show loading dialog
  //   showDialog(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (_) => const AlertDialog(
  //       content: Row(
  //         children: [
  //           CircularProgressIndicator(),
  //           SizedBox(width: 20),
  //           Text("Please wait..."),
  //         ],
  //       ),
  //     ),
  //   );
  //
  //   try {
  //     // Create an Excel document
  //
  //     final excel = Excel.createExcel();
  //     excel.delete('Sheet1');
  //     final Sheet sheet = excel['Saved Churches'];
  //
  //     // Add headers
  //     sheet.appendRow([
  //       TextCellValue("Church Name"),
  //       TextCellValue("Diocese"),
  //       TextCellValue("Phone Number"),
  //       TextCellValue("Primary Vicar"),
  //       TextCellValue("Primary Vicar Number"),
  //       TextCellValue("Secondary Vicar"),
  //       TextCellValue("Secondary Vicar Number"),
  //       TextCellValue("Email ID"),
  //       TextCellValue("Website"),
  //       TextCellValue("Address")
  //     ]);
  //
  //     // Add data
  //     for (var branch in churches) {
  //       sheet.appendRow([
  //         TextCellValue(branch.churchName),
  //         TextCellValue(branch.diocese),
  //         TextCellValue(branch.phoneNumber),
  //         TextCellValue(branch.primaryVicar),
  //         TextCellValue(branch.primaryVicarPhone),
  //         TextCellValue(branch.assistantVicar),
  //         TextCellValue(branch.assistantVicarPhone),
  //         TextCellValue(branch.emailId),
  //         TextCellValue(branch.website),
  //         TextCellValue(branch.address),
  //       ]);
  //     }
  //
  //     // Encode to bytes
  //     final Uint8List bytes = Uint8List.fromList(excel.encode()!);
  //
  //     // Create a Blob and anchor element to trigger download
  //     final blob =
  //         web.Blob(js_util.jsify([bytes]) as web.JSArray<web.BlobPart>);
  //     final url = web.URL.createObjectURL(blob);
  //     final anchor = web.document.createElement('a') as web.HTMLAnchorElement;
  //     anchor.href = url;
  //     anchor.download = 'churchlist.xlsx';
  //     anchor.click();
  //     web.URL.revokeObjectURL(url); // Clean up
  //   } catch (e) {
  //     print("Error exporting excel: $e");
  //   } finally {
  //     Navigator.of(context).pop(); // Close loading dialog
  //   }
  // }
  //
  // void downloadDioceseToExcelWeb(
  //     BuildContext context, List<DioceseDetailModel> diocese) async
  // {
  //   // Show loading dialog
  //   showDialog(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (_) => const AlertDialog(
  //       content: Row(
  //         children: [
  //           CircularProgressIndicator(),
  //           SizedBox(width: 20),
  //           Text("Please wait..."),
  //         ],
  //       ),
  //     ),
  //   );
  //
  //   try {
  //     // Create an Excel document
  //     final excel = Excel.createExcel();
  //     // Get the default sheet and remove it
  //     excel.delete('Sheet1'); // Delete the default sheet
  //
  //     // Create a new sheet for saved diocese data
  //     final Sheet sheet = excel['Saved Diocese'];
  //
  //     // Add headers to the sheet
  //     sheet.appendRow([
  //       TextCellValue("Diocese Name"),
  //       TextCellValue("Phone Number"),
  //       TextCellValue("Diocese Metropolitan"),
  //       TextCellValue("Diocese Metropolitan Number"),
  //       TextCellValue("Diocese Secretary"),
  //       TextCellValue("Diocese Secretary Number"),
  //       TextCellValue("No of Churches"),
  //       TextCellValue("Website"),
  //       TextCellValue("Address")
  //     ]);
  //
  //     // Add diocese data to the sheet
  //     for (var branch in diocese) {
  //       sheet.appendRow([
  //         TextCellValue(branch.dioceseName),
  //         TextCellValue(branch.phoneNumber),
  //         TextCellValue(branch.dioceseMetropolitan),
  //         TextCellValue(branch.dioceseMetropolitanPhone),
  //         TextCellValue(branch.dioceseSecretary),
  //         TextCellValue(branch.dioceseSecretaryPhone),
  //         TextCellValue(branch.noOfChurches),
  //         TextCellValue(branch.website),
  //         TextCellValue(branch.address),
  //       ]);
  //     }
  //
  //     // Encode to bytes
  //     final Uint8List bytes = Uint8List.fromList(excel.encode()!);
  //
  //     // Create a Blob and anchor element to trigger download
  //     final blob =
  //         web.Blob(js_util.jsify([bytes]) as web.JSArray<web.BlobPart>);
  //     final url = web.URL.createObjectURL(blob);
  //     final anchor = web.document.createElement('a') as web.HTMLAnchorElement;
  //     anchor.href = url;
  //     anchor.download = 'dioceselist.xlsx';
  //     anchor.click();
  //     web.URL.revokeObjectURL(url); // Clean up
  //   } catch (e) {
  //     print("Error exporting excel: $e");
  //   } finally {
  //     Navigator.of(context).pop(); // Close loading dialog
  //   }
  // }
  //
  // void downloadClergyToExcelWeb(
  //     BuildContext context, List<UserModel> clergyList) async
  // {
  //   // Show loading dialog
  //   showDialog(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (_) => const AlertDialog(
  //       content: Row(
  //         children: [
  //           CircularProgressIndicator(),
  //           SizedBox(width: 20),
  //           Text("Please wait..."),
  //         ],
  //       ),
  //     ),
  //   );
  //
  //   try {
  //     // Create an Excel document
  //     final excel = Excel.createExcel();
  //     // Delete the default 'Sheet1'
  //     excel.delete('Sheet1'); // Delete the default sheet
  //
  //     // Create a new sheet for clergy data
  //     final Sheet sheet = excel['Saved Clergy'];
  //
  //     // Add headers to the sheet
  //     sheet.appendRow([
  //       TextCellValue("Father Name"),
  //       TextCellValue("Clergy Type"),
  //       TextCellValue("Primary Number"),
  //       TextCellValue("Secondary Number"),
  //       TextCellValue("Email ID"),
  //       TextCellValue("Primary Vicar at"),
  //       TextCellValue("Secondary Vicar at"),
  //       TextCellValue("Diocese Secretary at"),
  //       TextCellValue("Present Address"),
  //       TextCellValue("Permanent Address"),
  //       TextCellValue("DOB"),
  //       TextCellValue("Blood Group"),
  //       TextCellValue("Ordination"),
  //       TextCellValue("Mother Parish")
  //     ]);
  //
  //     // Add clergy data to the sheet
  //     for (var clergy in clergyList) {
  //       sheet.appendRow([
  //         TextCellValue(clergy.fatherName),
  //         TextCellValue(clergy.type),
  //         TextCellValue(clergy.phoneNumber),
  //         TextCellValue(clergy.secondaryNumber),
  //         TextCellValue(clergy.emailId),
  //         TextCellValue(clergy.primaryAt),
  //         TextCellValue(clergy.secondaryVicarAt),
  //         TextCellValue(clergy.dioceseSecretary),
  //         TextCellValue(clergy.presentAddress),
  //         TextCellValue(clergy.permanentAddress),
  //         TextCellValue(clergy.dob),
  //         TextCellValue(clergy.bloodGroup),
  //         TextCellValue(clergy.ordination),
  //         TextCellValue(clergy.motherParish),
  //       ]);
  //     }
  //
  //     // Encode to bytes
  //     final Uint8List bytes = Uint8List.fromList(excel.encode()!);
  //
  //     // Create a Blob and anchor element to trigger download
  //     final blob =
  //         web.Blob(js_util.jsify([bytes]) as web.JSArray<web.BlobPart>);
  //     final url = web.URL.createObjectURL(blob);
  //     final anchor = web.document.createElement('a') as web.HTMLAnchorElement;
  //     anchor.href = url;
  //     anchor.download = 'clergydatalist.xlsx';
  //     anchor.click();
  //     web.URL.revokeObjectURL(url); // Clean up
  //   } catch (e) {
  //     print("Error exporting excel: $e");
  //   } finally {
  //     Navigator.of(context).pop(); // Close loading dialog
  //   }
  // }

  //comment these line
  void downloadChurchesToExcelWeb(
      BuildContext context, List<ChurchDetailModel> churches) async
  {}
  void downloadDioceseToExcelWeb(
      BuildContext context, List<DioceseDetailModel> diocese) async
  {}
  void downloadClergyToExcelWeb(
      BuildContext context, List<UserModel> clergyList) async
  {}
}
