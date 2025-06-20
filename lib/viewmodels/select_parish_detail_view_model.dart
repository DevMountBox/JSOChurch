import 'package:flutter/cupertino.dart';
import 'package:jsochurch/utils/globals.dart';
import 'package:jsochurch/utils/my_functions.dart';
import 'package:jsochurch/views/church_view.dart';
import 'package:jsochurch/views/nav_bar.dart';
import 'package:jsochurch/views/select_diocese_view.dart';

import '../models/church_model.dart';
import '../models/parishEnterModel.dart';

class SelectParishDetailViewModel extends ChangeNotifier{

  List<ParishEnterModel> parishLoginStatus=[ParishEnterModel("Enter Parish Name",1),ParishEnterModel("I am Retired",2),ParishEnterModel("Not Assigned",3)];
  ParishEnterModel? selectedOption;
  ChurchModel? selectedWorkingParish;

  void setSelectedOption(ParishEnterModel selection){
    selectedOption=selection;
    notifyListeners();
  }

  void setSelectedMotherParish(ChurchModel church){
    selectedWorkingParish=church;
    notifyListeners();
  }
  Future<void> updateParishDetails(BuildContext context) async {
    if(selectedOption!.id!=1){
      String userId=loginUser!.userId;
      int selected=selectedOption!.id;
      Map<String, dynamic> updateData = {};
      updateData['status'] = selected;
     await mRoot.child("users").child(userId).update(updateData);
     callNextReplacement(NavbarView(), context);
    }else{
        callNext(SelectDioceseView(), context);
    }
  }

  Future<void> updateWorkingParish() async {
    String userId=loginUser!.userId;
    int selected=selectedOption!.id;
    Map<String, dynamic> updateData = {};
    Map<String, dynamic> clergyData = {};
    Map<String, dynamic> primaryVicarData = {};
    updateData['status'] = selected;
    updateData['primaryAt'] = selectedWorkingParish!.churchName;
    updateData["primaryAtId"] = selectedWorkingParish!.churchId;

    clergyData["vicarAt"]=selectedWorkingParish!.churchName;

    await mRoot.child("users").child(userId).update(updateData);
    await mRoot.child("clergy").child(loginUser!.type).child(loginUser!.userId).update(clergyData);

    if(selectedWorkingParish!=null){
      primaryVicarData["primaryVicarId"] = loginUser!.userId;
      primaryVicarData["primaryVicar"] = loginUser!.fatherName;
      await mRoot.child("churchDetails").child(selectedWorkingParish!.churchId).update(primaryVicarData);
      await mRoot.child("church").child(selectedWorkingParish!.churchId).update(primaryVicarData);

    }

  }
}