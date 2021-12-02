import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yummy/controllers/recipes/recipe_manager.dart';
import 'package:yummy/screens/recipe_edit_recipe/edit_recipe_screen.dart';
import 'package:yummy/utils/constants.dart';

import '../../../controllers/ingredients/ingredient_manager.dart';
import '../../../controllers/recipes/recipe.dart';
import '../../../controllers/user/user_manager.dart';
import '../../recipe_ingredients/ingredients_screen.dart';

class RecipeGridItem extends StatefulWidget {
  final Recipe recipe;
  const RecipeGridItem(this.recipe);

  @override
  _RecipeGridItemState createState() => _RecipeGridItemState();
}

class _RecipeGridItemState extends State<RecipeGridItem> {
  @override
  Widget build(BuildContext context) {
    final Recipe recipeProvider = Provider.of(context, listen: false);
    recipeProvider.setRecipe(widget.recipe);
    final Recipe recipe = Provider.of(context, listen: false);
    return Consumer<UserManager>(
      builder: (_, userManager, __) {
        return GestureDetector(
          onTap: () async {
            recipe.setRecipe(widget.recipe);
            final IngredientManager ingredientManager =
                Provider.of(context, listen: false);
            await ingredientManager.loadRecipeIngredients(widget.recipe.id);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => RecipeIngredientsScreen(),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.fromLTRB(6.0, 6.0, 6.0, 6.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                padding: const EdgeInsets.fromLTRB(6.0, 6.0, 6.0, 0.0),
                color: Colors.grey[200],
                child: Column(
                  children: [
                    AspectRatio(
                      aspectRatio: 1,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: Image.network(
                          widget.recipe.images[0],
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                          child: LayoutBuilder(
                            builder: (context, size) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: <Widget>[
                                  const SizedBox(height: 4),
                                  Text(
                                    widget.recipe.name,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      color: AppColors.rosaClaro,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                        Positioned(
                          top: 4,
                          right: 4,
                          child: userManager.isLoggedIn &&
                                  userManager.adminEnabled(context)
                              ? SizedBox(
                                  height: 18.0,
                                  width: 18.0,
                                  child: IconButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              EditRecipeScreen(widget.recipe),
                                        ),
                                      ).then((_) {
                                        final RecipeManager recipeManager =
                                            Provider.of(context, listen: false);
                                        recipeManager.loadRecipes();
                                        recipeManager.search = '';
                                      });
                                    },
                                    padding: const EdgeInsets.all(0.0),
                                    icon: const Icon(Icons.edit, size: 16),
                                  ),
                                )
                              : Container(),
                        ),
                      ],
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
