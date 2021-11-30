import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yummy/controllers/recipes/recipe_manager.dart';
import 'package:yummy/controllers/user/user_manager.dart';

import '../../components/menu_tile.dart';
import '../../controllers/ingredients/ingredient_manager.dart';
import '../../controllers/recipes/recipe.dart';
import '../recipe_ingredients/ingredients_screen.dart';
import '../recipe_edit_recipe/edit_recipe_screen.dart';

class RecipeManagerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Recipe recipe = Provider.of(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(left: 4.0),
          child: Text(
            recipe.name,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.edit,
              size: 18,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => EditRecipeScreen(recipe)),
              ).then((_) async {
                final Recipe recipeProvider =
                    Provider.of(context, listen: false);
                await recipeProvider.loadCurrentRecipe(recipe.id);
              });
            },
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: AspectRatio(
              aspectRatio: 1.1,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(11),
                  child: Image.network(
                    recipe.images[0],
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(
                top: 16.0,
                left: 16.0,
                bottom: 8.0,
                right: 16.0,
              ),
              child: MenuTile(
                dismissibleId: recipe.id,
                onDismissed: (_) {
                  Provider.of<RecipeManager>(context, listen: false)
                      .delete(context, recipe.id);
                },
                endIcon: Icons.arrow_forward_ios,
                onEndIcon: () {},
                text: "Ingredientes da Receita",
                icon: Icons.menu_book_rounded,
                label: 'Ingredientes',
                width: 20,
                press: () async {
                  recipe.setRecipe(recipe);
                  final IngredientManager ingredientManager =
                      Provider.of(context, listen: false);
                  await ingredientManager.loadRecipeIngredients(recipe.id);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => RecipeIngredientsScreen()),
                  ).then((_) {
                    final UserManager userManager =
                        Provider.of(context, listen: false);
                    userManager.loadCurrentUser();
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
