import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../controllers/ingredients/ingredient.dart';
import '../../../controllers/user/user_manager.dart';
import '../../recipe_ingredient_brands/brands_screen.dart';
import '../../recipe_edit_ingredient/edit_ingredient_screen.dart';

class IngredientGridItem extends StatefulWidget {
  final Ingredient ingredient;
  final String pageType;
  const IngredientGridItem(this.ingredient, this.pageType);

  @override
  _IngredientGridItemState createState() => _IngredientGridItemState();
}

class _IngredientGridItemState extends State<IngredientGridItem> {
  @override
  Widget build(BuildContext context) {
    final Ingredient ingredient = Provider.of(context, listen: false);

    return GestureDetector(
      onTap: () {
        ingredient.setIngredient(widget.ingredient);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => RecipeBrandsScreen(),
          ),
        );
      },
      child: Container(
        height: 400,
        width: 400,
        color: Colors.pink,
        child: Column(
          children: [
            Consumer<UserManager>(
              builder: (_, userManager, __) {
                return Stack(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          left: 16.0,
                          right: userManager.isLoggedIn &&
                                  userManager.adminEnabled(context)
                              ? 44.0
                              : 16.0),
                      child: LayoutBuilder(
                        builder: (context, size) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              const SizedBox(height: 4),
                              Text(
                                widget.ingredient.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
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
                      bottom: 0,
                      right: 8,
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
                                      builder: (_) => EditIngredientScreen(
                                          widget.ingredient),
                                    ),
                                  );
                                },
                                padding: const EdgeInsets.all(0.0),
                                icon: const Icon(
                                  Icons.edit,
                                  size: 16,
                                ),
                              ),
                            )
                          : Container(),
                    ),
                  ],
                );
              },
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
