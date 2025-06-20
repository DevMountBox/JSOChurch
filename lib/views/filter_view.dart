import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/app_text_styles.dart';
import '../utils/buttons.dart';
import '../utils/my_colors.dart';
import '../utils/my_functions.dart';
import '../viewmodels/login_view_model.dart';
import '../viewmodels/select_church_view_model.dart';
import '../viewmodels/select_diocese_view_model.dart';
import '../widgets/adapter_widgets.dart';
import '../widgets/seach_bar_widget.dart';
import '../widgets/text_widget.dart';

class FilterView extends StatelessWidget {
  const FilterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: myWhite,
        appBar: AppBar(
          backgroundColor: myWhite,
          centerTitle: true,
          title: customBoldText(text: "Filter", color: myBlack, fontSize: 18),
          leading: InkWell(
            onTap: () {
              finish(context);
            },
            child: const Icon(
              Icons.arrow_back_ios,
              color: buttonBlue,
            ),
          ),
        ),
        bottomNavigationBar:
            Consumer<SelectChurchViewModel>(builder: (_, sv, __) {
          return BottomAppBar(
            height: 100,
            padding: const EdgeInsets.symmetric(vertical: 5),
            color: myWhite,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 20),
              child: Row(
                children: [
                  Consumer<SelectChurchViewModel>(builder: (_, cv, __) {
                    return Expanded(
                      child: MyElevatedButton(
                        height: 45,
                        width: double.infinity,
                        gradient: const LinearGradient(
                            colors: [gradientLightBlue, gradientLightBlue]),
                        onPressed: () async {
                          cv.clearDioceseFilter();
                        },
                        borderRadius:
                            const BorderRadius.all(Radius.circular(60)),
                        child: const Text("Clear Filter",
                            style: AppTextStyles.inter16BlueBoldStyle),
                      ),
                    );
                  }),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child:
                        Consumer<SelectChurchViewModel>(builder: (_, cv, __) {
                      return MyElevatedButton(
                        height: 45,
                        width: double.infinity,
                        onPressed: () async {
                          cv.filteredChurches();
                          finish(context);
                        },
                        borderRadius:
                            const BorderRadius.all(Radius.circular(60)),
                        child: const Text("Apply Filter",
                            style: AppTextStyles.inter16WhiteBoldStyle),
                      );
                    }),
                  ),
                ],
              ),
            ),
          );
        }),
        body: diocesesWidget(context));
  }

  Widget diocesesWidget(BuildContext context) {
    return Consumer<SelectDioceseViewModel>(builder: (_, dv, __) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 15),
            child: searchBar(
              context: context,
              hintText: "Search by diocese name",
              onChanged: (query) {
                dv.searchDiocese(query);
              },
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: ListView.builder(
                itemCount: dv.filteredDioceseList.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  var item = dv.filteredDioceseList[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15.0, vertical: 5),
                    child: Column(
                      children: [
                        Consumer<SelectChurchViewModel>(builder: (_, cv, __) {
                          return InkWell(
                              onTap: () {
                                cv.toggleDioceseFilter(item);
                              },
                              child: dioceseFilterAdapter(
                                  context: context,
                                  diocese: item,
                                  location: item.dioceseName,
                                  totalChurches: item.churchCount.toString(),
                                  value: false));
                        }),
                        Divider(
                          color: myChipText.withOpacity(.25),
                          indent: 5,
                          endIndent: 5,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          )
        ],
      );
    });
  }
}
