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
                body: cartManager.items.isEmpty
                    ? const EmptyCard(
                        title: 'Sua lista está vazia',
                        icon: Icon(Icons.error),
                      )
                    : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView.builder(
                          physics: const ClampingScrollPhysics(),
                          itemCount: cartManager.items.length,
                          itemBuilder: (_, index) {
                            return cartManager.items.length - 1 == index
                                ? Column(
                                    children: [
                                      DelayedDisplay(
                                        delay: const Duration(milliseconds: 400),
                                        child: CartTile(
                                            cartManager.items[index], true),
                                      ),
                                      Divider(
                                        color: AppColors.azulMarinhoEscuro,
                                        thickness: 1,
                                      ),
                                      DelayedDisplay(
                                        delay: const Duration(milliseconds: 800),
                                        slidingBeginOffset:
                                            const Offset(0.20, 0.0),
                                        child: PriceCard(
                                          cartManager: cartManager,
                                        ),
                                      ),
                                      Divider(
                                        color: AppColors.azulMarinhoEscuro,
                                        thickness: 1,
                                      ),
                                    ],
                                  )
                                : Column(
                                    children: [
                                      DelayedDisplay(
                                        delay: const Duration(milliseconds: 400),
                                        child: CartTile(
                                            cartManager.items[index], true),
                                      ),
                                      Divider(
                                        color: AppColors.azulMarinhoEscuro,
                                        thickness: 1,
                                      ),
                                    ],
                                  );
                          },
                        ),
                    ),
              );
            },
          );
        }
      },
    );
  }
}
