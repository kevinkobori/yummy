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
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Stack(
              children: [
                AspectRatio(
                  aspectRatio: 0.88,
                  child: Image.network(
                    widget.recipe.images[0],
                    fit: BoxFit.cover,
                  ),
                ),
                AspectRatio(
                  aspectRatio: 0.88,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: [
                          0.0,
                          0.3,
                        ],
                        colors: [
                          Colors.black.withOpacity(0.8),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 6, 12, 6),
                  child: Text(
                    widget.recipe.name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Colors.white, // AppColors.rosaClaro,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
        );
      },
    );
  }
}
