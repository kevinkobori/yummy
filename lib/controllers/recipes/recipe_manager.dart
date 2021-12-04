import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:yummy/controllers/user/user_manager.dart';
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
      filteredRecipes.addAll(recipeRecipe.where((recipe) {
        if (recipe.name.toLowerCase().contains(search.toLowerCase())) {
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

  void delete({BuildContext context, String recipeId, String recipeName}) {
    final Recipe recipe = Provider.of(context, listen: false);
    final UserManager userManager = Provider.of(context, listen: false);
    recipe.delete(recipeId: recipeId);
    userManager.user.deleteRecipeAdmin(recipeId: recipeId);
    // userManager.user.setRecipesAdmin(
    //   recipeId: recipeId,
    //   recipeName: recipeName,
    //   recipeExists: true,
    //   recipeDeleted: true,
    // );
    recipeRecipe.removeWhere((p) => p.id == recipe.id);
    notifyListeners();
  }
}
