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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: 1,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    widget.recipe.images[0],
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(
                height: 4,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 2.0, right: 2.0),
                child: Text(
                  widget.recipe.name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: AppColors.azulMarinhoEscuro,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              const Spacer(),
            ],
          ),
        );
      },
    );
  }
}
