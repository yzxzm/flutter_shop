import 'dart:convert';

import 'package:flutter/material.dart';

import '../model/category.dart';
import '../model/categoryList.dart';
import '../provider/category_goods_list_provider.dart';
import '../provider/child_category.dart';
import '../routes/application.dart';
import '../service/service_method.dart';
import '../weight/easy_refresh.dart';
import '../weight/flutter_screenutil.dart';
import '../weight/fluttertoast.dart';
import '../weight/provide.dart';

class TypePage extends StatefulWidget {
  @override
  _TypePageState createState() => _TypePageState();
}

class _TypePageState extends State<TypePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('分类页面'),
      ),
      body: Container(
        child: Row(
          children: <Widget>[
            LeftCategoryNav(),
            Column(
              children: <Widget>[
                RightCategoryNav(),
                RightCategoryList(),
              ],
            )
          ],
        ),
      ),
    );
  }
}

//左边导航
class LeftCategoryNav extends StatefulWidget {
  @override
  _LeftCategoryState createState() => _LeftCategoryState();
}

class _LeftCategoryState extends State<LeftCategoryNav> {
  List<Data> list = [];
  int listIndex = 0;

  @override
  void initState() {
    _getList();
    _getGoodList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenUtil().setWidth(150),
      child: ListView.builder(
          itemCount: list.length,
          itemBuilder: (context, index) {
            return _leftInkWell(index);
          }),
    );
  }

  _leftInkWell(index) {
    bool isClick = false;
    isClick = (index == listIndex) ? true : false;

    return InkWell(
      child: Container(
        height: ScreenUtil().setHeight(100),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: isClick ? Color.fromRGBO(236, 238, 239, 1.0) : Colors.white,
            border: Border(
                bottom: BorderSide(width: 1, color: Colors.black),
                right: BorderSide(width: 1, color: Colors.black))),
        child: Text(
          list[index].mallCategoryName,
          style: TextStyle(fontSize: ScreenUtil().setSp(28)),
        ),
      ),
      onTap: () {
        setState(() {
          listIndex = index;
        });
        Provide.value<ChildCateGory>(context)
            .getChildList(list[index].bxMallSubDto, list[index].mallCategoryId);
        _getGoodList(
            categorySubId: Provide.value<ChildCateGory>(context).categoryId);
      },
    );
  }

  _getList() {
    requestHttp('getCategory').then((val) {
      var data = json.decode(val.toString());
      CategoryBigModel category = CategoryBigModel.fromJson(data);
      setState(() {
        list = category.data;
      });
      Provide.value<ChildCateGory>(context)
          .getChildList(list[0].bxMallSubDto, list[0].mallCategoryId);
      //list.data.forEach((item) => print(item.mallCategoryName));
    });
  }

  //得到商品列表数据
  _getGoodList({String categorySubId}) {
    var data = {
      'categoryId': categorySubId == null ? '4' : categorySubId,
      'categorySubId': '',
      'page': 1
    };

    requestHttp('getMallGoods', formData: data).then((val) {
      var data = json.decode(val.toString());
      CategoryGoodsListModel goodsList = CategoryGoodsListModel.fromJson(data);
      // Provide.value<CategoryGoodsList>(context).getGoodsList(goodsList.data);
      Provide.value<CategoryGooodsListProvider>(context)
          .getList(goodsList.data);
    });
  }
}

//右边导航
class RightCategoryNav extends StatefulWidget {
  @override
  _RightCategoryNavState createState() => _RightCategoryNavState();
}

class _RightCategoryNavState extends State<RightCategoryNav> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenUtil().setWidth(600),
      height: ScreenUtil().setHeight(90),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(width: 1, color: Colors.black)),
      ),
      child: Provide<ChildCateGory>(builder: (context, child, childCatory) {
        return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: childCatory.list.length,
            itemBuilder: (context, index) {
              return _rightTopInkWell(index, childCatory.list[index]);
            });
      }),
    );
  }

  _rightTopInkWell(int index, BxMallSubDto item) {
    bool isClick = false;
    isClick = (index == Provide.value<ChildCateGory>(context).curIndex)
        ? true
        : false;
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.all(5),
      child: InkWell(
        onTap: () {
          Provide.value<ChildCateGory>(context)
              .setChildIndex(index, item.mallSubId);
          _getGoodList(item.mallSubId);
        },
        child: Text(
          item.mallSubName,
          style: TextStyle(
              color: isClick ? Colors.pink : Colors.black,
              fontSize: ScreenUtil().setSp(29)),
        ),
      ),
    );
  }

  _getGoodList(String categorySubId) {
    var data = {
      'categoryId': Provide.value<ChildCateGory>(context).categoryId,
      'categorySubId': categorySubId,
      'page': 1
    };
    requestHttp('getMallGoods', formData: data).then((val) {
      var data = json.decode(val.toString());
      CategoryGoodsListModel goodsList = CategoryGoodsListModel.fromJson(data);
      if (goodsList.data == null) {
        goodsList.data = [];
      }
      Provide.value<CategoryGooodsListProvider>(context)
          .getList(goodsList.data);
    });
  }
}

class RightCategoryList extends StatefulWidget {
  @override
  _RightCategoryListState createState() => _RightCategoryListState();
}

class _RightCategoryListState extends State<RightCategoryList> {
  GlobalKey<RefreshFooterState> _footerKey = GlobalKey<RefreshFooterState>();
  var scrollController = new ScrollController();

  @override
  Widget build(BuildContext context) {
    return Provide<CategoryGooodsListProvider>(builder: (context, child, data) {
      try {
        if (Provide.value<ChildCateGory>(context).page == 1) {
          scrollController.jumpTo(0.0);
        }
      } catch (e) {
        print('进入页面第一次初始化：${e}');
      }

      if (data.list.length == 0) {
        return Expanded(
          child: Container(
            alignment: Alignment.center,
            child: Text(
              '暂无数据',
            ),
          ),
        );
      } else {
        return Expanded(
          child: Container(
            width: ScreenUtil().setWidth(600),
            child: EasyRefresh(
              refreshFooter: ClassicsFooter(
                  key: _footerKey,
                  bgColor: Colors.white,
                  textColor: Colors.pink,
                  moreInfoColor: Colors.pink,
                  showMore: true,
                  noMoreText: Provide.value<ChildCateGory>(context).noMoreText,
                  moreInfo: '加载中',
                  loadReadyText: '上拉加载'),
              child: ListView.builder(
                  controller: scrollController,
                  itemCount: data.list.length,
                  itemBuilder: (context, index) {
                    return _listItemWeight(data.list, index);
                  }),
              loadMore: () async {
                print('没有更多了.......');
                _getMoreList();
              },
            ),
          ),
        );
      }
    });
  }

  //上拉加载更多的方法
  void _getMoreList() {
    Provide.value<ChildCateGory>(context).addPage();

    var data = {
      'categoryId': Provide.value<ChildCateGory>(context).categoryId,
      'categorySubId': Provide.value<ChildCateGory>(context).subId,
      'page': Provide.value<ChildCateGory>(context).page
    };

    requestHttp('getMallGoods', formData: data).then((val) {
      var data = json.decode(val.toString());
      CategoryGoodsListModel goodsList = CategoryGoodsListModel.fromJson(data);

      if (goodsList.data == null) {
        Fluttertoast.showToast(
            msg: '到底了！',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.pink,
            textColor: Colors.white);
        Provide.value<ChildCateGory>(context).changeNoMore('没有更多了');
      } else {
        Provide.value<CategoryGooodsListProvider>(context)
            .addGoodsList(goodsList.data);
      }
    });
  }

  _listItemWeight(list, index) {
    return InkWell(
      onTap: () {
        Application.router.navigateTo(context, "/detail?id=${index}");
      },
      child: Container(
        padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
        decoration: BoxDecoration(
            color: Colors.white,
            border:
                Border(bottom: BorderSide(width: 1.0, color: Colors.black))),
        child: Row(
          children: <Widget>[
            _goodsImage(list, index),
            Column(
              children: <Widget>[
                _goodsName(list, index),
                _goodsPrice(list, index)
              ],
            )
          ],
        ),
      ),
    );
  }

  _goodsImage(list, index) {
    return Container(
      width: ScreenUtil().setWidth(200),
      height: ScreenUtil().setHeight(200),
      child: Image.network(list[index].image),
    );
  }

  _goodsName(list, index) {
    return Container(
      width: ScreenUtil().setWidth(370),
      child: Text(
        list[index].goodsName,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontSize: ScreenUtil().setSp(28)),
      ),
    );
  }

  _goodsPrice(list, index) {
    return Container(
      width: ScreenUtil().setWidth(370),
      child: Row(
        children: <Widget>[
          Text(
            '价格:￥${list[index].presentPrice}',
            style: TextStyle(fontSize: ScreenUtil().setSp(28)),
          ),
          Text(
            '￥${list[index].oriPrice}',
            style: TextStyle(fontSize: ScreenUtil().setSp(28)),
          )
        ],
      ),
    );
  }
}
