import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yummy/components/custom_manager_app_bar.dart';

import 'package:yummy/components/yummy_app_bar_widget.dart';
import 'package:yummy/components/yummy_bottom_search_app_bar_widget.dart';
import 'package:yummy/controllers/recipes/recipe_manager.dart';
import 'package:yummy/screens/recipes/components/recipe_grid_item.dart';
import 'package:yummy/utils/constants.dart';

import '../../components/scroll_listener.dart';
import 'package:delayed_display/delayed_display.dart';

class RecipesScreen extends StatefulWidget {
  ScrollListener _model;
  final ScrollController _controller = ScrollController();

  RecipesScreen() {
    _model = ScrollListener.initialise(_controller);
  }

  @override
  _RecipesScreenState createState() => _RecipesScreenState();
}

class _RecipesScreenState extends State<RecipesScreen> {
  bool onSearchActive = false;

  @override
  void didChangeDependencies() {
    final RecipeManager recipeManager = Provider.of(context, listen: false);
    recipeManager.loadRecipes();
    recipeManager.search = '';
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RecipeManager>(
      builder: (_, recipeManager, __) {
        final filteredRecipes = recipeManager.filteredRecipes;
        return Scaffold(
          appBar: PreferredSize(
            preferredSize: Size(MediaQuery.of(context).size.width, 56),
            child: CustomManagerAppBar(
              manager: recipeManager,
              searchHintText: 'Pesquisar receita',
              appBarTitle: 'Yummy',
            ),
          ),
          extendBody: true,
          body: AnimatedBuilder(
            animation: widget._model,
            builder: (context, child) {
              return GridView.builder(
                physics: const ClampingScrollPhysics(),
                controller: widget._controller,
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200,
                  childAspectRatio: 0.90,
                ),
                itemCount: filteredRecipes.length,
                itemBuilder: (_, index) => DelayedDisplay(
                  delay: Duration(milliseconds: index % 2 == 0 ? 0 : 200),
                  child: Padding(
                      padding: EdgeInsets.fromLTRB(
                        index % 2 == 0 ? 12 : 6,
                        index % 2 == 0 ? 6 : 6,
                        index % 2 == 0 ? 6 : 12,
                        index % 2 == 0 ? 6 : 6,
                      ),
                      child: RecipeGridItem(filteredRecipes[index])),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
