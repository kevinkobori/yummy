import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yummy/components/custom_manager_app_bar.dart';
import 'package:yummy/components/menu_tile.dart';
import 'package:yummy/components/scroll_listener.dart';
import 'package:yummy/components/yummy_bottom_search_app_bar_widget.dart';
import 'package:yummy/controllers/recipes/recipe.dart';
import 'package:yummy/controllers/recipes/recipe_manager.dart';
import 'package:yummy/controllers/user/user_manager.dart';
import 'package:yummy/screens/recipe_edit_recipe/edit_recipe_screen.dart';
import 'package:yummy/screens/recipes_manager/recipe_manager_page.dart';
import 'package:yummy/screens/login/google_sign_in_screen.dart';

class RecipesManagerPage extends StatefulWidget {
  ScrollListener _model;
  final ScrollController _controller = ScrollController();

  RecipesManagerPage() {
    _model = ScrollListener.initialise(_controller);
  }

  @override
  _RecipesManagerPageState createState() => _RecipesManagerPageState();
}

class _RecipesManagerPageState extends State<RecipesManagerPage> {
  bool onSearchActive = false;
  @override
  Widget build(BuildContext context) {
    return Consumer<UserManager>(builder: (_, userManager, __) {
      if (!userManager.isLoggedIn) {
        return GoogleSignInScreen();
      } else if (userManager.loading) {
        return const CircularProgressIndicator();
      } else {
        return Scaffold(
          appBar: PreferredSize(
            preferredSize: Size(MediaQuery.of(context).size.width, 56),
            child: CustomManagerAppBar(
              manager: userManager,
              searchHintText: 'Pesquisar ingrediente',
              appBarTitle: 'Minhas Receitas',
            ),
          ),
          extendBody: true,
          body: AnimatedBuilder(
            animation: widget._model,
            builder: (context, child) {
              return Stack(
                children: userManager.filteredRecipesAdmin == null
                    ? []
                    : [
                        ListView.builder(
                          physics: const ClampingScrollPhysics(),
                          controller: widget._controller,
                          itemCount: userManager.filteredRecipesAdmin.length,
                          itemBuilder: (_, index) {
                            return Consumer<Recipe>(
                              builder: (_, recipe, __) {
                                return DelayedDisplay(
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                      top: index == 0 ? 16.0 : 8.0,
                                      left: 16.0,
                                      bottom: 8.0,
                                      right: 16.0,
                                    ),
                                    child: MenuTile(
                                      dismissibleId: userManager
                                              .filteredRecipesAdmin[index]
                                          ['recipeId'] as String,
                                      onDismissed: (_) {
                                        Provider.of<RecipeManager>(context,
                                                listen: false)
                                            .delete(
                                                context,
                                                userManager.filteredRecipesAdmin[
                                                        index]['recipeId']
                                                    as String);
                                      },
                                      endIcon: Icons.arrow_forward_ios,
                                      text:
                                          "${userManager.filteredRecipesAdmin[index]['recipeName']}",
                                      icon: Icons.menu_book_rounded,
                                      label: 'Perfil',
                                      width: 20,
                                      press: () async {
                                        await recipe.loadCurrentRecipe(
                                            userManager
                                                    .filteredRecipesAdmin[index]
                                                ['recipeId'] as String);
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) {
                                              return RecipeManagerPage();
                                            },
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                        if (userManager.isLoggedIn == true)
                          Positioned(
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
                                              EditRecipeScreen(null)),
                                    ).then((_) {
                                      userManager.loadCurrentUser();
                                    });
                                  },
                                  child: const Icon(Icons.add),
                                ),
                              ),
                            ),
                          )
                        else
                          Container()
                      ],
              );
            },
          ),
        );
      }
    });
  }
}
