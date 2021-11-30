import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/custom_surfix_icon.dart';
import '../../controllers/brands/brand.dart';
import '../../controllers/brands/brand_manager.dart';
import '../../controllers/ingredients/ingredient.dart';
import '../../controllers/recipes/recipe.dart';
import '../recipe_ingredient_brand/ingredient_brand_screen.dart';
import 'components/sizes_form.dart';

class EditBrandScreen extends StatelessWidget {
  EditBrandScreen(Brand p)
      : editing = p != null,
        brand = p != null ? p.clone() : Brand();

  final Brand brand;
  final bool editing;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final Ingredient ingredient = Provider.of(context);
    final Recipe recipe = Provider.of(context, listen: false);
    return ChangeNotifierProvider.value(
      value: brand,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text(ingredient.name),
          leading: InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: const Icon(Icons.arrow_back),
          ),
          actions: <Widget>[
            if (editing)
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    context
                        .read<BrandManager>()
                        .delete(recipe.id, brand, ingredient.id, 9.6);
                    Navigator.of(context).pop();
                  },
                ),
              ),
          ],
        ),
        body: Form(
          key: formKey,
          child: ListView(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    TextFormField(
                      initialValue: brand.name,
                      decoration: const InputDecoration(
                        labelText: "Produto / Marca",
                        labelStyle: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                        hintText: "Leite Condensado Nestle",
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        // suffixIcon: CustomSurffixIcon(
                        //     svgIcon: "assets/yummy/icons/yummy_1.svg"),
                      ),
                      style: const TextStyle(fontSize: 16),
                      validator: (name) {
                        if (name.length < 2) return 'Título muito curto';
                        return null;
                      },
                      onSaved: (name) => brand.name = name,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    SizesForm(brand),
                    const SizedBox(
                      height: 16,
                    ),
                    Consumer<Brand>(
                      builder: (_, brand, __) {
                        if (brand.loading)
                          return const LinearProgressIndicator(
                            backgroundColor: Colors.transparent,
                          );
                        else
                          return SizedBox(
                            height: 44,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.resolveWith<Color>(
                                  (Set<MaterialState> states) {
                                    if (states.contains(MaterialState.pressed))
                                      return Theme.of(context).accentColor;
                                    return Theme.of(context).accentColor;
                                  },
                                ),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(26.0),
                                  ),
                                ),
                              ),
                              onPressed: !brand.loading
                                  ? () async {
                                      if (formKey.currentState.validate()) {
                                        formKey.currentState.save();
                                        await brand.save(
                                          recipeIdFrom: recipe.id,
                                          ingredientType: ingredient.type,
                                          ingredientId: ingredient.id,
                                          ingredientTitle: ingredient.name,
                                        );
                                        context
                                            .read<BrandManager>()
                                            .update(brand);
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => BrandScreen(brand),
                                          ),
                                        );
                                      }
                                    }
                                  : null,
                              child: const Text(
                                'Salvar',
                                style: TextStyle(fontSize: 18.0),
                              ),
                            ),
                          );
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
