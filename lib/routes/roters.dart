import 'package:flutter/material.dart';

import '../weight/fluro.dart';
import 'router_handler.dart';

class Routes {
  static String root = '/';
  static String detailPage = '/detail';

  static void configureRoutes(Router router) {
    router.notFoundHandler = new Handler(
        handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      print('没找到界面');
    });
    router.define(detailPage, handler: detailHnadler);
  }
}
