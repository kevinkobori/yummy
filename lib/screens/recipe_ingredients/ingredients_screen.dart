import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yummy/components/custom_manager_app_bar.dart';
import 'package:yummy/components/menu_tile.dart';
import 'package:yummy/components/scroll_listener.dart';
import 'package:yummy/components/yummy_bottom_search_app_bar_widget.dart';
import 'package:yummy/controllers/ingredients/ingredient.dart';
import 'package:yummy/screens/recipe_ingredient_brands/brands_screen.dart';
import 'package:yummy/utils/constants.dart';
import 'package:delayed_display/delayed_display.dart';
import '../../controllers/ingredients/ingredient_manager.dart';
import '../../controllers/recipes/recipe.dart';
import '../../controllers/user/user_manager.dart';
import '../recipe_edit_ingredient/edit_ingredient_screen.dart';

class RecipeIngredientsScreen extends StatefulWidget {
  ScrollListener _model;
  final ScrollController _controller = ScrollController();

  RecipeIngredientsScreen() {
    _model = ScrollListener.initialise(_controller);
  }
  @override
  _RecipeIngredientsScreenState createState() =>
      _RecipeIngredientsScreenState();
}

class _RecipeIngredientsScreenState extends State<RecipeIngredientsScreen> {
  bool onSearchActive = false;

  @override
  void didChangeDependencies() {
    final IngredientManager ingredientManager =
        Provider.of(context, listen: false);
    ingredientManager.search = '';
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final Recipe recipeProvider = Provider.of(context, listen: false);
    return Consumer<IngredientManager>(
      builder: (_, ingredientManager, __) {
        return Scaffold(
          appBar: PreferredSize(
            preferredSize: Size(MediaQuery.of(context).size.width, 56),
            child: CustomManagerAppBar(
              manager: ingredientManager,
              searchHintText: 'Pesquisar ingrediente',
              appBarTitle: Text(recipeProvider.name),
            ),
          ),
          body: AnimatedBuilder(
            animation: widget._model,
            builder: (context, child) {
              return Consumer<UserManager>(
                builder: (_, userManager, __) {
                  return Stack(
                    children: [
                      ingredientManager.filteredIngredients.isEmpty
                          ? ListView(
                              physics: const ClampingScrollPhysics(),
                              controller: widget._controller,
                              children: [
                                Container(
                                  margin:
                                      const EdgeInsets.fromLTRB(16, 8, 16, 8),
                                  padding:
                                      const EdgeInsets.fromLTRB(16, 8, 16, 16),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: AppColors.azulMarinhoEscuro),
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(15.0),
                                    ),
                                    color: const Color(0xFFF5F6F9),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Text(
                                        'Passos da receita:',
                                        style: TextStyle(
                                          color: AppColors.rosaClaro,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 16),
                                      Text(
                                        recipeProvider.description,
                                        style: TextStyle(
                                          color: AppColors.azulMarinhoEscuro,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin:
                                      const EdgeInsets.fromLTRB(16, 8, 16, 8),
                                  padding:
                                      const EdgeInsets.fromLTRB(16, 16, 16, 16),
                                  decoration: BoxDecoration(
                                    border:
                                        Border.all(color: AppColors.rosaClaro),
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(15.0),
                                    ),
                                    color: const Color(0xFFF5F6F9),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Text(
                                        'Lista de ingredientes:',
                                        style: TextStyle(
                                          color: AppColors.rosaClaro,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin:
                                      const EdgeInsets.fromLTRB(16, 8, 16, 8),
                                  padding:
                                      const EdgeInsets.fromLTRB(16, 16, 16, 16),
                                  decoration: BoxDecoration(
                                    border:
                                        Border.all(color: AppColors.azulClaro),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(15.0)),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Text(
                                        'Esta receita não contém ingredientes cadastrados.',
                                        style: TextStyle(
                                          color: AppColors.azulClaro,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          : ListView.builder(
                              itemCount:
                                  ingredientManager.filteredIngredients.length,
                              controller: widget._controller,
                              itemBuilder: (_, index) {
                                final Ingredient ingredient =
                                    Provider.of(context, listen: false);
                                if (index == 0)
                                  return Column(
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.fromLTRB(
                                            16, 8, 16, 8),
                                        padding: const EdgeInsets.fromLTRB(
                                            16, 8, 16, 16),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color:
                                                  AppColors.azulMarinhoEscuro),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(15.0)),
                                          color: const Color(0xFFF5F6F9),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: [
                                            Text(
                                              'Passos da receita:',
                                              style: TextStyle(
                                                color: AppColors.rosaClaro,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(height: 16),
                                            Text(
                                              recipeProvider.description,
                                              style: TextStyle(
                                                color:
                                                    AppColors.azulMarinhoEscuro,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.fromLTRB(
                                            16, 8, 16, 8),
                                        padding: const EdgeInsets.fromLTRB(
                                            16, 16, 16, 16),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: AppColors.rosaClaro),
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(15.0),
                                          ),
                                          color: const Color(0xFFF5F6F9),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: [
                                            Text(
                                              'Lista de ingredientes:',
                                              style: TextStyle(
                                                color: AppColors.rosaClaro,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      DelayedDisplay(
                                        delay:
                                            Duration(milliseconds: 200 * index),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                            top: 8.0,
                                            left: 16.0,
                                            bottom: 8.0,
                                            right: 16.0,
                                          ),
                                          child: MenuTile(
                                            endIcon: userManager.isLoggedIn &&
                                                    userManager
                                                        .adminEnabled(context)
                                                ? Icons.edit
                                                : Icons.arrow_forward_ios,
                                            onEndIcon: userManager.isLoggedIn &&
                                                    userManager
                                                        .adminEnabled(context)
                                                ? () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (_) =>
                                                            EditIngredientScreen(
                                                                ingredientManager
                                                                        .filteredIngredients[
                                                                    index]),
                                                      ),
                                                    );
                                                  }
                                                : () {
                                                    ingredient.setIngredient(
                                                        ingredientManager
                                                                .filteredIngredients[
                                                            index]);
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (_) =>
                                                            RecipeBrandsScreen(),
                                                      ),
                                                    );
                                                  },
                                            text: ingredientManager
                                                .filteredIngredients[index]
                                                .name,
                                            label: ingredientManager
                                                .filteredIngredients[index]
                                                .description,
                                            width: 20,
                                            press: () {
                                              ingredient.setIngredient(
                                                  ingredientManager
                                                          .filteredIngredients[
                                                      index]);
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (_) =>
                                                      RecipeBrandsScreen(),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                else
                                  return DelayedDisplay(
                                    delay: Duration(milliseconds: 200 * index),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                        top: 8.0,
                                        left: 16.0,
                                        bottom: 8.0,
                                        right: 16.0,
                                      ),
                                      child: MenuTile(
                                        endIcon: userManager.isLoggedIn &&
                                                userManager
                                                    .adminEnabled(context)
                                            ? Icons.edit
                                            : Icons.arrow_forward_ios,
                                        onEndIcon: userManager.isLoggedIn &&
                                                userManager
                                                    .adminEnabled(context)
                                            ? () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (_) =>
                                                        EditIngredientScreen(
                                                            ingredientManager
                                                                    .filteredIngredients[
                                                                index]),
                                                  ),
                                                );
                                              }
                                            : () {
                                                ingredient.setIngredient(
                                                    ingredientManager
                                                            .filteredIngredients[
                                                        index]);
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (_) =>
                                                        RecipeBrandsScreen(),
                                                  ),
                                                );
                                              },
                                        text: ingredientManager
                                            .filteredIngredients[index].name,
                                        label: ingredientManager
                                            .filteredIngredients[index]
                                            .description,
                                        width: 20,
                                        press: () {
                                          ingredient.setIngredient(
                                              ingredientManager
                                                  .filteredIngredients[index]);
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) =>
                                                  RecipeBrandsScreen(),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  );
                              },
                            ),
                      Consumer<UserManager>(
                        builder: (_, userManager, __) {
                          if (userManager.isLoggedIn &&
                              userManager.adminEnabled(context)) {
                            return Positioned(
                              right: 0,
                              bottom: widget._model.bottom,
                              child: DelayedDisplay(
                                delay: const Duration(milliseconds: 400),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: FloatingActionButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) =>
                                                EditIngredientScreen(null)),
                                      );
                                    },
                                    child: const Icon(Icons.add),
                                  ),
                                ),
                              ),
                            );
                          } else {
                            return Container();
                          }
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}
