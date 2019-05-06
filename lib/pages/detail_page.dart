import 'package:flutter/material.dart';

import './details_page/details_tabBar.dart';
import '../provider/details_info.dart';
import '../weight/flutter_screenutil.dart';
import '../weight/provide.dart';
import 'details_page/detail_bottom.dart';
import 'details_page/details_explain.dart';
import 'details_page/details_top_area.dart';
import 'details_page/details_web.dart';

class DetailPage extends StatelessWidget {
  final String goodsId;

  DetailPage(this.goodsId);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('商品详情'),
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: FutureBuilder(
          future: _getBackInfo(context),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Stack(
                children: <Widget>[
                  Container(
                    child: ListView(
                      children: <Widget>[
                        DetailsTopArea(),
                        DetailsExplain(),
                        DetailsTabBar(),
                        DetailsWeb(),
                        Container(
                          height: ScreenUtil().setHeight(90),
                        )
                      ],
                    ),
                  ),
                  Positioned(
                    child: DetailBottom(),
                    bottom: 0.0,
                    left: 0.0,
                  ),
                ],
              );
            } else {
              return Container(
                child: Text('没有详细信息'),
              );
            }
          }),
    );
  }

  Future _getBackInfo(BuildContext context) async {
    await Provide.value<DetailsInfoProvide>(context).getGoodsInfo(goodsId);
    return '完成加载';
  }
}
