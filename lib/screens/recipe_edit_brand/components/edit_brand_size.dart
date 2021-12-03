import 'package:flutter/material.dart';
import 'package:yummy/utils/constants.dart';
import '../../../components/custom_icon_button.dart';
import '../../../controllers/brands/brand_size.dart';

class EditBrandSize extends StatelessWidget {
  const EditBrandSize(
      {Key key, this.size, this.onRemove, this.onMoveUp, this.onMoveDown})
      : super(key: key);

  final BrandSize size;
  final VoidCallback onRemove;
  final VoidCallback onMoveUp;
  final VoidCallback onMoveDown;

  @override
  Widget build(BuildContext context) {
    final OutlineInputBorder outlineInputBorder = OutlineInputBorder(
      borderSide: BorderSide(color: AppColors.rosaClaro),
      gapPadding: 3,
    );
    size.stock = 10000;
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 60,
            child: TextFormField(
              initialValue: size.name,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.fromLTRB(8, 16, 8, 0),
                enabledBorder: outlineInputBorder,
                focusedBorder: outlineInputBorder,
                border: outlineInputBorder,
                labelText: 'Título',
                hintText: '395g/500ml/1L',
                isDense: true,
              ),
              validator: (name) {
                if (name.isEmpty) return 'Inválido';
                return null;
              },
              onChanged: (name) => size.name = name,
            ),
          ),
          const SizedBox(
            width: 4,
          ),
          const SizedBox(
            width: 4,
          ),
          Expanded(
            flex: 40,
            child: TextFormField(
              initialValue: size.price?.toStringAsFixed(2),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.fromLTRB(8, 16, 8, 0),
                enabledBorder: outlineInputBorder,
                focusedBorder: outlineInputBorder,
                border: outlineInputBorder,
                labelText: 'Preço R\$',
                hintText: '4.89',
                isDense: true,
              ),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              validator: (price) {
                if (num.tryParse(price) == null) return 'Preço Inválido';
                return null;
              },
              onChanged: (price) => size.price = num.tryParse(price),
            ),
          ),
          CustomIconButton(
            iconData: Icons.arrow_drop_up,
            color: AppColors.rosaClaro,
            onTap: onMoveUp,
          ),
          CustomIconButton(
            iconData: Icons.arrow_drop_down,
            color: AppColors.rosaClaro,
            onTap: onMoveDown,
          ),
          CustomIconButton(
            iconData: Icons.remove,
            color: Theme.of(context).accentColor,
            onTap: onRemove,
          ),
        ],
      ),
    );
  }
}
