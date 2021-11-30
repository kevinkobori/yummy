import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yummy/components/scroll_listener.dart';
import 'package:yummy/components/yummy_bottom_search_app_bar_widget.dart';

import '../../controllers/ingredients/ingredient.dart';
import '../../controllers/recipes/recipe.dart';
import '../../controllers/brands/brand_manager.dart';
import '../../controllers/user/user_manager.dart';
import '../recipe_edit_brand/edit_brand_screen.dart';
import 'components/brand_grid_item.dart';

class RecipeBrandsScreen extends StatefulWidget {
  ScrollListener _model;
  final ScrollController _controller = ScrollController();

  RecipeBrandsScreen() {
    _model = ScrollListener.initialise(_controller);
  }
  @override
  _RecipeBrandsScreenState createState() => _RecipeBrandsScreenState();
}

class _RecipeBrandsScreenState extends State<RecipeBrandsScreen> {
  bool onSearchActive = false;
  @override
  void initState() {
    final BrandManager brandManager = Provider.of(context, listen: false);
    brandManager.search = '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Ingredient ingredient = Provider.of(context);
    final Recipe recipe = Provider.of(context, listen: false);
    Future<void> _loadPageData() async {
      final BrandManager brandManagerFunc = Provider.of(context, listen: false);

      await brandManagerFunc.loadRecipeIngredientBrands(
          recipe.id, ingredient.id);
    }

    return FutureBuilder(
      future: _loadPageData(),
      builder: (BuildContext context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return const Scaffold(
              body: Center(
                child: Text('Volte a página e tente novamente'),
              ),
            );
          case ConnectionState.waiting:
            return const Scaffold(
              backgroundColor: Colors.transparent,
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          default:
            if (snapshot.hasError)
              return Text('Erro: ${snapshot.error}');
            else
              return Consumer<BrandManager>(
                builder: (_, brandManager, __) {
                  final filteredBrands = brandManager.filteredBrands;
                  return Scaffold(
                    appBar: AppBar(
                      title: onSearchActive
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                YummyBottomSearchAppBarWidget(
                                  object: brandManager,
                                  hintText: 'Pesquisar marca',
                                  onClose: () {
                                    setState(() {
                                      onSearchActive = !onSearchActive;
                                    });
                                  },
                                ),
                              ],
                            )
                          : const Text('Produtos / Marcas'),
                      actions: onSearchActive == true
                          ? [
                              Container(),
                              Consumer<UserManager>(
                                builder: (_, userManager, __) {
                                  if (userManager.isLoggedIn &&
                                      userManager.adminEnabled(context)) {
                                    return IconButton(
                                      icon: const Icon(Icons.add),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) =>
                                                  EditBrandScreen(null)),
                                        );
                                      },
                                    );
                                  } else {
                                    return Container();
                                  }
                                },
                              ),
                            ]
                          : [
                              IconButton(
                                icon: const Icon(
                                  Icons.search,
                                ),
                                onPressed: () {
                                  setState(() {
                                    onSearchActive = !onSearchActive;
                                  });
                                },
                              ),
                              Consumer<UserManager>(
                                builder: (_, userManager, __) {
                                  if (userManager.isLoggedIn &&
                                      userManager.adminEnabled(context)) {
                                    return IconButton(
                                      icon: const Icon(Icons.add),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) =>
                                                  EditBrandScreen(null)),
                                        );
                                      },
                                    );
                                  } else {
                                    return Container();
                                  }
                                },
                              ),
                            ],
                    ),
                    body: AnimatedBuilder(
                      animation: widget._model,
                      builder: (context, child) {
                        return ListView.builder(
                          physics: const ClampingScrollPhysics(),
                          controller: widget._controller,
                          itemCount: filteredBrands.length,
                          itemBuilder: (_, index) => Padding(
                            padding: EdgeInsets.only(
                              top: index == 0 ? 16.0 : 8.0,
                              left: 16.0,
                              bottom: 8.0,
                              right: 16.0,
                            ),
                            child: BrandGridItem(
                              filteredBrands[index],
                              'store',
                              ingredient.id,
                              ingredient.name,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
        }
      },
    );
  }
}
