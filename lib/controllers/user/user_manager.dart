import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

import '../../helpers/firebase_errors.dart';
import '../recipes/recipe.dart';
import 'user_model.dart';

class UserManager extends ChangeNotifier {
  UserManager() {
    loadCurrentUser();
  }

  UserModel user;

  final GoogleSignIn googleSignIn = GoogleSignIn();

  bool _loading = false;
  bool get loading => _loading;
  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }

  bool _loadingFace = false;
  bool get loadingFace => _loadingFace;
  set loadingFace(bool value) {
    _loadingFace = value;
    notifyListeners();
  }

  bool get isLoggedIn => user != null;

  Future<void> signIn(BuildContext context) async {
    final googleUser = await googleSignIn.signIn();

    if (googleUser == null) {
      return;
    } else {
      _loading = true;
      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential result =
          await FirebaseAuth.instance.signInWithCredential(credential);

      if (result.additionalUserInfo.isNewUser) {
        UserModel userModel = new UserModel();
        userModel.id = result.user.uid;
        this.user = userModel;

        const _chars =
            'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
        Random _rnd = Random();

        String getRandomString(int length) => String.fromCharCodes(
              Iterable.generate(
                length,
                (_) => _chars.codeUnitAt(
                  _rnd.nextInt(_chars.length),
                ),
              ),
            );

        userModel.name = result.user.displayName;
        userModel.email = result.user.email;
        userModel.code = getRandomString(28);
        userModel.password = '';
        userModel.recipesAdmin = [];
        userModel.cpf = '';
        userModel.imageProfile = result.user.photoURL;

        await userModel.saveData();

        userModel.saveToken();
      } else {
        await loadCurrentUser();
      }

      _loading = false;
    }
    notifyListeners();
  }

  Future<void> signOut() async {
    FirebaseAuth.instance.signOut();

    user.removeToken();
    user = null;
    notifyListeners();
  }

  Future<void> signUp(
      {UserModel userModel, Function onFail, Function onSuccess}) async {
    loading = true;
    try {
      final UserCredential result = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: user.email, password: user.password);

      userModel.id = result.user.uid;
      this.user = userModel;

      await userModel.saveData();

      userModel.saveToken();

      onSuccess();
    } on PlatformException catch (e) {
      onFail(getErrorString(e.code));
    }
    loading = false;
  }

  Future<void> loadCurrentUser() async {
    if (FirebaseAuth.instance.currentUser != null) {
      final DocumentSnapshot docUser = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser.uid)
          .get();
      user = UserModel.fromDocument(docUser);

      user.saveToken();

      notifyListeners();
    }
  }

  Future<void> removeRecipeAdmin(String recipeId) async {
    final int index = user.recipesAdmin.indexWhere((e) {
      return e['recipeId'].toString() == recipeId.toString();
    });

    user.recipesAdmin.removeAt(index);
    await FirebaseFirestore.instance
        .doc('users/${user.id}')
        .update(user.toMap());
    notifyListeners();
  }

  bool adminEnabled(BuildContext context) {
    final Recipe recipeProvider = Provider.of(context, listen: false);
    return user.recipesAdminIds.contains(recipeProvider.id);
  }

  String _search = '';

  String get search => _search;

  set search(String value) {
    _search = value;
    notifyListeners();
  }

  List<dynamic> get filteredRecipesAdmin {
    final List<dynamic> filteredRecipesAdmin = [];

    if (search.isEmpty) {
      filteredRecipesAdmin.addAll(user.recipesAdmin);
    } else {
      filteredRecipesAdmin.addAll(user.recipesAdmin.where((p) {
        final String recipeName = p['recipeName'] as String;
        if (recipeName.toLowerCase().contains(search.toLowerCase())) {
          return true;
        } else {
          return false;
        }
      }));
    }

    return filteredRecipesAdmin;
  }
}
