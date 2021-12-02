import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:uuid/uuid.dart';

import '../brands/brand_size.dart';
import '../user/user_manager.dart';

class Recipe extends ChangeNotifier {
  Recipe(
      {this.id,
      this.name,
      this.description,
      this.images,
      this.autoplay,
      this.type,
      this.whats,
      this.deleted = false}) {
    images = images ?? [];
  }

  Recipe.fromDocument(DocumentSnapshot doc) {
    id = doc.id;
    name = doc['name'] as String;
    whats = doc['whats'] as String;
    description = doc['description'] as String;
    images = List<String>.from(doc.data()['images'] as List<dynamic>);
    autoplay = doc['autoplay'] as bool;
    type = doc['type'] as double;
    deleted = (doc.data()['deleted'] ?? false) as bool;
  }

  Future<void> loadCurrentRecipe(String recipeId) async {
    final DocumentSnapshot docRecipe = await FirebaseFirestore.instance
        .collection('recipes')
        .doc(recipeId)
        .get();

    setRecipe(Recipe.fromDocument(docRecipe));

    notifyListeners();
  }

  String id;
  String name;
  String whats;
  String description;
  List<String> images;
  bool autoplay;
  double type;
  List<dynamic> newImages;

  bool deleted;

  bool _loading = false;
  bool get loading => _loading;
  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }

  BrandSize _selectedSize;
  BrandSize get selectedSize => _selectedSize;
  set selectedSize(BrandSize value) {
    _selectedSize = value;
    notifyListeners();
  }

  void setRecipe(Recipe recipe) {
    id = recipe.id;
    name = recipe.name;
    whats = recipe.whats;
    description = recipe.description;
    images = recipe.images;
    autoplay = recipe.autoplay;
    type = recipe.type;
  }

  Future<void> firestoreAdd(UserManager userManager) async {
    loading = true;

    final Map<String, dynamic> data = {
      'name': name,
      'whats': '+5561991200684',
      'description': description,
      'autoplay': false,
      'type': 0.1,
      'deleted': deleted
    };

    if (id == null) {
      final Map<String, dynamic> delivery = {
        'base': 5,
        'km': 0.7,
        'lat': -15.853906638336642,
        'lng': -47.859486883810796,
        'maxkm': 200,
      };
      final Map<String, dynamic> orderCounter = {
        'current': 0,
      };
      final docRef =
          await FirebaseFirestore.instance.collection('recipes').add(data);
      await FirebaseFirestore.instance
          .doc(docRef.path)
          .collection('delivery')
          .add(delivery);
      await FirebaseFirestore.instance
          .doc(docRef.path)
          .collection('orderCounter')
          .add(orderCounter);

      id = docRef.id;
      userManager.user.setRecipesAdmin(
        recipeId: id,
        recipeName: data['name'].toString(),
        recipeExists: false,
        recipeDeleted: false,
      );
    } else {
      await FirebaseFirestore.instance.doc('recipes/$id').update(data);
      userManager.user.setRecipesAdmin(
        recipeId: id,
        recipeName: data['name'].toString(),
        recipeExists: true,
        recipeDeleted: false,
      );
    }

    final List<String> updateImages = [];

    for (final newImage in newImages) {
      if (images.contains(newImage)) {
        updateImages.add(newImage as String);
      } else {
        final UploadTask task = FirebaseStorage.instance
            .ref()
            .child('recipes')
            .child(id)
            .child(const Uuid().v1())
            .putFile(newImage as File);
        final TaskSnapshot snapshot = await task.whenComplete(() => null);
        final String url = await snapshot.ref.getDownloadURL();
        updateImages.add(url);
      }
    }

    for (final image in images) {
      if (!newImages.contains(image) && image.contains('firebase')) {
        try {
          final ref = FirebaseStorage.instance.refFromURL(image);
          await ref.delete();
        } catch (e) {
          debugPrint('Falha ao deletar $image');
        }
      }
    }

    await FirebaseFirestore.instance
        .doc('recipes/$id')
        .update({'images': updateImages});

    images = updateImages;

    loading = false;
  }

  void delete(String recipeId) {
    FirebaseFirestore.instance
        .doc('recipes/$recipeId')
        .update({'deleted': true});
  }

  Recipe clone() {
    return Recipe(
      id: id,
      name: name,
      description: description,
      whats: whats,
      images: List.from(images),
      autoplay: autoplay,
      type: 0.1, //type,
      deleted: deleted,
    );
  }

  @override
  String toString() {
    return 'Recipe{id: $id, name: $name, description: $description, images: $images, newImages: $newImages, autoplay: $autoplay, type: $type}';
  }
}
