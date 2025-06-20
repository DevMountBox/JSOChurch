
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jsochurch/utils/globals.dart';
import 'package:jsochurch/web/view_models/edit_view_model.dart';
import 'package:provider/provider.dart';

import '../utils/my_colors.dart';

Widget textField(
    BuildContext context,
    String label,
    TextEditingController controller,
    GlobalKey<FormState> formKey,
    String validateString, {
      bool enabled = true,
    }) {
  return Form(
    key: formKey,
    child: SizedBox(
      child: TextFormField(
        controller: controller,
        enabled: enabled,
        style: const TextStyle(fontFamily: 'Inter', fontSize: 14, color: myBlack),
        textAlign: TextAlign.left,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          counterText: "",
          counterStyle: const TextStyle(fontSize: 0),
          labelText: label,
          hintStyle: const TextStyle(fontFamily: 'Inter', fontSize: 12, color: myGreyText),
          labelStyle: const TextStyle(fontFamily: 'Inter', fontSize: 12, color: myGreyText),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 10),
          border: greyBorder,
          enabledBorder: greyBorder,
          focusedBorder: greyBorder,
        ),
        validator: (text) => text == '' ? validateString : null,
      ),
    ),
  );
}


Widget dateField(BuildContext context,String label,
TextEditingController controller,
GlobalKey<FormState> formKey,
String validateString,DateTime date) {
  return Consumer<EditViewModel>(
    builder: (_,ev,__) {
      return GestureDetector(
        onTap: () async {
          DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1900), // Start date for selection
            lastDate: DateTime.now(), // End date for selection
          );

          if (pickedDate != null) {
            ev.setPickedDate(pickedDate,label);
            controller.text = DateFormat('dd-MM-yyyy').format(pickedDate);
          }
          if(label=="dob"){
            ev.setAge(controller);
          }
        },
        child: AbsorbPointer(
          child: textField(context, "", controller, formKey, validateString),
        ),
      );
    }
  );
}

final OutlineInputBorder whiteBorder = OutlineInputBorder(
  borderSide: BorderSide(color: myWhite.withOpacity(0.5), width: 1.0),
  borderRadius: BorderRadius.circular(8),
);
final OutlineInputBorder greyBorder = OutlineInputBorder(
  borderSide: BorderSide(color: myGreyText.withOpacity(0.2), width: 1.0),
  borderRadius: BorderRadius.circular(10),
);
