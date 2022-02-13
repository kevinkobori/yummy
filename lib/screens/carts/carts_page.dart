import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yummy/components/custom_manager_app_bar.dart';
import 'package:yummy/components/menu_tile.dart';
import 'package:yummy/components/scroll_listener.dart';
import 'package:yummy/controllers/carts/cart_manager.dart';
import 'package:yummy/controllers/recipes/recipe.dart';
import 'package:yummy/controllers/user/user_manager.dart';
import 'package:yummy/screens/carts_cart/cart_screen.dart';
import 'package:yummy/screens/login/google_sign_in_screen.dart';

class CartsPage extends StatefulWidget {
  ScrollListener _model;
  final ScrollController _controller = ScrollController();

  CartsPage() {
    _model = ScrollListener.initialise(_controller);
  }

  @override
  _CartsPageState createState() => _CartsPageState();
}

class _CartsPageState extends State<CartsPage> {
  bool onSearchActive = false;

  @override
  void didChangeDependencies() {
    final CartManager cartManager = Provider.of(context, listen: false);
    cartManager.loadCarts();
    cartManager.search = '';
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final Recipe recipe = Provider.of(context, listen: false);
    return Consumer<UserManager>(
      builder: (_, userManager, __) {
        if (!userManager.isLoggedIn) {
          return GoogleSignInScreen();
        } else if (userManager.loading) {
          return const CircularProgressIndicator();
        } else {
          return Consumer<CartManager>(
            builder: (_, cartManager, __) {
              final filteredCarts = cartManager.filteredCarts;
              return Scaffold(
                appBar: PreferredSize(
                  preferredSize: Size(MediaQuery.of(context).size.width, 56),
                  child: CustomManagerAppBar(
                    manager: cartManager,
                    searchHintText: 'Pesquisar lista',
                    appBarTitle: Text('Minhas listas'),
                  ),
                ),
                extendBody: true,
                body: AnimatedBuilder(
                  animation: widget._model,
                  builder: (context, child) {
                    return Stack(
                      children: [
                        ListView.builder(
                          physics: const ClampingScrollPhysics(),
                          controller: widget._controller,
                          itemCount: filteredCarts.length,
                          itemBuilder: (_, index) {
                            return DelayedDisplay(
                              child: Padding(
                                padding: EdgeInsets.only(
                                  top: index == 0 ? 16.0 : 8.0,
                                  left: 16.0,
                                  bottom: 8.0,
                                  right: 16.0,
                                ),
                                child: MenuTile(
                                  dismissibleId:
                                      cartManager.filteredCarts[index].id,
                                  onDismissed: (_) {
                                    Provider.of<CartManager>(context,
                                            listen: false)
                                        .delete(
                                      recipeId:
                                          cartManager.filteredCarts[index].id,
                                      index: index,
                                    )
                                        .then((value) {
                                      cartManager.loadCarts();
                                      cartManager.search = '';
                                    });
                                  },
                                  endIcon: Icons.arrow_forward_ios,
                                  onEndIcon: () {},
                                  text:
                                      "${cartManager.filteredCarts[index].data()['recipeName']}",
                                  icon: Icons.view_list_rounded,
                                  label:
                                      "${cartManager.filteredCarts[index].data()['recipeName']}",
                                  width: 20,
                                  press: () async {
                                    await context
                                        .read<CartManager>()
                                        .loadCartItems(
                                            recipeId: cartManager
                                                .filteredCarts[index].id);
                                    print('lolol:>>' +
                                        cartManager.filteredCarts[index].id);
                                    await recipe.loadCurrentRecipe(
                                        cartManager.filteredCarts[index].id);
                                    print('lolol:>>' +
                                        cartManager.filteredCarts[index].id);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => CartScreen(),
                                      ),
                                    ).then((value) {
                                      cartManager.loadCarts();
                                      cartManager.search = '';
                                    });
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                      ],
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
