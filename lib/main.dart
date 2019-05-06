import 'package:flutter/material.dart';

import 'pages/index_page.dart';
import 'provider/cart.dart';
import 'provider/category_goods_list_provider.dart';
import 'provider/child_category.dart';
import 'provider/counter.dart';
import 'provider/currentIndex.dart';
import 'provider/details_info.dart';
import 'routes/application.dart';
import 'routes/roters.dart';
import 'weight/fluro.dart';
import 'weight/provide.dart';
//将状态放入顶层

void main() {
  var counter = Counter();
  var categoryGoodsList = CategoryGooodsListProvider();
  var childCategory = ChildCateGory();
  var detailsInfoProvide = DetailsInfoProvide();
  var cartProvide = CartProvide();
  var currentIndexProvide = CurrentIndexProvide();

  var providers = Providers();
  final router = Router();
  Routes.configureRoutes(router);
  Application.router = router;

  providers
    ..provide(Provider<Counter>.value(counter))
    ..provide(Provider<CategoryGooodsListProvider>.value(categoryGoodsList))
    ..provide(Provider<ChildCateGory>.value(childCategory))
    ..provide(Provider<DetailsInfoProvide>.value(detailsInfoProvide))
    ..provide(Provider<CurrentIndexProvide>.value(currentIndexProvide))
    ..provide(Provider<CartProvide>.value(cartProvide));

  runApp(ProviderNode(child: MyApp(), providers: providers));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: MaterialApp(
        title: '电商项目',
        debugShowCheckedModeBanner: false, //去除右上角的debug
        theme: ThemeData(primaryColor: Colors.pink), //粉红色主题
        home: IndexPage(),
      ),
    );
  }
}
