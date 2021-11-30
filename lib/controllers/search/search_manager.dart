import 'package:flutter/cupertino.dart';
import 'section.dart';

class SearchManager extends ChangeNotifier {
  final List<Section> _sections = [];

  List<Section> _editingSections = [];

  bool editing = false;
  bool loading = false;

  void addSection(Section section) {
    _editingSections.add(section);
    notifyListeners();
  }

  void removeSection(Section section) {
    _editingSections.remove(section);
    notifyListeners();
  }

  List<Section> get sections {
    if (editing)
      return _editingSections;
    else
      return _sections;
  }

  void enterEditing() {
    editing = true;

    _editingSections = _sections.map((s) => s.clone()).toList();

    notifyListeners();
  }

  Future<void> saveEditing(String recipeId) async {
    bool valid = true;
    for (final section in _editingSections) {
      if (!section.valid()) valid = false;
    }
    if (!valid) return;

    loading = true;
    notifyListeners();

    int pos = 0;
    for (final section in _editingSections) {
      await section.save(recipeId, pos);
      pos++;
    }

    for (final section in List.from(_sections)) {
      if (!_editingSections.any((element) => element.id == section.id)) {
        await section.delete();
      }
    }

    loading = false;
    editing = false;
    notifyListeners();
  }

  void discardEditing() {
    editing = false;
    notifyListeners();
  }
}
