import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:intl/intl.dart';
import 'package:yummy/utils/constants.dart';
import '../../../controllers/brands/brand.dart';
import '../../../controllers/brands/brand_size.dart';

class SizeWidget extends StatelessWidget {
  const SizeWidget({this.size});

  final BrandSize size;

  @override
  Widget build(BuildContext context) {
    final brand = context.watch<Brand>();
    final selected = size == brand.selectedSize;

    Color color;
    if (!size.hasStock)
      color = Colors.red.withAlpha(50);
    else if (selected)
      color = AppColors.azulClaro; //Theme.of(context).accentColor;
    else
      color = Colors.grey;

    final NumberFormat formatter = NumberFormat.simpleCurrency(locale: 'pt_BR');
    final priceFixed = double.parse(size.price.toStringAsFixed(2));
    final price = formatter.format(priceFixed);

    return GestureDetector(
      onTap: () {
        if (size.hasStock) {
          brand.selectedSize = size;
        }
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: color),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              color: color,
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              child: Text(
                size.name,
                style: TextStyle(color: Colors.white),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                price,
                style: TextStyle(
                  color: color,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
