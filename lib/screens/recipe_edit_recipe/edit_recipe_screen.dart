import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/custom_surfix_icon.dart';
import '../../controllers/recipes/recipe.dart';
import '../../controllers/recipes/recipe_manager.dart';
import '../../controllers/user/user_manager.dart';
import 'components/images_form.dart';

class EditRecipeScreen extends StatefulWidget {
  EditRecipeScreen(Recipe p)
      : editing = p != null,
        recipe = p != null ? p.clone() : Recipe();

  final Recipe recipe;
  final bool editing;
  @override
  _EditRecipeScreen createState() => _EditRecipeScreen();
}

class _EditRecipeScreen extends State<EditRecipeScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool checkedValue = true;

  @override
  Widget build(BuildContext context) {
    final UserManager userManager = Provider.of(context, listen: false);
    return ChangeNotifierProvider.value(
      value: widget.recipe,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text(
              widget.editing ? 'Editando Receita...' : 'Criando Receita...'),
          leading: InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: const Icon(Icons.arrow_back),
          ),
          actions: <Widget>[
            if (widget.editing)
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    context.read<RecipeManager>().delete(
                          context: context,
                          recipeId: widget.recipe.id,
                          recipeName: widget.recipe.name,
                        );
                    Navigator.of(context).pop();
                  },
                ),
              ),
          ],
        ),
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Form(
            key: formKey,
            child: FormField(
              builder: (state) {
                checkedValue = false;
                widget.recipe.whats = '';
                return ListView(
                  children: <Widget>[
                    ImagesForm(widget.recipe),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: TextFormField(
                        initialValue: widget.recipe.name,
                        decoration: const InputDecoration(
                          labelText: "Nome da Receita",
                          labelStyle: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                          hintText: "Bolo de Cenoura",
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                        style: const TextStyle(fontSize: 16),
                        validator: (name) {
                          if (name.length < 2) return 'Título muito curto';
                          return null;
                        },
                        onSaved: (name) => widget.recipe.name = name,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: TextFormField(
                        initialValue: widget.recipe.description,
                        style: const TextStyle(fontSize: 16),
                        decoration: const InputDecoration(
                          labelText: "Passos da Receita",
                          labelStyle: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          hintText: "1. ...\n\n2. ...\n\n3. ...",
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                        maxLines: null,
                        validator: (desc) {
                          return null;
                        },
                        onSaved: (desc) => widget.recipe.description = desc,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Consumer<Recipe>(
                        builder: (_, recipe, __) {
                          if (recipe.loading)
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
                                onPressed: !recipe.loading
                                    ? () async {
                                        if (formKey.currentState.validate()) {
                                          formKey.currentState.save();
                                          widget.recipe.autoplay = checkedValue;
                                          await recipe
                                              .firestoreAdd(userManager);
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
                    ),
                    const SizedBox(height: 16),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
