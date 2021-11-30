import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:uuid/uuid.dart';

import '../../controllers/search/section_item.dart';

class Section extends ChangeNotifier {
  Section({this.id, this.name, this.type, this.items}) {
    items = items ?? [];
    originalItems = List.from(items);
  }

  Section.fromDocument(DocumentSnapshot doc) {
    id = doc.id;
    name = doc.data()['name'] as String;
    type = doc.data()['type'] as String;
    items = (doc.data()['items'] as List)
        .map((i) => SectionItem.fromMap(i as Map<String, dynamic>))
        .toList();
  }

  String id;
  String name;
  String type;
  List<SectionItem> items;
  List<SectionItem> originalItems;

  String _error;
  String get error => _error;
  set error(String value) {
    _error = value;
    notifyListeners();
  }

  void addItem(SectionItem item) {
    items.add(item);
    notifyListeners();
  }

  void removeItem(SectionItem item) {
    items.remove(item);
    notifyListeners();
  }

  Future<void> save(String recipeId, int pos) async {
    final Map<String, dynamic> data = {
      'name': name,
      'type': 0.1, //type,
      'pos': pos,
    };

    if (id == null) {
      final doc = await FirebaseFirestore.instance
          .collection('recipes')
          .doc(recipeId)
          .collection('ingredients')
          .add(data);
      id = doc.id;
    } else {
      await FirebaseFirestore.instance
          .doc('recipes/$recipeId/ingredients/$id')
          .update(data);
    }

    for (final item in items) {
      if (item.image is File) {
        final UploadTask task = FirebaseStorage.instance
            .ref()
            .child('recipes/$recipeId/ingredients/$id')
            .child(const Uuid().v1())
            .putFile(item.image as File);
        final TaskSnapshot snapshot = await task.whenComplete(() => null);
        final String url = await snapshot.ref.getDownloadURL() as String;
        item.image = url;
      }
    }

    for (final original in originalItems) {
      if (!items.contains(original) &&
          (original.image as String).contains('firebase')) {
        try {
          final ref =
              FirebaseStorage.instance.refFromURL(original.image as String);
          await ref.delete();
        } catch (e) {
          //TODO
        }
      }
    }

    final Map<String, dynamic> itemsData = {
      'items': items.map((e) => e.toMap()).toList()
    };

    await FirebaseFirestore.instance
        .doc('recipes/$recipeId/ingredients/$id')
        .update(itemsData);
  }

  Future<void> delete(String recipeId) async {
    await FirebaseFirestore.instance
        .doc('recipes/$recipeId/ingredients/$id')
        .delete();
    for (final item in items) {
      if ((item.image as String).contains('firebase')) {
        try {
          final ref = FirebaseStorage.instance.refFromURL(item.image as String);
          await ref.delete();
        } catch (e) {
          //TODO
        }
      }
    }
  }

  bool valid() {
    if (name == null || name.isEmpty) {
      error = 'Título inválido';
    } else if (items.isEmpty) {
      error = 'Insira ao menos uma imagem';
    } else {
      error = null;
    }
    return error == null;
  }

  Section clone() {
    return Section(
      id: id,
      name: name,
      type: type,
      items: items.map((e) => e.clone()).toList(),
    );
  }

  @override
  String toString() {
    return 'Section{name: $name, type: $type, items: $items}';
  }
}
