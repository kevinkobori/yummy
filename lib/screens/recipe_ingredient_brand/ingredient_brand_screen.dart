import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../controllers/brands/brand.dart';
import '../../controllers/carts/cart_manager.dart';
import '../../controllers/recipes/recipe.dart';
import '../../controllers/user/user_manager.dart';
import '../carts_cart/cart_screen.dart';
import '../login/google_sign_in_screen.dart';
import '../recipe_edit_brand/edit_brand_screen.dart';
import 'components/size_widget.dart';

class BrandScreen extends StatelessWidget {
  const BrandScreen({
    @required this.brand,
    @required this.fromCartNavigation,
  });

  final Brand brand;

  final bool fromCartNavigation;

  @override
  Widget build(BuildContext context) {
    final Recipe recipe = Provider.of(context, listen: false);
    final NumberFormat formatter = NumberFormat.simpleCurrency(locale: 'pt_BR');
    final brandsPriceFixed = double.parse(brand.basePrice.toStringAsFixed(2));
    final brandsPrice = formatter.format(brandsPriceFixed);
    return ChangeNotifierProvider.value(
      value: brand,
      child: Scaffold(
        appBar: AppBar(
          title: Text(recipe.name),
          actions: <Widget>[
            Consumer<UserManager>(
              builder: (_, userManager, __) {
                if (userManager.isLoggedIn &&
                    userManager.adminEnabled(context) &&
                    !brand.deleted) {
                  return IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditBrandScreen(brand),
                        ),
                      );
                    },
                  );
                } else {
                  return Container();
                }
              },
            )
          ],
        ),
        body: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  DelayedDisplay(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Text(
                        'Produto',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                  DelayedDisplay(
                    delay: const Duration(milliseconds: 200),
                    child: Text(
                      brand.name,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  DelayedDisplay(
                    delay: const Duration(milliseconds: 400),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Text(
                        'A partir de',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                  DelayedDisplay(
                    delay: const Duration(milliseconds: 600),
                    child: Text(
                      brandsPrice,
                      style: TextStyle(
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).accentColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (brand.deleted)
                    const Padding(
                      padding: EdgeInsets.only(top: 16, bottom: 8),
                      child: Text(
                        'Esta marca não está mais disponível',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.red),
                      ),
                    )
                  else ...[
                    const DelayedDisplay(
                      delay: Duration(milliseconds: 800),
                      child: Padding(
                        padding: EdgeInsets.only(top: 16, bottom: 8),
                        child: Text(
                          'Medidas',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    DelayedDisplay(
                      delay: const Duration(milliseconds: 1000),
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: brand.sizes.map((s) {
                          return SizeWidget(size: s);
                        }).toList(),
                      ),
                    ),
                  ],
                  const SizedBox(
                    height: 32,
                  ),
                  if (brand.hasStock)
                    Consumer2<UserManager, Brand>(
                      builder: (_, userManager, brand, __) {
                        return DelayedDisplay(
                          delay: const Duration(milliseconds: 1200),
                          child: SizedBox(
                            height: 44,
                            child: ElevatedButton(
                              onPressed: brand.selectedSize != null
                                  ? () async {
                                      if (userManager.isLoggedIn) {
                                        if (fromCartNavigation) {
                                          await context
                                              .read<CartManager>()
                                              .addToCart(recipe, brand);

                                          Navigator.of(context).pop();
                                        } else {
                                          // await context
                                          //     .read<CartManager>()
                                          //     .loadCartItems(recipeId: recipe.id);

                                          await context
                                              .read<CartManager>()
                                              .addToCart(recipe, brand);

                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  CartScreen(),
                                            ),
                                          );
                                        }
                                      } else {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  GoogleSignInScreen()),
                                        );
                                      }
                                    }
                                  : null,
                              style: ButtonStyle(
                                backgroundColor: brand.selectedSize != null
                                    ? MaterialStateProperty.resolveWith<Color>(
                                        (Set<MaterialState> states) {
                                          if (states
                                              .contains(MaterialState.pressed))
                                            return Theme.of(context)
                                                .accentColor;
                                          return Theme.of(context).accentColor;
                                        },
                                      )
                                    : MaterialStateProperty.resolveWith<Color>(
                                        (Set<MaterialState> states) {
                                          if (states
                                              .contains(MaterialState.pressed))
                                            return Theme.of(context)
                                                .disabledColor;
                                          return Theme.of(context)
                                              .disabledColor;
                                        },
                                      ),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(26.0),
                                  ),
                                ),
                              ),
                              child: Text(
                                userManager.isLoggedIn
                                    ? brand.selectedSize != null
                                        ? 'Colocar na lista'
                                        : 'Selecione uma medida'
                                    : 'Faça Login',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  const SizedBox(
                    height: 16,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
