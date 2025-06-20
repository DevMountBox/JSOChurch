import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

Widget customNormalText({
  required String text,
  required Color color,
  required double fontSize,
  int maxLines = 10,
  TextOverflow overflow = TextOverflow.ellipsis,

  FontWeight fontWeight = FontWeight.normal,
}) {
  return Text(
    text,
    style: TextStyle(
      color: color,
      fontFamily: "Inter",
      fontSize: fontSize,
      fontWeight: fontWeight,
    ),
  );
}
Widget customNormalTextCentered({
  required String text,
  required Color color,
  required double fontSize,
  FontWeight fontWeight = FontWeight.normal,
  int maxLines = 10,
  TextOverflow overflow = TextOverflow.ellipsis,
}) {
  return Text(
    text,
  textAlign: TextAlign.center,
    maxLines: maxLines,
    overflow: overflow,
    style: TextStyle(
      color: color,
      fontFamily: "Inter",
      fontSize: fontSize,
      fontWeight: fontWeight,
    ),
  );
}
Widget customBoldText({
  required String text,
  required Color color,
  required double fontSize,
  FontWeight fontWeight = FontWeight.normal,
  int maxLines = 10,
  TextOverflow overflow = TextOverflow.ellipsis,

}) {
  return Text(
    text,
    maxLines: maxLines,
    overflow: overflow,
    style: TextStyle(
      color: color,
      fontFamily: "InterB",
      fontSize: fontSize,
      fontWeight: fontWeight,
    ),
  );
}
Widget customHyperlinkText({
  required String text,
  required Color color,
  required double fontSize,
  int maxLines = 10,
  TextOverflow overflow = TextOverflow.ellipsis,
  FontWeight fontWeight = FontWeight.normal,
}) {
  return GestureDetector(
    onTap: () async {
      final Uri url = Uri.parse(text);
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        debugPrint("Could not launch $text");
      }
    },
    child: Text(
      text,
      style: TextStyle(
        color: Colors.blue, // Hyperlink color
        decoration: TextDecoration.underline, // Underline for link effect
        fontSize: fontSize,
        fontWeight: fontWeight,
      ),
    ),
  );
}