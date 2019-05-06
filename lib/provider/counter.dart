import 'package:flutter/material.dart';

class Counter with ChangeNotifier {
  //混入了ChangeNotifier，意思是可以不用管理听众
  int num = 0;

  increament() {
    num++;
    notifyListeners();
  }
}
