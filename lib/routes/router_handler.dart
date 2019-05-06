import 'package:flutter/material.dart';

import '../pages/detail_page.dart';
import '../weight/fluro.dart';

Handler detailHnadler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String goodsId = params['id'].first;
  return DetailPage(goodsId);
});
