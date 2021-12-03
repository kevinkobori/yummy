import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:yummy/controllers/recipes/recipe.dart';

import '../../controllers/brands/brand.dart';
import '../../controllers/carts/cart_brand.dart';
import '../../controllers/user/user_manager.dart';
import '../../controllers/user/user_model.dart';

class CartManager extends ChangeNotifier {
  List<CartBrand> items = [];
  List<DocumentSnapshot> carts = [];
  UserModel user;
  String recipeId;
  num brandsPrice = 0.0;
  num deliveryPrice;

  num get totalPrice => brandsPrice + (deliveryPrice ?? 0);

  bool _loading = false;
  bool get loading => _loading;
  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }

  String _search = '';

  String get search => _search;
  set search(String value) {
    _search = value;
    notifyListeners();
  }

  List<DocumentSnapshot> get filteredCarts {
    final List<DocumentSnapshot> filteredCarts = [];

    if (search.isEmpty) {
      filteredCarts.addAll(carts);
    } else {
      filteredCarts.addAll(carts.where((p) {
        final String recipeName = p.data()['recipeName'] as String;
        if (recipeName.toLowerCase().contains(search.toLowerCase())) {
          return true;
        } else {
          return false;
        }
      }));
    }

    return filteredCarts;
  }

  void updateUser(UserManager userManager) {
    user = userManager.user;
    brandsPrice = 0.0;
    items.clear();
    if (user != null) {
      loadCarts();
    }
  }

  Future<void> loadCarts() async {
    final QuerySnapshot cartSnap = await user.cartsReference.get();

    carts = cartSnap.docs;
    carts.map((doc) {
      loadCartItems(doc.id);
    }).toList();
  }

  Future<void> loadCartItems(String recipeId) async {
    this.recipeId = recipeId;
    final QuerySnapshot cartSnap =
        await user.cartsReference.doc(recipeId).collection('cart').get();

    items = cartSnap.docs
        .map((d) => CartBrand.fromDocument(d)..addListener(_onItemUpdated))
        .toList();
  }

  void addToCart(Recipe recipe, Brand brand) {
    try {
      final e = items.firstWhere((p) => p.stackable(brand));
      e.increment();
    } catch (e) {
      final cartBrand = CartBrand.fromBrand(brand);
      cartBrand.addListener(_onItemUpdated);
      items.add(cartBrand);

      user.cartsReference.doc(recipe.id).set({'recipeName': recipe.name});

      user.cartsReference
          .doc(recipe.id)
          .collection('cart')
          .add(cartBrand.toCartItemMap())
          .then((doc) => cartBrand.id = doc.id);
      _onItemUpdated();
    }
    notifyListeners();
  }

  void removeOfCart(String recipeId, CartBrand cartBrand) {
    items.removeWhere((p) => p.id == cartBrand.id);
    if (items.isEmpty) {
      user.cartsReference.doc(recipeId).delete();
      items.clear();
    } else {
      user.cartsReference
          .doc(recipeId)
          .collection('cart')
          .doc(cartBrand.id)
          .delete();
    }
    cartBrand.removeListener(_onItemUpdated);
    notifyListeners();
  }

  Future<void> delete({String recipeId, int index}) async {
    user.cartsReference.doc(recipeId).delete();
    filteredCarts.removeAt(index);
    items.clear();
    notifyListeners();
  }

  void _onItemUpdated() {
    brandsPrice = 0.0;

    for (int i = 0; i < items.length; i++) {
      final cartBrand = items[i];

      if (cartBrand.quantity == 0) {
        removeOfCart(recipeId, cartBrand);
        i--;
        continue;
      }

      brandsPrice += cartBrand.totalPrice;

      _updateCartBrand(recipeId, cartBrand);
    }

    notifyListeners();
  }

  void _updateCartBrand(String recipeId, CartBrand cartBrand) {
    if (cartBrand.id != null)
      user.cartsReference
          .doc(recipeId)
          .collection('cart')
          .doc(cartBrand.id)
          .update(cartBrand.toCartItemMap());
  }
}
