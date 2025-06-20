


import 'package:crop_image/crop_image.dart';
import 'package:flutter/material.dart';
import 'package:jsochurch/models/user_model.dart';
import 'package:jsochurch/utils/my_colors.dart';
import 'package:jsochurch/viewmodels/profile_view_model.dart';
import 'package:jsochurch/web/view_models/web_view_model.dart';
import 'package:provider/provider.dart';

import '../models/church_detail_model.dart';
import '../models/diocese_detail_model.dart';
import '../utils/my_functions.dart';
class CropPage extends StatefulWidget {
  final String title;
  final String from;
  final ChurchDetailModel? churchDetail;
  final DioceseDetailModel? dioceseDetail;
  final UserModel? user;

  const CropPage({
    Key? key,
    required this.title,
    required this.from,
    this.churchDetail,
    this.dioceseDetail,
    this.user,
  }) : super(key: key);

  @override
  _CropPageState createState() => _CropPageState();
}

class _CropPageState extends State<CropPage> {
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      backgroundColor: buttonBlue,
      title: Text(widget.title),
    ),
    body: Center(
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Consumer2<ProfileViewModel,WebViewModel>(
          builder: (context, value,wv, child) {
            return CropImage(
              controller: widget.from=="profile"?value.controller:wv.controller,
              image: Image.memory(widget.from=="profile"?value.fileBytes!:wv.fileBytes!),
            );
          },
        ),
      ),
    ),
    bottomNavigationBar: _buildButtons(),
  );

  Widget _buildButtons() => Row(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Consumer2<ProfileViewModel,WebViewModel>(
        builder: (context, value,wv, child) {
          return IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              if(widget.from=="profile"){
                value.controller.aspectRatio = 3/4;
                value.controller.crop = const Rect.fromLTRB(0.1, 0.1, 0.9, 0.9);

              }else{
                wv.controller.aspectRatio = 3/4;
                wv.controller.crop = const Rect.fromLTRB(0.1, 0.1, 0.9, 0.9);

              }
            },
          );
        },
      ),
      IconButton(
        icon: const Icon(Icons.aspect_ratio),
        onPressed:widget.from=="profile" ?_aspectRatiosProfile:_aspectRatiosWeb,
      ),
      TextButton(
        onPressed: widget.from=="profile" ?_finishedProfile:_finishedWeb,
        child: const Text('Done'),
      ),
    ],
  );

  Future<void> _aspectRatiosProfile() async {
    ProfileViewModel mainProvider =
    Provider.of<ProfileViewModel>(context, listen: false);

    final value = await showDialog<double>(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: const Text('Select aspect ratio'),
          children: [
            SimpleDialogOption(
              onPressed: () => Navigator.pop(context, 1.0),
              child: const Text('1:1'),
            ),
            SimpleDialogOption(
              onPressed: () => Navigator.pop(context, 2.0),
              child: const Text('2:1'),
            ),
            SimpleDialogOption(
              onPressed: () => Navigator.pop(context, 3.0 / 4.0),
              child: const Text('3:4'),
            ),
            SimpleDialogOption(
              onPressed: () => Navigator.pop(context, 16.0 / 9.0),
              child: const Text('16:9'),
            ),
          ],
        );
      },
    );

    if (value != null) {
      mainProvider.controller.aspectRatio = value;
      mainProvider.controller.crop = const Rect.fromLTRB(0.1, 0.1, 0.9, 0.9);
    }
  }

  Future<void> _finishedProfile() async {
    ProfileViewModel mainProvider =
    Provider.of<ProfileViewModel>(context, listen: false);

    final image = await mainProvider.controller
        .croppedImage(quality: FilterQuality.high);
    final bitmap = await mainProvider.controller
        .croppedBitmap(quality: FilterQuality.high);

    if (widget.from == "profile") {
      if (widget.user != null) {
        mainProvider.makeProfileImage(image, bitmap, widget.user!);
      }
    } else if (widget.from == "proof") {
      // Handle proof logic here if needed
    }

    finish(context);
  }
  Future<void> _aspectRatiosWeb() async {
    WebViewModel mainProvider =
    Provider.of<WebViewModel>(context, listen: false);

    final value = await showDialog<double>(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: const Text('Select aspect ratio'),
          children: [
            SimpleDialogOption(
              onPressed: () => Navigator.pop(context, 1.0),
              child: const Text('1:1'),
            ),
            SimpleDialogOption(
              onPressed: () => Navigator.pop(context, 2.0),
              child: const Text('2:1'),
            ),
            SimpleDialogOption(
              onPressed: () => Navigator.pop(context,   3.0/4.0),
              child: const Text('3:4'),
            ),
            SimpleDialogOption(
              onPressed: () => Navigator.pop(context, 16.0 / 9.0),
              child: const Text('16:9'),
            ),
          ],
        );
      },
    );

    if (value != null) {
      mainProvider.controller.aspectRatio = value;
      mainProvider.controller.crop = const Rect.fromLTRB(0.1, 0.1, 0.9, 0.9);
    }
  }

  Future<void> _finishedWeb() async {
    WebViewModel mainProvider =
    Provider.of<WebViewModel>(context, listen: false);

    final image = await mainProvider.controller
        .croppedImage(quality: FilterQuality.high);
    final bitmap = await mainProvider.controller
        .croppedBitmap(quality: FilterQuality.high);

    if (widget.from != "profile") {
      print(widget.from);
      if (widget.user != null) {

        mainProvider.makeProfileImage(image, bitmap, widget.user!);
      }
      if (widget.churchDetail != null) {
        mainProvider.makeChurchImage(image, bitmap, widget.churchDetail!);
      }
      if (widget.dioceseDetail != null) {
        mainProvider.makeDioceseImage(image, bitmap, widget.dioceseDetail!);
      }
    } else if (widget.from == "proof") {
      // Handle proof logic here if needed
    }

    finish(context);
  }
}
