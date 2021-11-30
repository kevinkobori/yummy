import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'recipe.dart';

class RecipeManager extends ChangeNotifier {
  List<Recipe> recipeRecipe = [];

  String _search = '';

  String get search => _search;

  set search(String value) {
    _search = value;
    notifyListeners();
  }

  List<Recipe> get filteredRecipes {
    final List<Recipe> filteredRecipes = [];

    if (search.isEmpty) {
      filteredRecipes.addAll(recipeRecipe);
    } else {
      filteredRecipes.addAll(recipeRecipe.where((p) {
        if (p.name.toLowerCase().contains(search.toLowerCase())) {
          return true;
        } else {
          return false;
        }
      }));
    }

    return filteredRecipes;
  }

  Future<void> loadRecipes() async {
    final QuerySnapshot snapIngredients = await FirebaseFirestore.instance
        .collection('recipes')
        .where('deleted', isEqualTo: false)
        .get();

    recipeRecipe =
        snapIngredients.docs.map((d) => Recipe.fromDocument(d)).toList();

    notifyListeners();
  }

  Recipe findIngredientById(String id) {
    try {
      return recipeRecipe.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }

  void update(Recipe recipe) {
    recipeRecipe.removeWhere((p) => p.id == recipe.id);
    recipeRecipe.add(recipe);
    notifyListeners();
  }

  // void delete(BuildContext context, String recipeId) {
  //   final UserManager userManager = Provider.of(context, listen: false);
  //   final Recipe recipe = Provider.of(context, listen: false);

  //   recipe.delete(recipeId);
  //   recipeRecipe.removeWhere((p) => p.id == recipeId);
  //   userManager.removeRecipeAdmin(recipeId);
  //   notifyListeners();
  // }
  void delete(BuildContext context, String recipeId) {
    final Recipe recipe = Provider.of(context, listen: false);
    recipe.delete(recipeId);
    recipeRecipe.removeWhere((p) => p.id == recipeId);
    notifyListeners();
  }
}
