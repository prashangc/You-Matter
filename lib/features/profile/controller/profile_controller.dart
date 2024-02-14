import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../services/firebase/firebase_query_handler.dart';

class ProfileController {
  Future<void> updatePhotoUrl(User user, File profilePicture) async {
    await storeFileAndGetUrl(user, profilePicture).then((value) async {
      await FirebaseQueryHelper.firebaseFireStore
          .collection("users")
          .doc(user.uid)
          .update({'photoUrl': value});
    });
  }

  Future<String> storeFileAndGetUrl(User user, File profilePicture) async {
    Reference reference = FirebaseStorage.instance
        .ref()
        .child('userProfilePictures/${user.uid}/ProfilePicture.jpg');
    UploadTask uploadTask = reference.putFile(profilePicture);
    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
    String downloadURL = await taskSnapshot.ref.getDownloadURL();
    return downloadURL;
  }

  Future<void> onUpdateProfile(User? user) async {
    final imagePicker = ImagePicker();
    XFile? image;
    final permissionStatus = await Permission.mediaLibrary.isGranted ||
        await Permission.mediaLibrary.isLimited;
    if (permissionStatus) {
      image = await imagePicker.pickImage(
          source: ImageSource.gallery, imageQuality: 5);
      if (image != null && user != null) {
        await updatePhotoUrl(user, File(image.path));
      }
    } else {
      bool hasPermission = await Permission.mediaLibrary.request().isGranted ||
          await Permission.mediaLibrary.request().isLimited;
      if (hasPermission) {
        image = await imagePicker.pickImage(source: ImageSource.gallery);
        if (image != null && user != null) {
          await updatePhotoUrl(user, File(image.path));
        }
      }
    }
  }
}

final profileController = ProfileController();
