import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'brand_size.dart';

class Brand extends ChangeNotifier {
  Brand(
      {this.id,
      this.recipeId,
      this.ingredientId,
      this.ingredientType,
      this.ingredientTitle,
      this.ingredientReference,
      this.name,
      this.description,
      this.sizes,
      this.deleted = false}) {
    sizes = sizes ?? [];
  }

  Brand.fromDocument(DocumentSnapshot document) {
    id = document.id;
    recipeId = document['recipeId'] as String;
    ingredientId = document['ingredientId'] as String;
    ingredientType = document['ingredientType'] as double;
    ingredientTitle = document['ingredientTitle'] as String;
    ingredientReference = document['ingredientReference'] as String;
    name = document['name'] as String;
    description = document['description'] as String;
    deleted = (document.data()['deleted'] ?? false) as bool;
    sizes = (document.data()['sizes'] as List<dynamic> ?? [])
        .map((s) => BrandSize.fromMap(s as Map<String, dynamic>))
        .toList();
  }

  String id;
  String recipeId;
  String ingredientId;
  double ingredientType;
  String ingredientTitle;
  String ingredientReference;
  String name;
  String description;
  List<BrandSize> sizes;

  bool deleted;

  bool _loading = false;
  bool get loading => _loading;
  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }

  BrandSize _selectedSize;
  BrandSize get selectedSize => _selectedSize;
  set selectedSize(BrandSize value) {
    _selectedSize = value;
    notifyListeners();
  }

  int get totalStock {
    int stock = 0;
    for (final size in sizes) {
      stock += size.stock;
    }
    return stock;
  }

  bool get hasStock {
    return totalStock > 0 && !deleted;
  }

  num get basePrice {
    num lowest = double.infinity;
    for (final size in sizes) {
      if (size.price < lowest) lowest = size.price;
    }
    return lowest;
  }

  BrandSize findSize(String name) {
    try {
      return sizes.firstWhere((s) => s.name == name);
    } catch (e) {
      return null;
    }
  }

  List<Map<String, dynamic>> exportSizeList() {
    return sizes.map((size) => size.toMap()).toList();
  }

  Future<void> save(
      {String recipeIdFrom,
      double ingredientType = 0.1,
      String ingredientId,
      String ingredientTitle}) async {
    loading = true;

    final Map<String, dynamic> data = {
      'recipeId': recipeIdFrom,
      'ingredientId': ingredientId,
      'ingredientType': 0.1,
      'ingredientTitle': ingredientTitle,
      'ingredientReference': 'recipes/$recipeIdFrom/ingredients/$ingredientId',
      'name': name,
      'description': '...', //description,
      'sizes': exportSizeList(),
      'deleted': deleted
    };

    final Map<String, dynamic> data2 = {
      'recipeId': recipeIdFrom,
      'ingredientId': ingredientId,
      'ingredientType': 0.1,
      'ingredientTitle': ingredientTitle,
      'ingredientReference': 'recipes/$recipeIdFrom/ingredients/$ingredientId',
      'name': name,
      'description': '...', //description,
      'sizes': exportSizeList(),
      'deleted': deleted,
      'brandReference': '',
      'totalHating': 0.0,
    };

    if (id == null) {
      final docRef = await FirebaseFirestore.instance
          .collection('recipes')
          .doc(recipeIdFrom)
          .collection('ingredients')
          .doc(ingredientId)
          .collection('brands')
          .add(data);
      data2['brandReference'] = docRef.path;
      await FirebaseFirestore.instance
          .collection('allIngredients')
          .doc('0.1') //ingredientType.toString())
          .collection('allBrands')
          .doc(docRef.id)
          .set(data2);
      id = docRef.id;
    } else {
      await FirebaseFirestore.instance
          .doc('recipes/$recipeIdFrom/ingredients/$ingredientId/brands/$id')
          .update(data);
      await FirebaseFirestore.instance
          .collection('allIngredients')
          .doc('0.1') //ingredientType.toString())
          .collection('allBrands')
          .doc(id)
          .update(data);
    }

    loading = false;
  }

  void delete(String recipeIdFrom, Brand brand, String ingredientId,
      double ingredientType) {
    FirebaseFirestore.instance
        .doc('recipes/$recipeIdFrom/ingredients/$ingredientId/brands/$id')
        .update({'deleted': true});
    FirebaseFirestore.instance
        .collection('allIngredients')
        .doc('0.1') //brand.ingredientType.toString())
        .collection('allBrands')
        .doc(brand.id)
        .update({'deleted': true});
  }

  Brand clone() {
    return Brand(
      id: id,
      recipeId: recipeId,
      ingredientId: ingredientId,
      ingredientType: ingredientType,
      ingredientTitle: ingredientTitle,
      ingredientReference: ingredientReference,
      name: name,
      description: '...', //description,
      sizes: sizes.map((size) => size.clone()).toList(),
      deleted: deleted,
    );
  }

  @override
  String toString() {
    return 'Brand{id: $id, recipeId: $recipeId, ingredientId: $ingredientId, ingredientType: $ingredientType, ingredientTitle: $ingredientTitle, ref: $ingredientReference, name: $name, description: $description, sizes: $sizes}';
  }
}
