import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:yummy/utils/constants.dart';

import '../controllers/carts/cart_manager.dart';

class PriceCard extends StatelessWidget {
  final CartManager cartManager;

  const PriceCard({Key key, this.cartManager}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    NumberFormat formatter = NumberFormat.simpleCurrency(locale: 'pt_BR');
    final brandsPriceFixed =
        double.parse(cartManager.brandsPrice.toStringAsFixed(2));
    final brandsPrice = formatter.format(brandsPriceFixed);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            'Resumo da Receita',
            textAlign: TextAlign.start,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: AppColors.azulClaro,
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          Row(
            children: <Widget>[
              Text(
                'Total: ',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppColors.azulClaro,
                ),
              ),
              Text(
                brandsPrice,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).accentColor,
                ),
              )
            ],
          ),
          const SizedBox(
            height: 4,
          ),
        ],
      ),
    );
  }
}
