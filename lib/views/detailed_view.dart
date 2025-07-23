import 'package:flutter/material.dart';
import 'package:jsochurch/utils/my_colors.dart';
import 'package:jsochurch/utils/my_functions.dart';
import 'package:jsochurch/viewmodels/detailed_view_model.dart';
import 'package:jsochurch/viewmodels/select_church_view_model.dart';
import 'package:jsochurch/views/church_view.dart';
import 'package:jsochurch/widgets/adapter_widgets.dart';
import 'package:jsochurch/widgets/text_widget.dart';
import 'package:provider/provider.dart';

import '../models/multi_diocese_model.dart';
import '../utils/globals.dart';
import '../widgets/bluerd_image_widget.dart';

class DetailedView extends StatelessWidget {
  final String from;

  const DetailedView({super.key, required this.from});

  @override
  Widget build(BuildContext context) {
    return from == "diocese"
        ? dioceseView(context)
        : from == "church"
            ? churchView(context)
            : from == "metropolitan"
                ? metropolitanView(context)
                : from == "father"
                    ? fatherView(context)
                    : const SizedBox();
  }

  Widget dioceseView(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: myWhite,
      body: SafeArea(child: SingleChildScrollView(
        child: Consumer<DetailedViewModel>(builder: (_, dv, __) {
          return dv.dioceseDetailModel != null
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
          BlurredImageWidget(
          imageUrl:dv.dioceseDetailModel!.image,
            placeholderImage: "assets/images/diocese_place_holder.png",
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
                              text: "${dv.dioceseDetailModel!.dioceseName}",
                              color: myBlack,
                              fontSize: 24),
                          const SizedBox(
                            height: 5,
                          ),
                          dv.dioceseDetailModel!.address!=""?  Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              customNormalText(
                                  text: dv.dioceseDetailModel!.address,
                                  color: myGreyText,
                                  fontSize: 16),
                              const SizedBox(
                                height: 20,
                              ),
                            ],
                          ):SizedBox(height: 10,),
                          dv.dioceseDetailModel!.phoneNumber!=""?  detailsAdapter(context, "phone",
                              dv.dioceseDetailModel!.phoneNumber):SizedBox(),
                          dv.dioceseDetailModel!.website!="" ? Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: detailsAdapterUrl(context, "website",
                                dv.dioceseDetailModel!.website),
                          ):const SizedBox(),
                          Consumer<SelectChurchViewModel>(
                            builder: (_,cv,__) {
                              return InkWell(
                                onTap: (){
                                  cv.otherChurches(dv.dioceseDetailModel!.dioceseName);
                                  callNext(ChurchView(title: "${dv.dioceseDetailModel!.dioceseName} Churches",), context);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                                  child: detailsAdapter(context, "dioceses",
                                      "${dv.dioceseDetailModel!.noOfChurches} churches"),
                                ),
                              );
                            }
                          ),
                          Divider(
                            color: myChipText.withOpacity(.25),
                            indent: 5,
                            endIndent: 5,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          dv.primaryVicar != null
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    customBoldText(
                                        text: "Diocese Metropolitan",
                                        color: myBlack,
                                        fontSize: 18),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    InkWell(
                                      onTap: (){
                                        dv.getFatherDetails(dv.primaryVicar!.userId);
                                        callNext( const DetailedView(from: "metropolitan"), context);

                                      },
                                      child: diocesePositionedFatherAdapter(
                                          context: context,
                                          image: dv.primaryVicar!.image,
                                          name: dv.primaryVicar!.fatherName,
                                          phone: dv.primaryVicar!.phoneNumber),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                  ],
                                )
                              : SizedBox(),
                          dv.secondDioceseMetropolitan != null
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    customBoldText(
                                        text: "Diocese Metropolitan",
                                        color: myBlack,
                                        fontSize: 18),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    InkWell(
                                      onTap: (){
                                        dv.getFatherDetails(dv.secondDioceseMetropolitan!.userId);
                                        callNext( const DetailedView(from: "metropolitan"), context);

                                      },
                                      child: diocesePositionedFatherAdapter(
                                          context: context,
                                          image: dv.secondDioceseMetropolitan!.image,
                                          name: dv.secondDioceseMetropolitan!.fatherName,
                                          phone: dv.secondDioceseMetropolitan!.phoneNumber),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                  ],
                                )
                              : SizedBox(),

                          dv.secondaryVicar != null
                              ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    customBoldText(
                                        text: "Diocese Secretary",
                                        color: myBlack,
                                        fontSize: 18),
                                    const SizedBox(
                                      height: 10,
                                    ),
                      InkWell(
                          onTap: (){
                            if(dv.secondaryVicar!.userId!="notdefined") {
                              dv.getFatherDetails(dv.secondaryVicar!.userId);
                              callNext(
                                  const DetailedView(from: "father"), context);
                            }
                          },
                                      child: diocesePositionedFatherAdapter(
                                          context: context,
                                          image: dv.secondaryVicar!.image,
                                          name: dv.secondaryVicar!.fatherName,
                                          phone: dv.secondaryVicar!.phoneNumber),
                                    ),
                                  ],
                                )
                              : SizedBox(),
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
                );
        }),
      )),
    );
  }

  Widget churchView(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return Consumer<DetailedViewModel>(builder: (_, dv, __) {
      return Scaffold(
        backgroundColor: myWhite,
        body: SafeArea(
            child: SingleChildScrollView(
          child: dv.churchDetailModel != null
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        BlurredImageWidget(
                          imageUrl: dv.churchDetailModel!.image,
                          placeholderImage: "assets/images/church_place_holder.png",
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
                              text: dv.churchDetailModel!.churchName,
                              color: myBlack,
                              fontSize: 24),
                          const SizedBox(
                            height: 5,
                          ),
                          customNormalText(
                              text: dv.churchDetailModel!.address,
                              color: myGreyText,
                              fontSize: 16),
                          const SizedBox(
                            height: 20,
                          ),
                          dv.churchDetailModel!.phoneNumber!=""? detailsAdapter(context, "phone",
                              dv.churchDetailModel!.phoneNumber):SizedBox(),
                          dv.churchDetailModel!.emailId!=""? Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: detailsAdapter(
                                context, "mail", dv.churchDetailModel!.emailId),
                          ):SizedBox(),
                          dv.churchDetailModel!.website!=""?  detailsAdapterUrl(context, "website",
                              dv.churchDetailModel!.website):SizedBox(),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: InkWell(
                              onTap: (){
                                dv.getDioceseDetails(dv.churchDetailModel!.dioceseId);
                                callNext(
                                    const DetailedView(from: "diocese"), context);
                              },
                              child: detailsAdapter(context, "dioceses",
                                  "${dv.churchDetailModel!.diocese} "),
                            ),
                          ),
                          Divider(
                            color: myChipText.withOpacity(.25),
                            indent: 5,
                            endIndent: 5,
                          ),
                         dv.primaryVicar!=null? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 20,
                              ),
                              customBoldText(
                                  text: "Church Vicar",
                                  color: myBlack,
                                  fontSize: 18),
                              const SizedBox(
                                height: 10,
                              ),
                      InkWell(
                          onTap: (){
                            dv.getFatherDetails(dv.primaryVicar!.userId);
                            callNext( const DetailedView(from: "father"), context);

                          },
                                child: fatherPositionedAdapter(
                                    context: context,
                                    image: dv.primaryVicar!.image,
                                    name: dv.primaryVicar!.fatherName,
                                    position: "Primary Vicar",phone: dv.primaryVicar!.phoneNumber),
                              ),
                            ],
                          ):SizedBox(),
                          const SizedBox(
                            height: 8,
                          ),
                        dv.secondaryVicar!=null?  InkWell(
                            onTap: (){
                              dv.getFatherDetails(dv.secondaryVicar!.userId);
                              callNext( const DetailedView(from: "father"), context);

                            },
                          child: fatherPositionedAdapter(
                                context: context,
                                image: dv.secondaryVicar!.image,
                                name: dv.secondaryVicar!.fatherName,
                                position: "Secondary Vicar",phone: dv.secondaryVicar!.phoneNumber),
                        ):SizedBox(),
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

  Widget metropolitanView(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

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
                            height: 5,
                          ),
                          dv.fatherDetailModel!.positions!=""? customNormalText(
                              text: dv.fatherDetailModel!.positions,
                              color: myGreyText,
                              fontSize: 16):SizedBox(),

                          dv.fatherDetailModel!.primaryAt!=""?  InkWell(
                            onTap: (){
                              dv.getDioceseDetails(
                                  "${dv.fatherDetailModel!.primaryAtId}");
                              callNext(
                                  const DetailedView(from: "diocese"), context);
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 8,),
                                customNormalText(
                                    text: "Diocese Incharge",
                                    color: myGreyText,
                                    fontSize: 14),
                                const SizedBox(
                                  height: 10,
                                ),
                                FutureBuilder<int>(
                                  future: dv.getChurchCount(dv.fatherDetailModel!.primaryAtId),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState == ConnectionState.waiting) {
                                      return CircularProgressIndicator(); // Show loading indicator while waiting
                                    } else if (snapshot.hasError) {
                                      return Text("Error: ${snapshot.error}"); // Show error message if any
                                    } else if (!snapshot.hasData) {
                                      return Text("No data available"); // Handle the case where there's no data
                                    }

                                    return dioceseLocationAdapter(
                                      context: context,
                                      location: "${dv.fatherDetailModel!.primaryAt}",
                                      totalChurches: snapshot.data.toString(), // Convert integer to string
                                      isArrow: true,
                                    );
                                  },
                                ),
                              ],
                            ),
                          ):SizedBox(),
                          if (multiDioceseList.any((diocese) => diocese.metropolitanId == dv.fatherDetailModel!.userId))
                            Builder(
                              builder: (context) {
                                MultiDioceseModel matchingDiocese = multiDioceseList.firstWhere(
                                      (diocese) => diocese.metropolitanId == dv.fatherDetailModel!.userId,
                                );
                                print(matchingDiocese.dioceseName);
                                return Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                                      child: Divider(
                                        color: myChipText.withOpacity(.25),
                                        indent: 5,
                                        endIndent: 5,
                                      ),
                                    ),

                                    InkWell(
                                      onTap: () {
                                        dv.getDioceseDetails(matchingDiocese.dioceseId);
                                        callNext(const DetailedView(from: "diocese"), context);
                                      },
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          customNormalText(
                                            text: "Diocese Incharge",
                                            color: myGreyText,
                                            fontSize: 14,
                                          ),
                                          const SizedBox(height: 10),
                                          FutureBuilder<int>(
                                            future: dv.getChurchCount(matchingDiocese.dioceseId),
                                            builder: (context, snapshot) {
                                              if (snapshot.connectionState == ConnectionState.waiting) {
                                                return const CircularProgressIndicator();
                                              } else if (snapshot.hasError) {
                                                return Text("Error: ${snapshot.error}");
                                              } else if (!snapshot.hasData) {
                                                return const Text("No data available");
                                              }

                                              return dioceseLocationAdapter(
                                                context: context,
                                                location: "${matchingDiocese.dioceseName}",
                                                totalChurches: snapshot.data.toString(),
                                                isArrow: true,
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          Divider(
                            color: myChipText.withOpacity(.25),
                            indent: 5,
                            endIndent: 5,
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          detailsAdapter(context, "phone",
                              dv.fatherDetailModel!.phoneNumber),
                          dv.fatherDetailModel!.secondaryNumber!=""?  Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: detailsAdapter(context, "phone",
                                dv.fatherDetailModel!.secondaryNumber),
                          ):SizedBox(),
                          Divider(
                            color: myChipText.withOpacity(.25),
                            indent: 5,
                            endIndent: 5,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          dv.fatherDetailModel!.ordination.trim()!="on"?  Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              customNormalText(
                                  text: "Consecration",
                                  color: myGreyText,
                                  fontSize: 14),
                              const SizedBox(
                                height: 5,
                              ),
                              customNormalText(
                                  text:  dv.fatherDetailModel!.ordination, color: myBlack, fontSize: 16),
                            ],
                          ):const SizedBox()
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

  Widget fatherView(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

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
                          imageUrl: dv.fatherDetailModel?.image, // Pass image URL dynamically
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
                            height: 5,
                          ),
                          dv.fatherDetailModel!.positions!=""? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              customNormalText(
                                  text: dv.fatherDetailModel!.positions,
                                  color: myGreyText,
                                  fontSize: 16),
                              const SizedBox(
                                height: 20,
                              ),
                            ],
                          ):SizedBox(),
                          dv.fatherDetailModel!.primaryAt != ""
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 8,),
                                    customNormalText(
                                        text: "Primary Vicar at",
                                        color: myGreyText,
                                        fontSize: 14),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    customNormalText(
                                        text: dv.fatherDetailModel!.primaryAt,
                                        color: myBlack,
                                        fontSize: 16),
                                  ],
                                )
                              : SizedBox(),
                          dv.fatherDetailModel!.secondaryVicarAt != ""
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 8,),
                                    customNormalText(
                                        text: "Secondary Vicar at",
                                        color: myGreyText,
                                        fontSize: 14),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    customNormalText(
                                        text: dv.fatherDetailModel!.secondaryVicarAt,
                                        color: myBlack,
                                        fontSize: 16),
                                  ],
                                )
                              : SizedBox(),
                          dv.fatherDetailModel!.dioceseSecretary != ""
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 8,),
                                    customNormalText(
                                        text: "Diocese Secretary at",
                                        color: myGreyText,
                                        fontSize: 14),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    customNormalText(
                                        text: "${dv.fatherDetailModel!.dioceseSecretary}",
                                        color: myBlack,
                                        fontSize: 16),
                                  ],
                                )
                              : SizedBox(),
                          Divider(
                            color: myChipText.withOpacity(.25),
                            indent: 5,
                            endIndent: 5,
                          ),
                          customBoldText(
                              text: "Contact Info",
                              color: myBlack,
                              fontSize: 16),
                          const SizedBox(
                            height: 10,
                          ),
                          detailsAdapter(context, "phone",
                              dv.fatherDetailModel!.phoneNumber),
                          dv.fatherDetailModel!.secondaryNumber!=""? Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: detailsAdapter(context, "phone",
                                dv.fatherDetailModel!.secondaryNumber),
                          ):SizedBox(),
                          dv.fatherDetailModel!.emailId!=""? detailsAdapter(
                              context, "mail", dv.fatherDetailModel!.emailId):SizedBox(),
                          Divider(
                            color: myChipText.withOpacity(.25),
                            indent: 5,
                            endIndent: 5,
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          customBoldText(
                              text: "Address", color: myBlack, fontSize: 16),
                          const SizedBox(
                            height: 10,
                          ),
                          customNormalText(
                              text: "Permanent Address",
                              color: myGreyText,
                              fontSize: 14),
                          const SizedBox(
                            height: 5,
                          ),
                          customNormalText(
                              text: dv.fatherDetailModel!.permanentAddress,
                              color: myBlack,
                              fontSize: 16),
                          SizedBox(
                            height: 10,
                          ),
                          customNormalText(
                              text: "Present Address",
                              color: myGreyText,
                              fontSize: 14),
                          const SizedBox(
                            height: 5,
                          ),
                          customNormalText(
                              text: dv.fatherDetailModel!.presentAddress,
                              color: myBlack,
                              fontSize: 16),
                          const SizedBox(
                            height: 10,
                          ),
                          customNormalText(
                              text: "Mother Parish",
                              color: myGreyText,
                              fontSize: 14),
                          const SizedBox(
                            height: 5,
                          ),
                          dv.fatherDetailModel!.motherParish!=""? customNormalText(
                              text: dv.fatherDetailModel!.motherParish,
                              color: myBlack,
                              fontSize: 16): customNormalText(text: "Not Entered",fontSize: 16,color:myBlack ),
                          const SizedBox(
                            height: 5,
                          ),
                          Divider(
                            color: myChipText.withOpacity(.25),
                            indent: 5,
                            endIndent: 5,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          customBoldText(
                              text: "Other Details",
                              color: myBlack,
                              fontSize: 16),
                          const SizedBox(
                            height: 10,
                          ),
                          customNormalText(
                              text: "Age & Date of Birth",
                              color: myGreyText,
                              fontSize: 14),
                          const SizedBox(
                            height: 5,
                          ),
                          customNormalText(
                              text: dv.fatherDetailModel!.dob,
                              color: myBlack,
                              fontSize: 16),
                          SizedBox(
                            height: 10,
                          ),
                          customNormalText(
                              text: "Blood Group",
                              color: myGreyText,
                              fontSize: 14),
                          const SizedBox(
                            height: 5,
                          ),
                          customNormalText(
                              text: dv.fatherDetailModel!.bloodGroup,
                              color: myBlack,
                              fontSize: 16),
                          const SizedBox(
                            height: 10,
                          ),
                          customNormalText(
                              text: "Ordained by",
                              color: myGreyText,
                              fontSize: 14),
                          const SizedBox(
                            height: 5,
                          ),
                          customNormalText(
                              text: dv.fatherDetailModel!.ordination,
                              color: myBlack,
                              fontSize: 16),
                          const SizedBox(
                            height: 5,
                          ),
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

  Widget detailsAdapterUrl(BuildContext context, String asset, String content) {
    return Row(
      children: [
        SizedBox(
          height: 30,
          width: 30,
          child: Image.asset("assets/images/$asset.png"),
        ),
        const SizedBox(width: 10),
        customHyperlinkText(text: content, color: Colors.blue, fontSize: 16),
      ],
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
    },
            child: customNormalText(text: content, color: myBlack, fontSize: 16)):
        customNormalText(text: content, color: myBlack, fontSize: 16)
      ],
    );
  }
}
