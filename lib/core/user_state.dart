import 'package:flutter/material.dart';

class UserState extends ChangeNotifier {
  String? _uid;

  String? get uid => _uid;

  void setUid(String uid) {
    _uid = uid;
    notifyListeners(); // Notify listeners when the UID changes
  }

  void clearUid() {
    _uid = null;
    notifyListeners(); // Notify listeners when the UID is cleared
  }
}
