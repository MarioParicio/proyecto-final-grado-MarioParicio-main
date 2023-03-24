import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../imports.dart';


final dio = Dio();
final String COLLECTION_NAME = "bocadillos";


class BocadilloService {
  static Future<String> savePhoto(XFile photoXFile) async {
    File photo = File(photoXFile.path);
    String fileName = photo.path.split('/').last;
    Reference ref = FirebaseStorage.instance.ref().child(fileName);
    UploadTask uploadTask = ref.putFile(photo);
    TaskSnapshot taskSnapshot = await uploadTask;
    String url = await taskSnapshot.ref.getDownloadURL();
    return url;
    
  }
    static Future<String> savePhotoString(String photoXFile) async {
    var path;
    File photo = File(path);
    String fileName = photo.path.split('/').last;
    Reference ref = FirebaseStorage.instance.ref().child(fileName);
    UploadTask uploadTask = ref.putFile(photo);
    TaskSnapshot taskSnapshot = await uploadTask;
    String url = await taskSnapshot.ref.getDownloadURL();
    return url;
    
  }

  static Future<List<Bocadillo>> fetchBocadillos() async {
    final bocadillos = <Bocadillo>[];

    try {
      final snapshot = await FirebaseFirestore.instance.collection(COLLECTION_NAME).get();
      //obtener el uid

      snapshot.docs.forEach((doc) {
        var bocadilloData = doc.data();
        bocadilloData['uid'] = doc.id;
        bocadillos.add(Bocadillo.fromJson(bocadilloData));
      });
    } catch (e) {}

    return bocadillos;
  }

  static Future<void> addBocadillo(String name, String description, String photoUrl) async {


    Bocadillo bocadillo = Bocadillo(
      name: name,
      description: description,
      photoUrl: photoUrl,
    );
    FirebaseFirestore.instance.collection(COLLECTION_NAME).add(bocadillo.toJson());
  }

  static void eliminarBocadillo(String uid) {
    //Obtener bocadillo con id y eliminarlo de la base de datos
    FirebaseFirestore.instance.collection(COLLECTION_NAME).doc(uid).delete();
  }

  static Future<void> actualizarBocadillo(
      String uid, String name, String description, String photoUrl) {
        
    CollectionReference bocadillos = FirebaseFirestore.instance.collection(COLLECTION_NAME);
    return bocadillos
        .doc(uid)
        .update({'description': description, 'name': name, 'photoUrl': photoUrl})
        .then((value) => SnackBar(content: Text("Bocadillo actualizado correctamente")))
        .catchError((error) => SnackBar(content: Text("Error al actualizar bocadillo")));
  }

  static Future<String> savePhotoAndDelete(XFile pickedFile, TextEditingController photoToDelete) {
    return savePhoto(pickedFile).then((url) {
      if (photoToDelete.text.isNotEmpty) {
        deletePhoto(photoToDelete.text);
      }
      return url;
    });
    
    

  }
  static deletePhoto(String photoToDelete) {
    FirebaseStorage.instance.refFromURL(photoToDelete).delete();
  }

}