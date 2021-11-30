import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import '../brands/brand.dart';
import '../brands/brand_size.dart';

class CartBrand extends ChangeNotifier {
  CartBrand.fromBrand(this._brand) {
    brandId = brand.id;
    ingredientReference = brand.ingredientReference;
    quantity = 1;
    size = brand.selectedSize.name;
  }

  CartBrand.fromDocument(DocumentSnapshot doc) {
    id = doc.id;
    brandId = doc.data()['pid'] as String;
    ingredientReference = doc.data()['ingredientReference'] as String;
    quantity = doc.data()['quantity'] as int;
    size = doc.data()['size'] as String;

    FirebaseFirestore.instance
        .doc('$ingredientReference/brands/$brandId')
        .get()
        .then((doc) {
      brand = Brand.fromDocument(doc);
    });
  }

  CartBrand.fromMap(Map<String, dynamic> map) {
    brandId = map['pid'] as String;
    ingredientReference = map['ingredientReference'] as String;
    quantity = map['quantity'] as int;
    size = map['size'] as String;
    fixedPrice = map['fixedPrice'] as num;

    FirebaseFirestore.instance
        .doc('$ingredientReference/brands/$brandId')
        .get()
        .then((doc) {
      brand = Brand.fromDocument(doc);
    });
  }

  String id;

  String brandId;
  String ingredientReference;
  int quantity;
  String size;

  num fixedPrice;

  Brand _brand;

  Brand get brand => _brand;
  set brand(Brand value) {
    _brand = value;
    notifyListeners();
  }

  BrandSize get brandSize {
    if (brand == null) return null;
    return brand.findSize(size);
  }

  num get unitPrice {
    if (brand == null) return 0;
    return brandSize?.price ?? 0;
  }

  num get totalPrice => unitPrice * quantity;

  Map<String, dynamic> toCartItemMap() {
    return {
      'pid': brandId,
      'ingredientReference': ingredientReference,
      'quantity': quantity,
      'size': size,
    };
  }

  Map<String, dynamic> toOrderItemMap() {
    return {
      'pid': brandId,
      'ingredientReference': ingredientReference,
      'quantity': quantity,
      'size': size,
      'fixedPrice': fixedPrice ?? unitPrice,
    };
  }

  bool stackable(Brand brand) {
    return brand.id == brandId && brand.selectedSize.name == size;
  }

  void increment() {
    quantity++;
    notifyListeners();
  }

  void decrement() {
    quantity--;
    notifyListeners();
  }

  bool get hasStock {
    if (brand != null && brand.deleted) return false;

    final size = brandSize;
    if (size == null) return false;
    return size.stock >= quantity;
  }
}
