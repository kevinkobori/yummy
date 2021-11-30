import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/custom_surfix_icon.dart';
import '../../controllers/ingredients/ingredient.dart';
import '../../controllers/ingredients/ingredient_manager.dart';
import '../../controllers/recipes/recipe.dart';

class EditIngredientScreen extends StatefulWidget {
  EditIngredientScreen(Ingredient p)
      : editing = p != null,
        ingredient = p != null ? p.clone() : Ingredient();

  final Ingredient ingredient;
  final bool editing;
  @override
  _EditIngredientScreenState createState() => _EditIngredientScreenState();
}

class _EditIngredientScreenState extends State<EditIngredientScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool checkedValue = true;

  @override
  Widget build(BuildContext context) {
    final Recipe recipe = Provider.of(context, listen: false);
    return ChangeNotifierProvider.value(
      value: widget.ingredient,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text(widget.editing
              ? 'Editando Igrediente...'
              : 'Criando Ingrediente...'),
          leading: InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: const Icon(Icons.arrow_back),
          ),
          actions: <Widget>[
            if (widget.editing)
              TextButton(
                onPressed: () async {
                  context.read<IngredientManager>().delete(widget.ingredient);
                  Navigator.of(context).pop();
                },
                child: Text('DELETAR  ',
                    style: TextStyle(color: Theme.of(context).accentColor)),
              ),
          ],
        ),
        body: Form(
          key: formKey,
          child: ListView(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      TextFormField(
                        initialValue: widget.ingredient.name,
                        decoration: const InputDecoration(
                          labelText: "Nome do Igrediente",
                          labelStyle: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                          hintText: "Leite Condensado",
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          suffixIcon: CustomSurffixIcon(
                              svgIcon: "assets/yummy/icons/yummy_1.svg"),
                        ),
                        style: const TextStyle(fontSize: 16),
                        validator: (name) {
                          if (name.length < 2) return 'Título muito curto';
                          return null;
                        },
                        onSaved: (name) => widget.ingredient.name = name,
                      ),
                      const SizedBox(height: 16),
                      Consumer<Ingredient>(
                        builder: (_, ingredient, __) {
                          if (ingredient.loading)
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
                                      if (states
                                          .contains(MaterialState.pressed))
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
                                onPressed: !ingredient.loading
                                    ? () async {
                                        if (formKey.currentState.validate()) {
                                          formKey.currentState.save();
                                          widget.ingredient.autoplay = false;

                                          await ingredient.save(
                                              recipe.id, recipe.name);

                                          context
                                              .read<IngredientManager>()
                                              .update(ingredient);
                                          Navigator.of(context).pop();
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
