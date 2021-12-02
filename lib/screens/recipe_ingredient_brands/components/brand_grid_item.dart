import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:yummy/utils/constants.dart';

import '../../../controllers/brands/brand.dart';
import '../../recipe_ingredient_brand/ingredient_brand_screen.dart';

class BrandGridItem extends StatefulWidget {
  const BrandGridItem(
      this.brand, this.ingredientId, this.ingredientTitle);
  final Brand brand;
  final String ingredientId;
  final String ingredientTitle;

  @override
  _BrandGridItemState createState() => _BrandGridItemState();
}

class _BrandGridItemState extends State<BrandGridItem> {
  @override
  Widget build(BuildContext context) {
    final NumberFormat formatter = NumberFormat.simpleCurrency(locale: 'pt_BR');
    final brandsPriceFixed =
        double.parse(widget.brand.basePrice.toStringAsFixed(2));
    final brandsPrice = formatter.format(brandsPriceFixed);
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => BrandScreen(widget.brand)),
        );
      },
      child: Container(
        height: 70,
        padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.azulMarinhoEscuro),
          borderRadius: const BorderRadius.all(Radius.circular(15.0)),
          color: const Color(0xFFF5F6F9),
        ),
        child: Column(
          children: [
            const SizedBox(
              height: 4,
            ),
            Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                  child: LayoutBuilder(
                    builder: (context, size) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Text(
                            widget.brand.name,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Colors.black, //todo black
                            ),
                          ),
                          const Text(
                            'a partir de',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          Text(
                            brandsPrice,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Theme.of(context).accentColor,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
