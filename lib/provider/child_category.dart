import 'package:flutter/material.dart';

import '../model/category.dart';

class ChildCateGory with ChangeNotifier {
  List<BxMallSubDto> list = [];
  var curIndex = 0;
  String categoryId = '4'; //大类id
  String subId = ''; //小类id
  int page = 1; //列表页数，当改变大类或者小类时进行改变
  String noMoreText = ''; //显示更多的标识

  getChildList(List<BxMallSubDto> mList, String id) {
    curIndex = 0;
    categoryId = id;
    page = 1;
    noMoreText = '';

    BxMallSubDto all = BxMallSubDto();
    all.mallSubName = '全部';
    all.mallCategoryId = '00';
    all.mallSubId = '';
    all.comments = 'null';
    list = [all];
    list.addAll(mList);
    notifyListeners();
  }

  setChildIndex(index, id) {
    subId = id;
    curIndex = index;
    page = 1;
    noMoreText = '';
    notifyListeners();
  }

  //增加Page的方法f
  addPage() {
    page++;
  }

  //改变noMoreText数据
  changeNoMore(String text) {
    noMoreText = text;
    notifyListeners();
  }
}
