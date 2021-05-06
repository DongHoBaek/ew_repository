import 'package:flutter/material.dart';

class CurrentDocId with ChangeNotifier {
  String _currentDocId;
  String get currentDocId => _currentDocId;

  void setCurrentDocId(String currentDocId) {
    _currentDocId = currentDocId;
    print("set document id to ${currentDocId}");
    notifyListeners();
  }
}