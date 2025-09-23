import 'package:flutter/material.dart';

class FavoriteProvider extends ChangeNotifier {
  final List<Map<String, String>> _favoriteDoctors = [];

  List<Map<String, String>> get favoriteDoctors => _favoriteDoctors;

  void toggleFavorite(Map<String, String> doctor) {
    final isExist = _favoriteDoctors.any((d) => d['name'] == doctor['name']);
    if (isExist) {
      _favoriteDoctors.removeWhere((d) => d['name'] == doctor['name']);
    } else {
      _favoriteDoctors.add(doctor);
    }
    notifyListeners();
  }

  bool isFavorite(String name) {
    return _favoriteDoctors.any((d) => d['name'] == name);
  }
}
