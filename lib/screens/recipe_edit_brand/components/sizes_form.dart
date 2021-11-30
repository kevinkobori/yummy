import 'package:flutter/material.dart';

import '../../../components/custom_icon_button.dart';
import '../../../controllers/brands/brand.dart';
import '../../../controllers/brands/brand_size.dart';
import '../../../screens/recipe_edit_brand/components/edit_brand_size.dart';

class SizesForm extends StatelessWidget {
  const SizesForm(this.brand);

  final Brand brand;

  @override
  Widget build(BuildContext context) {
    return FormField<List<BrandSize>>(
      initialValue: brand.sizes,
      validator: (sizes) {
        if (sizes.isEmpty) return 'Insira uma medida';
        return null;
      },
      builder: (state) {
        return Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      'Medidas',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).accentColor,
                      ),
                    ),
                  ),
                  CustomIconButton(
                    iconData: Icons.add_box,
                    color: Theme.of(context).accentColor,
                    onTap: () {
                      state.value.add(BrandSize());
                      state.didChange(state.value);
                    },
                  )
                ],
              ),
              Column(
                children: state.value.map((size) {
                  return EditBrandSize(
                    key: ObjectKey(size),
                    size: size,
                    onRemove: () {
                      state.value.remove(size);
                      state.didChange(state.value);
                    },
                    onMoveUp: size != state.value.first
                        ? () {
                            final index = state.value.indexOf(size);
                            state.value.remove(size);
                            state.value.insert(index - 1, size);
                            state.didChange(state.value);
                          }
                        : null,
                    onMoveDown: size != state.value.last
                        ? () {
                            final index = state.value.indexOf(size);
                            state.value.remove(size);
                            state.value.insert(index + 1, size);
                            state.didChange(state.value);
                          }
                        : null,
                  );
                }).toList(),
              ),
              if (state.hasError)
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    state.errorText,
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 12,
                    ),
                  ),
                )
            ],
          ),
        );
      },
    );
  }
}
