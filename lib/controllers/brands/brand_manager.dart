import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'brand.dart';

class BrandManager extends ChangeNotifier {
  List<Brand> recipeBrands = [];

  String _search = '';

  String get search => _search;
  set search(String value) {
    _search = value;
    notifyListeners();
  }

  List<Brand> get filteredBrands {
    final List<Brand> filteredBrands = [];

    if (search.isEmpty) {
      filteredBrands.addAll(recipeBrands);
    } else {
      filteredBrands.addAll(recipeBrands.where((brand) {
        if (brand.name.toLowerCase().contains(search.toLowerCase())) {
          return true;
        } else {
          return false;
        }
      }));
    }

    return filteredBrands;
  }

  Future<void> loadRecipeIngredientBrands(
      String recipeIdFrom, String ingredientId) async {
    final QuerySnapshot snapBrands = await FirebaseFirestore.instance
        .collection('recipes')
        .doc(recipeIdFrom)
        .collection('ingredients')
        .doc(ingredientId)
        .collection('brands')
        .where('deleted', isEqualTo: false)
        .get();

    recipeBrands = snapBrands.docs.map((d) => Brand.fromDocument(d)).toList();

    notifyListeners();
  }

  Brand findBrandById(String id) {
    try {
      return recipeBrands.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }

  void update(Brand brand) {
    recipeBrands.removeWhere((p) => p.id == brand.id);
    recipeBrands.add(brand);
    notifyListeners();
  }

  void delete(
    String recipeIdFrom,
    Brand brand,
    String ingredientId,
    double ingredientType,
  ) {
    brand.delete(
      recipeIdFrom,
      brand,
      ingredientId,
      ingredientType,
    );
    recipeBrands.removeWhere((p) => p.id == brand.id);
    notifyListeners();
  }
}
