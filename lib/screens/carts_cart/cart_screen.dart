import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yummy/utils/constants.dart';

import '../../components/empty_card.dart';
import '../../components/price_card.dart';
import '../../controllers/carts/cart_manager.dart';
import '../../controllers/recipes/recipe.dart';
import '../../controllers/user/user_manager.dart';
import '../../screens/carts_cart/components/cart_tile.dart';
import '../../screens/login/google_sign_in_screen.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Recipe recipeProvider = Provider.of(context, listen: false);
    return Consumer<UserManager>(
      builder: (_, userManager, __) {
        if (!userManager.isLoggedIn) {
          return GoogleSignInScreen();
        } else if (userManager.loading) {
          return const CircularProgressIndicator();
        } else {
          return Consumer<CartManager>(
            builder: (_, cartManager, __) {
              return Scaffold(
                appBar: AppBar(
                  title: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            "Lista / ${recipeProvider.name}",
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const SizedBox(width: 2),
                          Text(
                            cartManager.items.length == 1
                                ? '${cartManager.items.length} ingrediente'
                                : '${cartManager.items.length} ingredientes',
                            style: Theme.of(context).textTheme.caption,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                body: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: cartManager.items.isEmpty
                          ? const EmptyCard(
                              title: 'Sua lista está vazia',
                              icon: Icon(Icons.error),
                            )
                          : SafeArea(
                              child: Container(
                                margin: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10),
                                      bottomLeft: Radius.circular(10),
                                      bottomRight: Radius.circular(10)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.azulClaro,
                                      spreadRadius: 1,
                                      blurRadius: 2,
                                    ),
                                  ],
                                ),
                                child: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Column(
                                        children: cartManager.items
                                            .map(
                                              (cartBrand) => DelayedDisplay(
                                                  delay: const Duration(
                                                      milliseconds: 400),
                                                  child: CartTile(
                                                      cartBrand, true)),
                                            )
                                            .toList(),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.all(16),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: const BorderRadius.only(
                                              topLeft: Radius.circular(10),
                                              topRight: Radius.circular(10),
                                              bottomLeft: Radius.circular(10),
                                              bottomRight: Radius.circular(10)),
                                          boxShadow: [
                                            BoxShadow(
                                              color: AppColors.azulClaro,
                                              spreadRadius: 1,
                                              blurRadius: 2,
                                            ),
                                          ],
                                        ),
                                        child: DelayedDisplay(
                                          delay:
                                              const Duration(milliseconds: 800),
                                          slidingBeginOffset:
                                              const Offset(0.20, 0.0),
                                          child: PriceCard(
                                            cartManager: cartManager,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                    ),
                  ],
                ),
              );
            },
          );
        }
      },
    );
  }
}
