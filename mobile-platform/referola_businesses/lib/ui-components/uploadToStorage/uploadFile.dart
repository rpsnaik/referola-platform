import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:referola_businesses/ui-components/buttons/customAlertBox.dart';

class FirebaseStorageUploadTask {
  Future<String> uploadTaskImage(BuildContext context, StorageReference storageReference) async {
    String fileUrl;
    await ImagePicker().getImage(source: ImageSource.gallery, imageQuality: 10).then((PickedFile imgFileSelected) async {
      if (imgFileSelected != null) {
        print("Starting to Upload");
        
        
        StorageUploadTask task = storageReference.putFile(File(imgFileSelected.path));
        print("Upload started");
        await task.onComplete;
        print("Uploaded");
        fileUrl = await storageReference.getDownloadURL();
        
      }
    }).catchError((e) {
      CustomAlertBox().load(context, "Image Picker Error", e.message);
      print(e);
    });

    return fileUrl;
  }

  Future<String> uploadBannerImage(BuildContext context, StorageReference storageReference, File croppedImage) async {
    String fileUrl;
    StorageUploadTask task = storageReference.putFile(croppedImage);
    print("Upload started");
    await task.onComplete;
    print("Uploaded");
    fileUrl = await storageReference.getDownloadURL();

    return fileUrl;
  }

}