import 'dart:convert';
import 'dart:io';
 import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';




var appBarHeight = AppBar().preferredSize.height;

callNext(var className, var context) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => className),
  );
}
callNextReplacement(var className, var context){
  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => className),
  );
}

back(var context) {
  Navigator.pop(context);
}
void finish(context) {
  Navigator.pop(context);
}
void hideKeyboard(context) {
  FocusScope.of(context).requestFocus(FocusNode());
}
Color hexStringToHexInt(String hex) {
  hex = hex.replaceFirst('#', '');
  hex = hex.length == 6 ? 'ff' + hex : hex;
  int val = int.parse(hex, radix: 16);
  return Color(val);
}
Color colorFromHex(String hexColor) {
  final hexCode = hexColor.replaceAll('#', '');
  return Color(int.parse('FF$hexCode', radix: 16));
}

// final otpInputDecoration = InputDecoration(
//   contentPadding:
//   EdgeInsets.symmetric(vertical: getProportionateScreenWidth(15)),
//   border: outlineInputBorder(),
//   focusedBorder: outlineInputBorder(),
//   enabledBorder: outlineInputBorder(),
// );

// OutlineInputBorder customEnabledBorder=  const OutlineInputBorder(
//   borderRadius: BorderRadius.all(Radius.circular(8.0)),
//   borderSide: BorderSide(color:  mynew_darkgrey, width: 1.2),
// );
// OutlineInputBorder customFocusedBorder=  OutlineInputBorder(
//   borderRadius: BorderRadius.all(Radius.circular(8.0)),
//   borderSide: BorderSide(color:  mynew_darkviolet, width: 1.6),
// );
void showToast(String toast) {
  Fluttertoast.showToast(
      msg: toast,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.grey,
      textColor: Colors.black,
      fontSize: 14.0);
}
String masked(String source, String maskValue, int start, int count) {
  var firstPart = source.substring(0, start);
  var lastPart = source.substring(start + count);
  StringBuffer buffer = StringBuffer();
  for (int i = 0; i < count; i++) {
    buffer.write(maskValue);
  }
  var middlePart = buffer.toString();
  return firstPart + middlePart + lastPart;
}
Future<void> launchURL(String url) async {
  try {
    Uri uri = Uri.parse(url);

    if (uri.scheme == 'tel') {
      // Handle phone call URL (tel:)
      if (!await launchUrl(uri)) throw 'Could not launch phone call $url';
    } else if (uri.scheme == 'mailto') {
      // Handle email URL (mailto:)
      if (!await launchUrl(uri)) throw 'Could not launch email $url';
    } else if (uri.scheme == 'http' || uri.scheme == 'https') {
      // Handle HTTP/HTTPS URL
      if (!await launchUrl(uri)) throw 'Could not launch website $url';
    } else {
      // Handle any other URL scheme
      if (!await launchUrl(uri)) throw 'Could not launch $url';
    }
  } catch (e) {
    print('Error launching URL: $e');
  }


}
Future<String> uploadImage(File imageFile,fileLocation) async {
  try {
    String fileName = imageFile.path.split('/').last;
    Reference ref = FirebaseStorage.instance.ref().child('$fileLocation/$fileName');
    await ref.putFile(imageFile);
    return await ref.getDownloadURL();
  } catch (e) {
    throw Exception('Failed to upload image: $e');
  }
}