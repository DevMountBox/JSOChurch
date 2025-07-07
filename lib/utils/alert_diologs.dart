import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jsochurch/models/church_detail_model.dart';
import 'package:jsochurch/models/diocese_detail_model.dart';
import 'package:jsochurch/models/user_model.dart';
import 'package:jsochurch/utils/my_functions.dart';
import 'package:jsochurch/viewmodels/login_view_model.dart';
import 'package:jsochurch/viewmodels/profile_view_model.dart';
import 'package:jsochurch/viewmodels/select_parish_detail_view_model.dart';
import 'package:jsochurch/views/nav_bar.dart';
import 'package:jsochurch/web/view_models/edit_view_model.dart';
import 'package:jsochurch/web/view_models/web_view_model.dart';
import 'package:jsochurch/web/web_login_view.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:provider/provider.dart';

import '../views/edit_father_view.dart';
import '../views/login_view.dart';
import '../widgets/text_fields.dart';
import '../widgets/text_widget.dart';
import 'forms.dart';
import 'globals.dart';
import 'my_colors.dart';

void logoutDialog(BuildContext context, String text, String title) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(6.0)),
        ),
        backgroundColor: Colors.white,
        content: SizedBox(
          width: 400,
          child: IntrinsicHeight(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.black,
                    fontFamily: "Roboto",
                    fontSize: 20,
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Text(
                        text,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.black,
                          fontFamily: "Roboto",
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: InkWell(
                        borderRadius:
                        const BorderRadius.all(Radius.circular(8)),
                        onTap: () {
                          Navigator.of(dialogContext).pop(); // Close the dialog
                        },
                        child: Container(
                          margin: const EdgeInsets.all(10),
                          height: 40,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                            const BorderRadius.all(Radius.circular(8)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                spreadRadius: 2,
                                blurRadius: 1,
                                offset: const Offset(0.5, 0.7),
                              ),
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                spreadRadius: 3,
                                blurRadius: 1,
                                offset: const Offset(0.5, 0.7),
                              ),
                            ],
                          ),
                          child: const Text(
                            "No",
                            style: TextStyle(
                              color: buttonBlue,
                              fontFamily: "Roboto",
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Consumer<LoginViewModel>(
                          builder: (_,lv,__) {
                            return InkWell(
                              borderRadius:
                              const BorderRadius.all(Radius.circular(8)),
                              onTap: () {
                                auth.signOut();
                                lv.clearSharedPreference();
                                Navigator.of(dialogContext).pop();
                                if(!kIsWeb){
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const LoginView(),
                                    ),
                                        (route) => false, // Removes all previous routes
                                  );}else{
                                  callNextReplacement(WebLoginView(), context);
                                }
                              },
                              child: Container(
                                margin: const EdgeInsets.all(10),
                                height: 40,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: buttonBlue,
                                  borderRadius:
                                  const BorderRadius.all(Radius.circular(8)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      spreadRadius: 2,
                                      blurRadius: 1,
                                      offset: const Offset(0.5, 0.7),
                                    ),
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      spreadRadius: 3,
                                      blurRadius: 1,
                                      offset: const Offset(0.5, 0.7),
                                    ),
                                  ],
                                ),
                                child: const Text(
                                  "Yes",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: "Roboto",
                                      fontSize: 18),
                                ),
                              ),
                            );
                          }
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
void deleteDialog(BuildContext context, String text, String title,String userId) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(6.0)),
        ),
        backgroundColor: Colors.white,
        content: SizedBox(
          width: 400,
          child: IntrinsicHeight(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.black,
                    fontFamily: "Roboto",
                    fontSize: 20,
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Text(
                        text,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.black,
                          fontFamily: "Roboto",
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: InkWell(
                        borderRadius:
                        const BorderRadius.all(Radius.circular(8)),
                        onTap: () {
                          Navigator.of(dialogContext).pop(); // Close the dialog
                        },
                        child: Container(
                          margin: const EdgeInsets.all(10),
                          height: 40,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                            const BorderRadius.all(Radius.circular(8)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                spreadRadius: 2,
                                blurRadius: 1,
                                offset: const Offset(0.5, 0.7),
                              ),
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                spreadRadius: 3,
                                blurRadius: 1,
                                offset: const Offset(0.5, 0.7),
                              ),
                            ],
                          ),
                          child: const Text(
                            "No",
                            style: TextStyle(
                              color: buttonBlue,
                              fontFamily: "Roboto",
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Consumer<EditViewModel>(
                          builder: (_,ev,__) {
                            return InkWell(
                              borderRadius:
                              const BorderRadius.all(Radius.circular(8)),
                              onTap: () {
                               ev.deleteUserProfile(userId);
                               finish(context);
                              },
                              child: Container(
                                margin: const EdgeInsets.all(10),
                                height: 40,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: buttonBlue,
                                  borderRadius:
                                  const BorderRadius.all(Radius.circular(8)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      spreadRadius: 2,
                                      blurRadius: 1,
                                      offset: const Offset(0.5, 0.7),
                                    ),
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      spreadRadius: 3,
                                      blurRadius: 1,
                                      offset: const Offset(0.5, 0.7),
                                    ),
                                  ],
                                ),
                                child: const Text(
                                  "Yes",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: "Roboto",
                                      fontSize: 18),
                                ),
                              ),
                            );
                          }
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
void selectWorkingParish(BuildContext context, String text, String title) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(6.0)),
        ),
        backgroundColor: Colors.white,
        content: SizedBox(
          width: 400,
          child: IntrinsicHeight(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.black,
                    fontFamily: "Roboto",
                    fontSize: 20,
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Text(
                        text,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.black,
                          fontFamily: "Roboto",
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: InkWell(
                        borderRadius:
                        const BorderRadius.all(Radius.circular(8)),
                        onTap: () {
                          Navigator.of(dialogContext).pop(); // Close the dialog
                        },
                        child: Container(
                          margin: const EdgeInsets.all(10),
                          height: 40,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                            const BorderRadius.all(Radius.circular(8)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                spreadRadius: 2,
                                blurRadius: 1,
                                offset: const Offset(0.5, 0.7),
                              ),
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                spreadRadius: 3,
                                blurRadius: 1,
                                offset: const Offset(0.5, 0.7),
                              ),
                            ],
                          ),
                          child: const Text(
                            "No",
                            style: TextStyle(
                              color: buttonBlue,
                              fontFamily: "Roboto",
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Consumer<SelectParishDetailViewModel>(
                          builder: (_,pv,__) {
                            return InkWell(
                              borderRadius:
                              const BorderRadius.all(Radius.circular(8)),
                              onTap: () {
                                pv.updateWorkingParish();
                                Navigator.of(dialogContext).pop();
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(builder: (context) => const NavbarView()),
                                      (Route<dynamic> route) => false,
                                );
                              },
                              child: Container(
                                margin: const EdgeInsets.all(10),
                                height: 40,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: buttonBlue,
                                  borderRadius:
                                  const BorderRadius.all(Radius.circular(8)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      spreadRadius: 2,
                                      blurRadius: 1,
                                      offset: const Offset(0.5, 0.7),
                                    ),
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      spreadRadius: 3,
                                      blurRadius: 1,
                                      offset: const Offset(0.5, 0.7),
                                    ),
                                  ],
                                ),
                                child: const Text(
                                  "Yes",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: "Roboto",
                                      fontSize: 18),
                                ),
                              ),
                            );
                          }
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
void updateProfileAlert(BuildContext context, String text, String title, Map<String, dynamic> updateData,UserModel father) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(6.0)),
        ),
        backgroundColor: Colors.white,
        content: SizedBox(
          width: 400,
          child: IntrinsicHeight(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.black,
                    fontFamily: "Roboto",
                    fontSize: 20,
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Text(
                        text,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.black,
                          fontFamily: "Roboto",
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: InkWell(
                        borderRadius:
                        const BorderRadius.all(Radius.circular(8)),
                        onTap: () {
                          Navigator.of(dialogContext).pop(); // Close the dialog
                        },
                        child: Container(
                          margin: const EdgeInsets.all(10),
                          height: 40,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                            const BorderRadius.all(Radius.circular(8)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                spreadRadius: 2,
                                blurRadius: 1,
                                offset: const Offset(0.5, 0.7),
                              ),
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                spreadRadius: 3,
                                blurRadius: 1,
                                offset: const Offset(0.5, 0.7),
                              ),
                            ],
                          ),
                          child: const Text(
                            "No",
                            style: TextStyle(
                              color: buttonBlue,
                              fontFamily: "Roboto",
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Consumer<EditViewModel>(
                          builder: (_,ev,__) {
                            return InkWell(
                              borderRadius:
                              const BorderRadius.all(Radius.circular(8)),
                              onTap: () {
                                ev.updateUserProfile(context,updateData,father);
                                Navigator.of(dialogContext).pop();
                              },
                              child: Container(
                                margin: const EdgeInsets.all(10),
                                height: 40,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: buttonBlue,
                                  borderRadius:
                                  const BorderRadius.all(Radius.circular(8)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      spreadRadius: 2,
                                      blurRadius: 1,
                                      offset: const Offset(0.5, 0.7),
                                    ),
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      spreadRadius: 3,
                                      blurRadius: 1,
                                      offset: const Offset(0.5, 0.7),
                                    ),
                                  ],
                                ),
                                child: const Text(
                                  "Yes",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: "Roboto",
                                      fontSize: 18),
                                ),
                              ),
                            );
                          }
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

editDioceseDialog(BuildContext context,
    {DioceseDetailModel? diocese}) {
  if (diocese != null) {}
  AlertDialog alert = AlertDialog(
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(5.0))),
    backgroundColor: Colors.white,
    surfaceTintColor: Colors.white,
    content: SingleChildScrollView(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * .6,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 5,
            ),
            const Text(
              "Edit Diocese",
              style: TextStyle(fontFamily: "poppinsMedium", fontSize: 20),
            ),
            Divider(
              color: Colors.black87.withOpacity(0.3),
              indent: 5,
              endIndent: 5,
            ),
            const SizedBox(
              height: 15,
            ),
            const EditDioceseForm(),
            const SizedBox(
              height: 20,
            ),
            Align(
              alignment: Alignment.centerRight,
              child: SizedBox(
                width: MediaQuery.of(context).size.width*.2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                        flex: 1,
                        child:
                        Consumer<WebViewModel>(builder: (_, wv, __) {
                          return InkWell(
                            borderRadius:
                            const BorderRadius.all(Radius.circular(30)),
                            onTap: () async {
                              Navigator.of(context, rootNavigator: true)
                                  .pop();
                            },
                            child: Container(
                              margin: const EdgeInsets.all(10),
                              height: 40,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: buttonBlue,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(5)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      spreadRadius: 2,
                                      blurRadius: 1,
                                      offset: const Offset(0.5, 0.7),
                                    ),
                                  ]),
                              child: const Text(
                                "Cancel",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: "poppinsMedium",
                                    fontSize: 14),
                              ),
                            ),
                          );
                        })),
                    Expanded(
                        flex: 1,
                        child:
                        Consumer<WebViewModel>(
                            builder: (_, wv, __) {
                              return InkWell(
                                borderRadius:
                                const BorderRadius.all(Radius.circular(30)),
                                onTap: () async {
                                  wv.updateDioceseDetails(context,diocese!.dioceseId);
                                },
                                child: Container(
                                  margin: const EdgeInsets.all(10),
                                  height: 40,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      color: buttonBlue,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(5)),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          spreadRadius: 2,
                                          blurRadius: 1,
                                          offset: const Offset(0.5, 0.7),
                                        ),
                                      ]),
                                  child: const Text(
                                    "Update",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: "poppinsMedium",
                                        fontSize: 14),
                                  ),
                                ),
                              );
                            })),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    ),
  );
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
addDioceseDialog(BuildContext context) {
  AlertDialog alert = AlertDialog(
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(5.0)),
    ),
    backgroundColor: Colors.white,
    surfaceTintColor: Colors.white,
    content: SingleChildScrollView(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * .6,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 5),
            const Text(
              "Add Diocese",
              style: TextStyle(fontFamily: "poppinsMedium", fontSize: 20),
            ),
            Divider(
              color: Colors.black87.withOpacity(0.3),
              indent: 5,
              endIndent: 5,
            ),
            const SizedBox(height: 15),
            const EditDioceseForm(), // Reusable form for entering details
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerRight,
              child: SizedBox(
                width: MediaQuery.of(context).size.width * .2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Consumer<WebViewModel>(
                        builder: (_, wv, __) {
                          return InkWell(
                            borderRadius: const BorderRadius.all(Radius.circular(30)),
                            onTap: () {
                              Navigator.of(context, rootNavigator: true).pop();
                            },
                            child: Container(
                              margin: const EdgeInsets.all(10),
                              height: 40,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: buttonBlue,
                                borderRadius: const BorderRadius.all(Radius.circular(5)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    spreadRadius: 2,
                                    blurRadius: 1,
                                    offset: const Offset(0.5, 0.7),
                                  ),
                                ],
                              ),
                              child: const Text(
                                "Cancel",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: "poppinsMedium",
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Consumer<WebViewModel>(
                        builder: (_, wv, __) {
                          return InkWell(
                            borderRadius: const BorderRadius.all(Radius.circular(30)),
                            onTap: () async {
                              // wv.addDioceseDetails(); // Call function to add a new diocese
                            },
                            child: Container(
                              margin: const EdgeInsets.all(10),
                              height: 40,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: buttonBlue,
                                borderRadius: const BorderRadius.all(Radius.circular(5)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    spreadRadius: 2,
                                    blurRadius: 1,
                                    offset: const Offset(0.5, 0.7),
                                  ),
                                ],
                              ),
                              child: const Text(
                                "Add",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: "poppinsMedium",
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

editChurchDialog(BuildContext context,
    {ChurchDetailModel? church}) {
  if (church != null) {}
  AlertDialog alert = AlertDialog(
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(5.0))),
    backgroundColor: Colors.white,
    surfaceTintColor: Colors.white,
    content: SingleChildScrollView(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * .6,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 5,
            ),
            const Text(
              "Edit Church",
              style: TextStyle(fontFamily: "poppinsMedium", fontSize: 20),
            ),
            Divider(
              color: Colors.black87.withOpacity(0.3),
              indent: 5,
              endIndent: 5,
            ),
            const SizedBox(
              height: 15,
            ),
            const EditChurchesForm(),
            const SizedBox(
              height: 20,
            ),
            Align(
              alignment: Alignment.centerRight,
              child: SizedBox(
                width: MediaQuery.of(context).size.width*.2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                        flex: 1,
                        child:
                        Consumer<WebViewModel>(builder: (_, wv, __) {
                          return InkWell(
                            borderRadius:
                            const BorderRadius.all(Radius.circular(30)),
                            onTap: () async {
                              Navigator.of(context, rootNavigator: true)
                                  .pop();
                            },
                            child: Container(
                              margin: const EdgeInsets.all(10),
                              height: 40,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: buttonBlue,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(5)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      spreadRadius: 2,
                                      blurRadius: 1,
                                      offset: const Offset(0.5, 0.7),
                                    ),
                                  ]),
                              child: const Text(
                                "Cancel",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: "poppinsMedium",
                                    fontSize: 14),
                              ),
                            ),
                          );
                        })),
                    Expanded(
                        flex: 1,
                        child:
                        Consumer<WebViewModel>(
                            builder: (_, wv, __) {
                              return InkWell(
                                borderRadius:
                                const BorderRadius.all(Radius.circular(30)),
                                onTap: () async {
                                  wv.updateChurchDetails(context,church!.churchId);
                                },
                                child: Container(
                                  margin: const EdgeInsets.all(10),
                                  height: 40,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      color: buttonBlue,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(5)),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          spreadRadius: 2,
                                          blurRadius: 1,
                                          offset: const Offset(0.5, 0.7),
                                        ),
                                      ]),
                                  child: const Text(
                                    "Update",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: "poppinsMedium",
                                        fontSize: 14),
                                  ),
                                ),
                              );
                            })),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    ),
  );
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
addChurchDialog(BuildContext context) {
  AlertDialog alert = AlertDialog(
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(5.0))),
    backgroundColor: Colors.white,
    surfaceTintColor: Colors.white,
    content: SingleChildScrollView(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * .6,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 5),
            const Text(
              "Add Church",
              style: TextStyle(fontFamily: "poppinsMedium", fontSize: 20),
            ),
            Divider(
              color: Colors.black87.withOpacity(0.3),
              indent: 5,
              endIndent: 5,
            ),
            const SizedBox(height: 15),
            const EditChurchesForm(), // Assuming a separate form for adding a church
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerRight,
              child: SizedBox(
                width: MediaQuery.of(context).size.width * .2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Consumer<WebViewModel>(
                        builder: (_, wv, __) {
                          return InkWell(
                            borderRadius: const BorderRadius.all(Radius.circular(30)),
                            onTap: () {
                              Navigator.of(context, rootNavigator: true).pop();
                            },
                            child: Container(
                              margin: const EdgeInsets.all(10),
                              height: 40,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: buttonBlue,
                                borderRadius: const BorderRadius.all(Radius.circular(5)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    spreadRadius: 2,
                                    blurRadius: 1,
                                    offset: const Offset(0.5, 0.7),
                                  ),
                                ],
                              ),
                              child: const Text(
                                "Cancel",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: "poppinsMedium",
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Consumer<WebViewModel>(
                        builder: (_, wv, __) {
                          return InkWell(
                            borderRadius: const BorderRadius.all(Radius.circular(30)),
                            onTap: () async {
                              // wv.addChurchDetails(); // Call the add function instead of update
                            },
                            child: Container(
                              margin: const EdgeInsets.all(10),
                              height: 40,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: buttonBlue,
                                borderRadius: const BorderRadius.all(Radius.circular(5)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    spreadRadius: 2,
                                    blurRadius: 1,
                                    offset: const Offset(0.5, 0.7),
                                  ),
                                ],
                              ),
                              child: const Text(
                                "Add",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: "poppinsMedium",
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    ),
  );
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

editNameDialog(BuildContext context,
    {UserModel? father}) {
  if (father != null) {}
  AlertDialog alert = AlertDialog(
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(5.0))),
    backgroundColor: Colors.white,
    surfaceTintColor: Colors.white,
    content: SingleChildScrollView(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * .6,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 5,
            ),
            const Text(
              "Edit Name Info",
              style: TextStyle(fontFamily: "poppinsMedium", fontSize: 20),
            ),
            Divider(
              color: Colors.black87.withOpacity(0.3),
              indent: 5,
              endIndent: 5,
            ),
            const SizedBox(
              height: 15,
            ),
            editNameInfo(context),
            const SizedBox(
              height: 20,
            ),
            Align(
              alignment: Alignment.centerRight,
              child: SizedBox(
                width: MediaQuery.of(context).size.width*.2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                        flex: 1,
                        child:
                        Consumer<WebViewModel>(builder: (_, wv, __) {
                          return InkWell(
                            borderRadius:
                            const BorderRadius.all(Radius.circular(30)),
                            onTap: () async {
                              Navigator.of(context, rootNavigator: true)
                                  .pop();
                            },
                            child: Container(
                              margin: const EdgeInsets.all(10),
                              height: 40,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: buttonBlue,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(5)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      spreadRadius: 2,
                                      blurRadius: 1,
                                      offset: const Offset(0.5, 0.7),
                                    ),
                                  ]),
                              child: const Text(
                                "Cancel",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: "poppinsMedium",
                                    fontSize: 14),
                              ),
                            ),
                          );
                        })),
                    Expanded(
                        flex: 1,
                        child:
                        Consumer<EditViewModel>(
                            builder: (_, ev, __) {
                              return InkWell(
                                borderRadius:
                                const BorderRadius.all(Radius.circular(30)),
                                onTap: () async {
                                  Map<String, dynamic> updateData={};
                                  updateData=ev.setNameData();
                                  updateProfileAlert(context,"are you sure to update your Name details ?","confirm",updateData,father!);

                                },
                                child: Container(
                                  margin: const EdgeInsets.all(10),
                                  height: 40,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      color: buttonBlue,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(5)),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          spreadRadius: 2,
                                          blurRadius: 1,
                                          offset: const Offset(0.5, 0.7),
                                        ),
                                      ]),
                                  child: const Text(
                                    "Update",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: "poppinsMedium",
                                        fontSize: 14),
                                  ),
                                ),
                              );
                            })),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    ),
  );
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
editContactDialog(BuildContext context,
    {UserModel? father}) {
  if (father != null) {}
  AlertDialog alert = AlertDialog(
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(5.0))),
    backgroundColor: Colors.white,
    surfaceTintColor: Colors.white,
    content: SingleChildScrollView(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * .6,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 5,
            ),
            const Text(
              "Edit Contact Info",
              style: TextStyle(fontFamily: "poppinsMedium", fontSize: 20),
            ),
            Divider(
              color: Colors.black87.withOpacity(0.3),
              indent: 5,
              endIndent: 5,
            ),
            const SizedBox(
              height: 15,
            ),
            editContactInfo(context),
            const SizedBox(
              height: 20,
            ),
            Align(
              alignment: Alignment.centerRight,
              child: SizedBox(
                width: MediaQuery.of(context).size.width*.2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                        flex: 1,
                        child:
                        Consumer<WebViewModel>(builder: (_, wv, __) {
                          return InkWell(
                            borderRadius:
                            const BorderRadius.all(Radius.circular(30)),
                            onTap: () async {
                              Navigator.of(context, rootNavigator: true)
                                  .pop();
                            },
                            child: Container(
                              margin: const EdgeInsets.all(10),
                              height: 40,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: buttonBlue,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(5)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      spreadRadius: 2,
                                      blurRadius: 1,
                                      offset: const Offset(0.5, 0.7),
                                    ),
                                  ]),
                              child: const Text(
                                "Cancel",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: "poppinsMedium",
                                    fontSize: 14),
                              ),
                            ),
                          );
                        })),
                    Expanded(
                        flex: 1,
                        child:
                        Consumer<EditViewModel>(
                            builder: (_, ev, __) {
                              return InkWell(
                                borderRadius:
                                const BorderRadius.all(Radius.circular(30)),
                                onTap: () async {
                                  Map<String, dynamic> updateData={};
                                  updateData=ev.setContactData();
                                  updateProfileAlert(context,"are you sure to update your Contact details ?","confirm",updateData,father!);

                                },
                                child: Container(
                                  margin: const EdgeInsets.all(10),
                                  height: 40,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      color: buttonBlue,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(5)),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          spreadRadius: 2,
                                          blurRadius: 1,
                                          offset: const Offset(0.5, 0.7),
                                        ),
                                      ]),
                                  child: const Text(
                                    "Update",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: "poppinsMedium",
                                        fontSize: 14),
                                  ),
                                ),
                              );
                            })),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    ),
  );
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
editAddressDialog(BuildContext context,
    {UserModel? father}) {
  if (father != null) {}
  AlertDialog alert = AlertDialog(
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(5.0))),
    backgroundColor: Colors.white,
    surfaceTintColor: Colors.white,
    content: SingleChildScrollView(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * .6,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 5,
            ),
            const Text(
              "Edit Address Info",
              style: TextStyle(fontFamily: "poppinsMedium", fontSize: 20),
            ),
            Divider(
              color: Colors.black87.withOpacity(0.3),
              indent: 5,
              endIndent: 5,
            ),
            const SizedBox(
              height: 15,
            ),
            editAddressInfo(context),
            const SizedBox(
              height: 20,
            ),
            Align(
              alignment: Alignment.centerRight,
              child: SizedBox(
                width: MediaQuery.of(context).size.width*.2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                        flex: 1,
                        child:
                        Consumer<WebViewModel>(builder: (_, wv, __) {
                          return InkWell(
                            borderRadius:
                            const BorderRadius.all(Radius.circular(30)),
                            onTap: () async {
                              Navigator.of(context, rootNavigator: true)
                                  .pop();
                            },
                            child: Container(
                              margin: const EdgeInsets.all(10),
                              height: 40,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: buttonBlue,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(5)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      spreadRadius: 2,
                                      blurRadius: 1,
                                      offset: const Offset(0.5, 0.7),
                                    ),
                                  ]),
                              child: const Text(
                                "Cancel",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: "poppinsMedium",
                                    fontSize: 14),
                              ),
                            ),
                          );
                        })),
                    Expanded(
                        flex: 1,
                        child:
                        Consumer<EditViewModel>(
                            builder: (_, ev, __) {
                              return InkWell(
                                borderRadius:
                                const BorderRadius.all(Radius.circular(30)),
                                onTap: () async {
                                  Map<String, dynamic> updateData={};
                                  updateData=ev.setAddressData();
                                  updateProfileAlert(context,"are you sure to update your Address details ?","confirm",updateData,father!);

                                },
                                child: Container(
                                  margin: const EdgeInsets.all(10),
                                  height: 40,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      color: buttonBlue,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(5)),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          spreadRadius: 2,
                                          blurRadius: 1,
                                          offset: const Offset(0.5, 0.7),
                                        ),
                                      ]),
                                  child: const Text(
                                    "Update",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: "poppinsMedium",
                                        fontSize: 14),
                                  ),
                                ),
                              );
                            })),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    ),
  );
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
editOtherDialog(BuildContext context,
    {UserModel? father}) {
  if (father != null) {}
  AlertDialog alert = AlertDialog(
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(5.0))),
    backgroundColor: Colors.white,
    surfaceTintColor: Colors.white,
    content: SingleChildScrollView(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * .6,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 5,
            ),
            const Text(
              "Edit Other Info",
              style: TextStyle(fontFamily: "poppinsMedium", fontSize: 20),
            ),
            Divider(
              color: Colors.black87.withOpacity(0.3),
              indent: 5,
              endIndent: 5,
            ),
            const SizedBox(
              height: 15,
            ),
            editOtherInfo(context),
            const SizedBox(
              height: 20,
            ),
            Align(
              alignment: Alignment.centerRight,
              child: SizedBox(
                width: MediaQuery.of(context).size.width*.2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                        flex: 1,
                        child:
                        Consumer<WebViewModel>(builder: (_, wv, __) {
                          return InkWell(
                            borderRadius:
                            const BorderRadius.all(Radius.circular(30)),
                            onTap: () async {
                              Navigator.of(context, rootNavigator: true)
                                  .pop();
                            },
                            child: Container(
                              margin: const EdgeInsets.all(10),
                              height: 40,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: buttonBlue,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(5)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      spreadRadius: 2,
                                      blurRadius: 1,
                                      offset: const Offset(0.5, 0.7),
                                    ),
                                  ]),
                              child: const Text(
                                "Cancel",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: "poppinsMedium",
                                    fontSize: 14),
                              ),
                            ),
                          );
                        })),
                    Expanded(
                        flex: 1,
                        child:
                        Consumer<EditViewModel>(
                            builder: (_, ev, __) {
                              return InkWell(
                                borderRadius:
                                const BorderRadius.all(Radius.circular(30)),
                                onTap: () async {
                                  Map<String, dynamic> updateData={};
                                  updateData=ev.setOtherData();
                                  updateProfileAlert(context,"are you sure to update your Other details ?","confirm",updateData,father!);

                                },
                                child: Container(
                                  margin: const EdgeInsets.all(10),
                                  height: 40,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      color: buttonBlue,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(5)),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          spreadRadius: 2,
                                          blurRadius: 1,
                                          offset: const Offset(0.5, 0.7),
                                        ),
                                      ]),
                                  child: const Text(
                                    "Update",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: "poppinsMedium",
                                        fontSize: 14),
                                  ),
                                ),
                              );
                            })),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    ),
  );
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
void addFatherDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5.0))),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        content: SingleChildScrollView(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * .6,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 5),
                const Text(
                  "Add Father Info",
                  style: TextStyle(fontFamily: "poppinsMedium", fontSize: 20),
                ),
                Divider(
                  color: Colors.black87.withOpacity(0.3),
                  indent: 5,
                  endIndent: 5,
                ),
                const SizedBox(height: 15),
                const AddFatherForm(),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerRight,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * .2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Expanded(
                          flex: 1,
                          child: InkWell(
                            borderRadius: const BorderRadius.all(Radius.circular(30)),
                            onTap: () {
                              Navigator.of(context, rootNavigator: true).pop();
                            },
                            child: Container(
                              margin: const EdgeInsets.all(10),
                              height: 40,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: buttonBlue,
                                borderRadius: const BorderRadius.all(Radius.circular(5)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    spreadRadius: 2,
                                    blurRadius: 1,
                                    offset: const Offset(0.5, 0.7),
                                  ),
                                ],
                              ),
                              child: const Text(
                                "Cancel",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: "poppinsMedium",
                                    fontSize: 14),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Consumer<EditViewModel>(
                            builder: (_, ev, __) {
                              return InkWell(
                                borderRadius: const BorderRadius.all(Radius.circular(30)),
                                onTap: () async {
                                  Map<String, dynamic> updateData={};
                                  updateData=ev.setFatherData();
                                  ev.addUserProfile(dialogContext,updateData);

                                },
                                child: Container(
                                  margin: const EdgeInsets.all(10),
                                  height: 40,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: buttonBlue,
                                    borderRadius: const BorderRadius.all(Radius.circular(5)),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        spreadRadius: 2,
                                        blurRadius: 1,
                                        offset: const Offset(0.5, 0.7),
                                      ),
                                    ],
                                  ),
                                  child: const Text(
                                    "Add",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: "poppinsMedium",
                                        fontSize: 14),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );


    },
  );
}
changeNumberDialog(BuildContext context,
    {UserModel? father}) {
  if (father != null) {}
  AlertDialog alert = AlertDialog(
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(5.0))),
    backgroundColor: Colors.white,
    surfaceTintColor: Colors.white,
    content: SingleChildScrollView(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * .6,
        child: Consumer<WebViewModel>(
          builder: (_,wv,__) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 5,
                ),
                const Text(
                  "Change Mobile Number",
                  style: TextStyle(fontFamily: "poppinsMedium", fontSize: 20),
                ),
                Divider(
                  color: Colors.black87.withOpacity(0.3),
                  indent: 5,
                  endIndent: 5,
                ),
                const SizedBox(
                  height: 15,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    customBoldText(text: "Mobile Number", color: myBlack, fontSize: 14),
                    const SizedBox(height: 5),
                    textField(enabled: false,context, "",TextEditingController(text: father!.phoneNumber), GlobalKey<FormState>(), "validateString"),
                    const SizedBox(height: 15),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    customBoldText(text: "New Mobile Number", color: myBlack, fontSize: 14),
                    const SizedBox(height: 5),
                    textField(enabled: true,context, "", wv.newMobileNumber, wv.formNewMobile, "validateString"),
                    const SizedBox(height: 15),
                  ],
                ),

                const SizedBox(
                  height: 20,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width*.2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Expanded(
                            flex: 1,
                            child:
                            Consumer<WebViewModel>(builder: (_, wv, __) {
                              return InkWell(
                                borderRadius:
                                const BorderRadius.all(Radius.circular(30)),
                                onTap: () async {
                                  Navigator.of(context, rootNavigator: true)
                                      .pop();
                                },
                                child: Container(
                                  margin: const EdgeInsets.all(10),
                                  height: 40,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      color: buttonBlue,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(5)),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          spreadRadius: 2,
                                          blurRadius: 1,
                                          offset: const Offset(0.5, 0.7),
                                        ),
                                      ]),
                                  child: const Text(
                                    "Cancel",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: "poppinsMedium",
                                        fontSize: 14),
                                  ),
                                ),
                              );
                            })),
                        Expanded(
                            flex: 1,
                            child:
                            Consumer<EditViewModel>(
                                builder: (_, ev, __) {
                                  return InkWell(
                                    borderRadius:
                                    const BorderRadius.all(Radius.circular(30)),
                                    onTap: () async {
                                        wv.changePrimaryNumber(father);
                                        finish(context);
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.all(10),
                                      height: 40,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          color: buttonBlue,
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(5)),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(0.1),
                                              spreadRadius: 2,
                                              blurRadius: 1,
                                              offset: const Offset(0.5, 0.7),
                                            ),
                                          ]),
                                      child: const Text(
                                        "Update",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: "poppinsMedium",
                                            fontSize: 14),
                                      ),
                                    ),
                                  );
                                })),
                      ],
                    ),
                  ),
                )
              ],
            );
          }
        ),
      ),
    ),
  );
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
void confirmDownloadDialog({
  required BuildContext context,
  required String title,
  required String text,
  required String yesText,
  required String noText,
  required VoidCallback onYes,
  required VoidCallback onNo,
}) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(6.0)),
        ),
        backgroundColor: Colors.white,
        content: SizedBox(
          width: 400,
          child: IntrinsicHeight(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.black,
                    fontFamily: "Roboto",
                    fontSize: 20,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    text,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.black,
                      fontFamily: "Roboto",
                      fontSize: 14,
                    ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        borderRadius: const BorderRadius.all(Radius.circular(8)),
                        onTap: () {
                          Navigator.of(dialogContext).pop(); // Close the dialog
                          onNo();
                        },
                        child: Container(
                          margin: const EdgeInsets.all(10),
                          height: 40,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: const BorderRadius.all(Radius.circular(8)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                spreadRadius: 2,
                                blurRadius: 1,
                                offset: const Offset(0.5, 0.7),
                              ),
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                spreadRadius: 3,
                                blurRadius: 1,
                                offset: const Offset(0.5, 0.7),
                              ),
                            ],
                          ),
                          child: Text(
                            noText,
                            style: const TextStyle(
                              color: buttonBlue,
                              fontFamily: "Roboto",
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        borderRadius: const BorderRadius.all(Radius.circular(8)),
                        onTap: () {
                          Navigator.of(dialogContext).pop(); // Close the dialog
                          onYes();
                        },
                        child: Container(
                          margin: const EdgeInsets.all(10),
                          height: 40,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: buttonBlue,
                            borderRadius: const BorderRadius.all(Radius.circular(8)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                spreadRadius: 2,
                                blurRadius: 1,
                                offset: const Offset(0.5, 0.7),
                              ),
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                spreadRadius: 3,
                                blurRadius: 1,
                                offset: const Offset(0.5, 0.7),
                              ),
                            ],
                          ),
                          child: Text(
                            yesText,
                            style: const TextStyle(
                              color: Colors.white,
                              fontFamily: "Roboto",
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
