import 'package:flutter/material.dart';
import 'package:jsochurch/viewmodels/select_diocese_view_model.dart';
import 'package:provider/provider.dart';

import '../utils/my_colors.dart';

Widget searchBar({
  required BuildContext context,
  required String hintText,
  required Function(String) onChanged,
  IconData? prefixIcon = Icons.search_rounded,
  Color fillColor = myChipGrey,
  Color textColor = Colors.black,
  Color labelColor = Colors.grey,
  double height = 45.0,
}) {
  return Consumer<SelectDioceseViewModel>(builder: (_, sv, __) {
    return SizedBox(
      height: height,
      child: TextFormField(
        style: TextStyle(fontFamily: 'Inter', fontSize: 16, color: textColor),
        decoration: InputDecoration(
          prefixIcon: Icon(prefixIcon),
          hintText: hintText,
          labelStyle: TextStyle(fontFamily: 'Inter', color: labelColor.withOpacity(0.5)),
          filled: true,
          fillColor: fillColor,
          contentPadding: const EdgeInsets.symmetric(horizontal: 10),
          border: border,
          enabledBorder: border,
          focusedBorder: border,
        ),
        autofocus: false,
        enabled: true,
        onChanged: (item) {
          onChanged(item);
        },
      ),
    );
  });
}
OutlineInputBorder border = const OutlineInputBorder(
    borderSide: BorderSide(color: myChipGrey),
    borderRadius: BorderRadius.all(Radius.circular(60)));
