import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class UserModel {
  UserModel({this.email, this.password, this.name, this.code, this.id});

  UserModel.fromDocument(DocumentSnapshot doc) {
    id = doc.id;
    name = doc.data()['name'] as String;
    code = doc.data()['code'] as String;
    email = doc.data()['email'] as String;
    imageProfile = doc.data()['imageProfile'] as String;
    cpf = doc.data()['cpf'] as String;

    recipesAdmin = doc.data()['recipesAdmin'] as List<dynamic>;
  }

  String id;
  String name;
  String code;
  String email;
  String imageProfile;
  String cpf;
  String password;

  String confirmPassword;

  bool admin = false;

  List<dynamic> recipesAdmin = [];

  List<String> get recipesAdminIds {
    final List<String> newList = [];
    recipesAdmin.map((recipe) {
      newList.add(recipe['recipeId'] as String);
    }).toList();

    return newList;
  }

  CollectionReference get cartsReference =>
      userReference.collection('carts');

  DocumentReference get userReference =>
      FirebaseFirestore.instance.doc('users/$id');

  Future<void> saveData() async {
    await FirebaseFirestore.instance.doc('users/$id').set(toMap());
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'code': code,
      'email': email,
      if (imageProfile != null) 'imageProfile': imageProfile,
      if (recipesAdmin != []) 'recipesAdmin': recipesAdmin,
      if (cpf != null) 'cpf': cpf
    };
  }

  Future<void> uploadImageProfile(File newImageProfile) async {
    final UploadTask task = FirebaseStorage.instance
        .ref()
        .child('users')
        .child(id)
        .child(const Uuid().v1())
        .putFile(newImageProfile);
    final TaskSnapshot snapshot = await task.whenComplete(() => null);
    final String url = await snapshot.ref.getDownloadURL();
    setImageProfile(url);
  }

  void setImageProfile(String imageProfile) {
    this.imageProfile = imageProfile;
    saveData();
  }

  void setRecipesAdmin(
      {String recipeId,
      String recipeName,
      bool recipeExists,
      bool recipeDeleted}) {
    final Map<String, dynamic> data = {
      'recipeId': recipeId,
      'recipeName': recipeName,
      'recipeDeleted': recipeDeleted,
    };
    if (recipeExists) {
      final int index = recipesAdmin
          .indexWhere((e) => e['recipeId'].toString() == recipeId.toString());
      recipesAdmin.removeAt(index);
      recipesAdmin.insert(index, data);
    } else {
      recipesAdmin.add(data);
    }
    saveData();
  }

  void deleteRecipeAdmin({String recipeId}) {
    final int index = recipesAdmin
        .indexWhere((e) => e['recipeId'].toString() == recipeId.toString());
    recipesAdmin.removeAt(index);
    saveData();
  }

  void setCpf(String cpf) {
    this.cpf = cpf;
    saveData();
  }

  Future<void> saveToken() async {
    final token = await FirebaseMessaging.instance.getToken();
    await FirebaseFirestore.instance
        .doc('users/$id')
        .collection('tokens')
        .doc(token)
        .set({
      'token': token,
      'updatedAt': FieldValue.serverTimestamp(),
      'platform': Platform.operatingSystem,
    });
  }

  Future<void> removeToken() async {
    final token = await FirebaseMessaging.instance.getToken();
    await FirebaseFirestore.instance
        .doc('users/$id')
        .collection('tokens')
        .doc(token)
        .delete();
  }
}
