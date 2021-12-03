import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import '../brands/brand_size.dart';

class Ingredient extends ChangeNotifier {
  Ingredient({
    this.id,
    this.name,
    this.description,
    this.type,
    this.recipeId,
    this.recipeName,
    this.autoplay,
    this.deleted = false,
  });

  Ingredient.fromDocument(DocumentSnapshot doc) {
    id = doc.id;
    name = doc['name'] as String;
    type = doc['type'] as double;
    recipeId = doc['recipeId'] as String;
    recipeName = doc['recipeName'] as String;
    description = doc['description'] as String;
    autoplay = doc['autoplay'] as bool;
    deleted = (doc.data()['deleted'] ?? false) as bool;
  }

  String id;
  String name;
  double type;
  String recipeId;
  String recipeName;
  String description;
  bool autoplay;

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

  void setIngredient(Ingredient ingredient) {
    id = ingredient.id;
    name = ingredient.name;
    type = ingredient.type;
    recipeId = ingredient.recipeId;
    recipeName = ingredient.recipeName;
    description = ingredient.description;
    autoplay = ingredient.autoplay;
  }

  Future<void> save(String recipeId, String recipeName) async {
    loading = true;

    final Map<String, dynamic> data = {
      'recipeId': recipeId,
      'recipeName': recipeName,
      'name': name,
      'type': 0.1,
      'description': description,
      'autoplay': autoplay,
      'deleted': deleted
    };

    if (id == null) {
      final docRef = await FirebaseFirestore.instance
          .collection('recipes')
          .doc(recipeId)
          .collection('ingredients')
          .add(data);
      id = docRef.id;
    } else {
      await FirebaseFirestore.instance
          .doc('recipes/$recipeId/ingredients/$id')
          .update(data);
    }

    loading = false;
  }

  void delete() {
    FirebaseFirestore.instance
        .doc('recipes/$recipeId/ingredients/$id')
        .update({'deleted': true});
    FirebaseFirestore.instance
        .collection('allIngredients')
        .doc('0.1') //'$type')
        .collection('allBrands')
        .doc(id)
        .update({'deleted': true});
  }

  Ingredient clone() {
    return Ingredient(
      id: id,
      name: name,
      recipeId: recipeId,
      recipeName: recipeName,
      description: description,
      type: type,
      autoplay: autoplay,
      deleted: deleted,
    );
  }

  @override
  String toString() {
    return 'Ingredient{id: $id, recipeId: $recipeId, recipeName: $recipeName, name: $name, description: $description, type: $type, autoplay: $autoplay}';
  }
}
