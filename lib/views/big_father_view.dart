import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/my_colors.dart';
import '../utils/my_functions.dart';
import '../viewmodels/detailed_view_model.dart';
import '../widgets/bluerd_image_widget.dart';
import '../widgets/text_widget.dart';

class BigFatherView extends StatelessWidget {
  const BigFatherView({super.key});

  @override
  Widget build(BuildContext context) {
      return Consumer<DetailedViewModel>(builder: (_, dv, __) {
      return Scaffold(
        backgroundColor: myWhite,
        body: SafeArea(
            child: SingleChildScrollView(
              child: dv.fatherDetailModel != null
                  ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      BlurredImageWidget(
                        imageUrl: dv.fatherDetailModel!.image,
                        placeholderImage: "assets/images/father_place_holder.png",
                        height: 258,
                        width: MediaQuery.of(context).size.width,
                      ),
                      Positioned(
                        top: 15,
                        left: 10,
                        child: InkWell(
                          onTap: () {
                            finish(context);
                          },
                          child: const CircleAvatar(
                            backgroundColor: myWhite,
                            maxRadius: 15,
                            child: Padding(
                              padding: EdgeInsets.only(left: 5.0),
                              child: Icon(
                                Icons.arrow_back_ios,
                                size: 18,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15.0, vertical: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        customBoldText(
                            text: dv.fatherDetailModel!.fatherName,
                            color: myBlack,
                            fontSize: 24),
                        const SizedBox(
                          height: 15,
                        ),
                      customNormalText(text: "Patriarch of Antioch and all the East and Supreme Head of The Universal Syrian Orthodox Church", color: myBlack, fontSize: 16)
                      ],
                    ),
                  ),
                ],
              )
                  : SizedBox(
                height: MediaQuery.of(context).size.height,
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(child: CircularProgressIndicator()),
                  ],
                ),
              ),
            )),
      );
    });
  }
}
