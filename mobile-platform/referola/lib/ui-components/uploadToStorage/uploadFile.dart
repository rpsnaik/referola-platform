import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:referola/models/filesModel.dart';
import '../buttons/customAlertBox.dart';

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


  Future<FilesModel> uploadFile(BuildContext context, String path) async {
    String fileUrl;
    String titleName;
    
    await FilePicker.getFile(
      type: FileType.custom,
    ).then((File file)async{
      if (file != null) {
        print(file.path);
        print("Starting to Upload");
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context){
            return Scaffold(
              backgroundColor: Colors.black.withOpacity(0.5),
              body: Container(
                color: Colors.black.withOpacity(0.5),
                child: Center(
                  child: Text("Uploading...", style: TextStyle(
                    color: Colors.white,
                    fontFamily: "Nunito Sans Bold"
                  ),),
                ),
              ),
            );
          }
        );
        StorageReference storageReference = FirebaseStorage.instance.ref().child(path);
        StorageUploadTask task = storageReference.putFile(file);
        print("Upload started");
        await task.onComplete;
        print("Uploaded");
        Navigator.pop(context);
        fileUrl = await storageReference.getDownloadURL();

        titleName = file.path.split("/").last;
      }
    }).catchError((e){
      print(e);
      CustomAlertBox().load(context, 'Error', e.message);
    });

    return FilesModel(
      fileTitle: titleName,
      fileUrl: fileUrl
    );
  }

}