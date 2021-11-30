import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'ingredient.dart';

class IngredientManager extends ChangeNotifier {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  List<Ingredient> recipeIngredients = [];

  String _search = '';

  String get search => _search;
  set search(String value) {
    _search = value;
    notifyListeners();
  }

  List<Ingredient> get filteredIngredients {
    final List<Ingredient> filteredIngredients = [];

    if (search.isEmpty) {
      filteredIngredients.addAll(recipeIngredients);
    } else {
      filteredIngredients.addAll(recipeIngredients.where((p) {
        if (p.name.toLowerCase().contains(search.toLowerCase())) {
          return true;
        } else {
          return false;
        }
      }));
    }

    return filteredIngredients;
  }

  Future<void> loadRecipeIngredients(String recipeId) async {
    final QuerySnapshot snapIngredients = await firestore
        .collection('recipes')
        .doc(recipeId)
        .collection('ingredients')
        .where('deleted', isEqualTo: false)
        .get();

    recipeIngredients =
        snapIngredients.docs.map((d) => Ingredient.fromDocument(d)).toList();

    notifyListeners();
  }

  Ingredient findIngredientById(String id) {
    try {
      return recipeIngredients.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }

  void update(Ingredient ingredient) {
    recipeIngredients.removeWhere((p) => p.id == ingredient.id);
    recipeIngredients.add(ingredient);
    notifyListeners();
  }

  void delete(Ingredient ingredient) {
    ingredient.delete();
    recipeIngredients.removeWhere((p) => p.id == ingredient.id);
    notifyListeners();
  }
}
