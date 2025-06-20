import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jsochurch/models/diocese_model.dart';
import 'package:jsochurch/utils/my_colors.dart';
import 'package:jsochurch/utils/my_functions.dart';
import 'package:jsochurch/viewmodels/select_church_view_model.dart';
import 'package:jsochurch/widgets/text_widget.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../models/clergy_dashboard_model.dart';
// import 'dart:html' as html;

Widget dioceseLocationAdapter({
  required BuildContext context,
  required String location,
  required String totalChurches,
  bool isArrow = true,
}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Expanded( // Ensures text wraps properly without breaking layout
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            customBoldText(text: location, color: myBlack, fontSize: 16),
            const SizedBox(height: 5),
            customNormalText(text: "$totalChurches Churches", color: myGreyText, fontSize: 14),
          ],
        ),
      ),
      isArrow
          ? const Icon(Icons.arrow_forward_ios_rounded, size: 15)
          : const SizedBox(),
    ],
  );
}

Widget dioceseFilterAdapter(
    {required BuildContext context,
    required DioceseModel diocese,
    required String location,
    required String totalChurches,
    required bool value}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          customBoldText(text: location, color: myBlack, fontSize: 16),
          const SizedBox(
            height: 5,
          ),
          customNormalText(
              text: "$totalChurches Churches", color: myGreyText, fontSize: 14)
        ],
      ),
      Theme(
        data: Theme.of(context).copyWith(
          checkboxTheme: CheckboxThemeData(
            side: BorderSide(color: myGreyText.withOpacity(0.25), width: 1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
        child: Transform.scale(
          scale: 1.2,
          child: Consumer<SelectChurchViewModel>(
            builder: (_,cv,__) {
              return Checkbox(
                value: cv.dioceseFiltered(diocese),
                onChanged: (value) {
                  cv.toggleDioceseFilter(diocese);
                },
              );
            }
          ),
        ),
      )
    ],
  );
}

Widget churchAdapter(
    {required BuildContext context,
    required String churchName,
    required String image,
    required String address}) {
  return Row(
    children: [
      SizedBox(
          height: 65,
          width: 65,
          child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: image==""?Image.asset(
            "assets/images/church_place_holder.png",
            fit: BoxFit.cover,
          ):Image.network(
                image,
                fit: BoxFit.cover,
              ))),
      const SizedBox(
        width: 15,
      ),
      Flexible(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            customBoldText(
                text: churchName, color: myBlack, fontSize: 16, maxLines: 2),
            const SizedBox(
              height: 5,
            ),
            customNormalText(
                text: address, color: myGreyText, fontSize: 14, maxLines: 2)
          ],
        ),
      ),
    ],
  );
}

Widget clergyAdapter(
    {required BuildContext context, required ClergyDashboardModal clergy}) {
  return Container(
    height: 117,
    width: 150,
    decoration: BoxDecoration(
        color: clergy.color.withOpacity(0.15),
        borderRadius: const BorderRadius.all(Radius.circular(8))),
    child: Stack(
      children: [
        Positioned(
            right: -2,
            top: 5,
            child: Image.asset("assets/images/${clergy.asset}.png")),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              customBoldText(
                  text: clergy.churchCount, color: clergy.color, fontSize: 32),
              customBoldText(
                  text: clergy.clergyName, color: myBlack, fontSize: 14)
            ],
          ),
        )
      ],
    ),
  );
}

Widget dioceseAdapter(
    {required BuildContext context,
    required String asset,
    required String location,
    required String count}) {
  return Container(
    height: 160,
    width: 154,
    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
    decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        gradient: RadialGradient(colors: [myWhite, gradientLightBlue])),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.asset(
          "assets/images/$asset.png",
          scale: 1.2,
        ),
        const SizedBox(
          height: 10,
        ),
        customBoldText(text: location, color: myBlack, fontSize: 16),
        const SizedBox(
          height: 3,
        ),
        customNormalText(
            text: '$count Dioceses', color: myChipText, fontSize: 12),
      ],
    ),
  );
}

Widget singleDioceseAdapter(
    {required BuildContext context, required String count}) {
  return Container(
    height: 118,
    width: double.infinity,
    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
    decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        gradient: RadialGradient(colors: [myWhite, gradientLightBlue])),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/diocese_home.png",
            ),
            const SizedBox(
              width: 10,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                customBoldText(text: count, color: myClergy1, fontSize: 32),
                customBoldText(text: "Diocese", color: myBlack, fontSize: 14)
              ],
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Icon(
            Icons.arrow_forward_ios_rounded,
            size: 45,
            color: myChipText.withOpacity(0.25),
          ),
        )
      ],
    ),
  );
}

Widget otherChurchGroupWidget(
    {required BuildContext context,
    required Color color,
    required String churchName,
    required String churchCount}) {
  return Container(
    width: 189,
    height: 132,
    decoration: BoxDecoration(
        border: Border.all(color: color),
        borderRadius: const BorderRadius.all(Radius.circular(8))),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          customNormalText(text: churchCount, color: myBlack, fontSize: 32),
          customBoldText(text: churchName, color: myBlack, fontSize: 18),
          customNormalText(text: "Churches", color: myChipText, fontSize: 14)
        ],
      ),
    ),
  );
}
Widget bigFatherAdapter(BuildContext context,
    {required String fatherImage, required String position, required String fatherName}) {
  return Row(
    children: [
      SizedBox(
        height: 100,
        width: 100,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: CachedNetworkImage(
            imageUrl: fatherImage,
            fit: BoxFit.cover,
            alignment: Alignment.topCenter,
            placeholder: (context, url) => Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            errorWidget: (context, url, error) => const Icon(Icons.error, size: 50, color: Colors.red),
          ),
        ),
      ),
      const SizedBox(width: 15),
      SizedBox(
        width: MediaQuery.of(context).size.width * 0.5,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            customBoldText(text: position, color: myBlack, fontSize: 16),
            SizedBox(height: 5,),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.5,
              child: customNormalText(text: fatherName, color: myBlack, fontSize: 14),
            )

          ],
        ),
      ),
    ],
  );
}
Widget fatherAdapter({
  required BuildContext context,
  required String image,
  required String name,
  required String phone,
  required String diocese,
}) {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          children: [
            SizedBox(
              height: 90,
              width: 70,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: image.isEmpty
                    ? Image.asset(
                  "assets/images/father_place_holder.png",
                  fit: BoxFit.cover,
                )
                    : CachedNetworkImage(
                  imageUrl: image,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      color: Colors.white,
                    ),
                  ),
                  errorWidget: (context, url, error) => Image.asset(
                    "assets/images/father_place_holder.png",
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 15),
            Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.5,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  customBoldText(
                    text: name,
                    color: myBlack,
                    fontSize: 16,
                    maxLines: 2,
                  ),
                  const SizedBox(height: 5),
                  customNormalText(
                    text: diocese,
                    color: myGreyText,
                    fontSize: 14,
                    maxLines: 2,
                  ),
                ],
              ),
            ),
          ],
        ),
        InkWell(
          onTap: () {
            launchURL("tel:$phone");
          },
          child: Container(
            height: 40,
            width: 40,
            margin: const EdgeInsets.symmetric(horizontal: 15),
            decoration: const BoxDecoration(
              color: gradientLightBlue,
              shape: BoxShape.circle,
            ),
            child: Image.asset("assets/images/phone.png"),
          ),
        ),
      ],
    ),
  );
}
Widget fatherPositionedAdapter({
  required BuildContext context,
  required String image,
  required String name,
  required String position,
  required String phone,
}) {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 110,
                width: 90,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child:image==""?Image.asset("assets/images/father_place_holder.png"): Image.network(image, fit: BoxFit.cover),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    customBoldText(
                      text: name,
                      color: myBlack,
                      fontSize: 16,
                      maxLines: 2,
                    ),
                    const SizedBox(height: 5),
                    customNormalText(
                      text: position,
                      color: myGreyText,
                      fontSize: 14,
                      maxLines: 2,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
  InkWell(
  onTap: () {
  launchURL("tel:$phone");
  },
          child: Container(
            height: 40,
            width: 40,
            margin: const EdgeInsets.only(left: 15, right: 8),
            decoration: const BoxDecoration(
              color: buttonBlue,
              shape: BoxShape.circle,
            ),
            child: Image.asset(
              "assets/images/phone.png",
              color: myWhite,
            ),
          ),
        ),
      ],
    ),
  );
}
Widget fatherPositionedAdapterWeb({
  required BuildContext context,
  required String image,
  required String name,
  required String position,
  required String phone,
}) {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 110,
                width: 90,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child:image==""?Image.asset("assets/images/father_place_holder.png"): Image.network(image, fit: BoxFit.cover),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    customBoldText(
                      text: name,
                      color: myBlack,
                      fontSize: 16,
                      maxLines: 2,
                    ),
                    const SizedBox(height: 5),
                    customNormalText(
                      text: position,
                      color: myGreyText,
                      fontSize: 14,
                      maxLines: 2,
                    ),
                    const SizedBox(height: 5),
                    customNormalText(
                      text: phone,
                      color: myGreyText,
                      fontSize: 14,
                      maxLines: 2,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget diocesePositionedFatherAdapter({
  required BuildContext context,
  required String image,
  required String name,
  required String phone,
}) {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 110,
                width: 90,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child:image==""?Image.asset("assets/images/father_place_holder.png"): Image.network(image, fit: BoxFit.cover),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    customBoldText(
                      text: name,
                      color: myBlack,
                      fontSize: 16,
                      maxLines: 2,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
  InkWell(
  onTap: () {
  launchURL("tel:$phone");
  },
          child: Container(
            height: 40,
            width: 40,
            margin: const EdgeInsets.only(left: 15, right: 8),
            decoration: const BoxDecoration(
              color: gradientLightBlue,
              shape: BoxShape.circle,
            ),
            child: Image.asset(
              "assets/images/phone.png",
              color: myBlack,
            ),
          ),
        ),
      ],
    ),
  );
}
Widget diocesePositionedFatherAdapterWeb({
  required BuildContext context,
  required String image,
  required String name,
  required String phone,
}) {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 110,
                width: 90,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child:image==""?Image.asset(
                    "assets/images/father_place_holder.png",
                    fit: BoxFit.cover,
                  ): Image.network(image, fit: BoxFit.cover),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    customBoldText(
                      text: name,
                      color: myBlack,
                      fontSize: 16,
                      maxLines: 2,
                    ),
                    const SizedBox(height: 5),
                    customNormalText(
                      text: phone,
                      color: myGreyText,
                      fontSize: 14,
                      maxLines: 2,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget detailsAdapter(BuildContext context, String asset, String content) {
  return Row(
    children: [
      SizedBox(
          height: 30,
          width: 30,
          child: Image.asset("assets/images/$asset.png")),
      const SizedBox(
        width: 10,
      ),
     asset=="phone"?
  InkWell(
  onTap: () {
  launchURL("tel:$content");
  },child: customNormalText(text: content, color: myBlack, fontSize: 16)):
     customNormalText(text: content, color: myBlack, fontSize: 16)
    ],
  );
}
// Widget webImage(String imageUrl) {
//   return HtmlElementView(
//     viewType: 'networkImage',
//     onPlatformViewCreated: (id) {
//       final imgElement = html.ImageElement(src: imageUrl);
//       imgElement.style.width = '100%';
//       imgElement.style.height = '100%';
//       html.document.getElementById(id.toString())?.append(imgElement);
//     },
//   );
// }
