import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yummy/utils/constants.dart';
import '../../../controllers/carts/cart_brand.dart';
import '../../recipe_ingredient_brand/ingredient_brand_screen.dart';
import 'package:intl/intl.dart';

class CartTile extends StatelessWidget {
  const CartTile(this.cartBrand, this.showControls);

  final CartBrand cartBrand;
  final bool showControls;
  
  @override
  Widget build(BuildContext context) {
    NumberFormat formatter = NumberFormat.simpleCurrency(locale: 'pt_BR');
    final cartBrandUnitPriceFixed =
        double.parse(cartBrand.unitPrice.toStringAsFixed(2));
    final cartBrandUnitPrice = formatter.format(cartBrandUnitPriceFixed);
    return ChangeNotifierProvider.value(
      value: cartBrand,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BrandScreen(
                brand: cartBrand.brand,
                fromCartNavigation: true,
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        cartBrand.brand.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 17.0,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Medida: ${cartBrand.size}',
                        style: const TextStyle(fontWeight: FontWeight.w300),
                      ),
                      const SizedBox(height: 8),
                      Consumer<CartBrand>(
                        builder: (_, cartBrand, __) {
                          return Text.rich(
                            TextSpan(
                              text: cartBrandUnitPrice,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).accentColor,
                              ),
                              children: [
                                TextSpan(
                                  text: cartBrand.quantity.toString() == '1'
                                      ? ' x ${cartBrand.quantity} unidade'
                                      : ' x ${cartBrand.quantity} unidades',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.azulClaro,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: Consumer<CartBrand>(
                  builder: (_, cartBrand, __) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: cartBrand.increment,
                          child: Icon(
                            Icons.add_circle_outlined,
                            color: Colors.blue[300],
                          ),
                        ),
                        const SizedBox(height: 12),
                        InkWell(
                          onTap: cartBrand.decrement,
                          child: Icon(
                            Icons.remove_circle_outlined,
                            color: cartBrand.quantity != 1 ? null : Colors.red,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
