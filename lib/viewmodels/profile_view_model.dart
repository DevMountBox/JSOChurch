import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:crop_image/crop_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jsochurch/models/user_model.dart';
import 'package:path_provider/path_provider.dart';

import '../utils/my_functions.dart';
import '../views/cropscreen.dart';

class ProfileViewModel extends ChangeNotifier{
  final ImagePicker picker = ImagePicker();
  File? uploadedFile;
  Uint8List? fileBytes;
  Image? cropedImage;

  final controller = CropController(
    aspectRatio: 3/4,
    defaultCrop: const Rect.fromLTRB(0.1, 0.1, 0.9, 0.9),
  );
  Future getImageForProfile(BuildContext context,UserModel father) async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final isImage = _isImageFile(pickedFile.path);

      if (isImage) {
        var imagePath = await pickedFile.readAsBytes();
        var fileSize = imagePath.length / (1024 * 1024);
        if (fileSize < 5) {
          uploadedFile = File(pickedFile.path);
          fileBytes = await uploadedFile!.readAsBytes();
          callNext(
               CropPage(
                title: "Crop Image",
                from: "profile",
                user: father,
              ),
              context);
        } else {
          showToast("The Size of Image Limited as 3 MB");
        }
      }
    } else {
      print('No image selected.');
    }

    if (pickedFile != null && pickedFile.path.isEmpty) {
      retrieveLostData();
    }

    notifyListeners();
  }
  Future<void> retrieveLostData() async {
    final LostDataResponse response = await picker.retrieveLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      uploadedFile = File(response.file!.path);
      fileBytes = await uploadedFile!.readAsBytes();
      notifyListeners();
    }
  }

  bool _isImageFile(String filePath) {
    final imageExtensions = [
      'jpg',
      'jpeg',
      'png',
      'gif',
      'bmp'
    ]; // Add more extensions if needed
    final extension = filePath.split('.').last.toLowerCase();
    return imageExtensions.contains(extension);
  }
  Future<void> makeProfileImage(
      Image croped, ui.Image bitmap, UserModel user) async {
    // Convert bitmap to bytes
    ByteData? byteData = await bitmap.toByteData(format: ui.ImageByteFormat.png);
    if (byteData == null) return;

    Uint8List fileBytes = byteData.buffer.asUint8List();
    String fileName = "${user.userId}.png"; // Use user ID for file name

    // Save file locally
    File uploadedFile = File('${(await getTemporaryDirectory()).path}/$fileName');
    await uploadedFile.writeAsBytes(fileBytes);

    // Upload to Firebase Storage
    Reference storageRef =
    FirebaseStorage.instance.ref().child('profile_images/$fileName');
    String url = await (await storageRef.putFile(uploadedFile)).ref.getDownloadURL();

    // Update user image URL in database
    user.image = url;
    FirebaseDatabase.instance.ref("users/${user.userId}/image").set(url);
    FirebaseDatabase.instance.ref("clergy/${user.type}/${user.userId}/image").set(url);

    // Update UI
    cropedImage = croped;
    notifyListeners();
  }

}