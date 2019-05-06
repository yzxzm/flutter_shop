import 'package:flutter/material.dart';

import '../model/categoryList.dart';

class CategoryGooodsListProvider with ChangeNotifier {
  List<CategoryListData> list = [];

  getList(List<CategoryListData> mList) {
    list = mList;
    notifyListeners();
  }

  addGoodsList(List<CategoryListData> mList) {
    list.addAll(mList);
    notifyListeners();
  }
}
