import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

import '../routes/application.dart';
import '../service/service_method.dart';
import '../weight/easy_refresh.dart';
import '../weight/flutter_screenutil.dart';
import '../weight/url_launcher.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true; //保持页面状态 不会重新加载

  int page = 1;
  List<Map> hotGoodsList = [];

  GlobalKey<RefreshFooterState> _footerKey = GlobalKey<RefreshFooterState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var formData = {'lon': '104.07642', 'lat': '38.6518'};
    return Scaffold(
      appBar: AppBar(
        title: Text('百姓生活'),
      ),
      body: FutureBuilder(
        builder: (context, snapshots) {
          if (snapshots.hasData) {
            Map data = json.decode(snapshots.data.toString()); //json串转Map
            Map map = data['data'];
            List<Map> swiper = (map['slides'] as List).cast<Map>();
            List<Map> navgator = (map['category'] as List).cast<Map>();
            String picUrl = map['advertesPicture']['PICTURE_ADDRESS'];
            String leaderImage = map['shopInfo']['leaderImage'];
            String leaderPhone = map['shopInfo']['leaderPhone'];
            List<Map> recommendList = (map['recommend'] as List).cast(); // 商品推荐

            String floor1Title = map['floor1Pic']['PICTURE_ADDRESS']; //楼层1的标题图片
            String floor2Title = map['floor2Pic']['PICTURE_ADDRESS']; //楼层1的标题图片
            String floor3Title = map['floor3Pic']['PICTURE_ADDRESS']; //楼层1的标题图片
            List<Map> floor1 = (map['floor1'] as List).cast(); //楼层1商品和图片
            List<Map> floor2 = (map['floor2'] as List).cast(); //楼层1商品和图片
            List<Map> floor3 = (map['floor3'] as List).cast(); //楼层1商品和图片
            //  List swiper = map['slides'];
            return EasyRefresh(
              child: ListView(
                children: <Widget>[
                  SwiperDiy(swiperList: swiper),
                  TopNavgatorView(navgatorList: navgator),
                  AdBanner(picUrl: picUrl),
                  LeaderPhone(
                      leaderImage: leaderImage, leaderPhone: leaderPhone),
                  Recommed(recommedList: recommendList),
                  FloorTitle(titleImage: floor1Title),
                  FloorContent(goodsList: floor1),
                  FloorTitle(titleImage: floor2Title),
                  FloorContent(goodsList: floor2),
                  FloorTitle(titleImage: floor3Title),
                  FloorContent(goodsList: floor3),
                  _hotGoods(),
                ],
              ),
              loadMore: () async {
                var formData = {'page': page};
                await requestHttp('homePageBelowConten', formData: formData)
                    .then((val) {
                  var data = jsonDecode(val.toString());
                  List<Map> newGoodsList = (data['data'] as List).cast();
                  setState(() {
                    hotGoodsList.addAll(newGoodsList);
                    page++;
                  });
                });
              },
              refreshFooter: ClassicsFooter(
                  key: _footerKey,
                  bgColor: Colors.white,
                  textColor: Colors.pink,
                  moreInfoColor: Colors.pink,
                  showMore: true,
                  noMoreText: '',
                  moreInfo: '加载中11',
                  loadReadyText: '上拉加载22....'),
            );

            /* return SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  SwiperDiy(swiperList: swiper),
                  TopNavgatorView(navgatorList: navgator),
                  AdBanner(picUrl: picUrl),
                  LeaderPhone(
                      leaderImage: leaderImage, leaderPhone: leaderPhone),
                  Recommed(recommedList: recommendList),
                  FloorTitle(titleImage: floor1Title),
                  FloorContent(goodsList: floor1),
                  FloorTitle(titleImage: floor2Title),
                  FloorContent(goodsList: floor2),
                  FloorTitle(titleImage: floor3Title),
                  FloorContent(goodsList: floor3),
                  _hotGoods(),
                ],
              ),
            );*/
          } else {
            return Center(child: Text('加载中'));
          }
        },
        future: requestHttp('homePageContext', formData: formData),
      ),
    );
  }

  Widget hotTitle = Container(
    child: Text('火爆专区'),
    color: Colors.transparent,
    padding: EdgeInsets.all(5.0),
    alignment: Alignment.center,
  );

  Widget wrapList() {
    if (hotGoodsList.length != 0) {
      List<Widget> listWidget = hotGoodsList.map((val) {
        return InkWell(
          onTap: () {
            Application.router
                .navigateTo(context, "/detail?id=${val['goodsId']}");
          },
          child: Container(
            width: ScreenUtil().setWidth(372),
            color: Colors.white,
            padding: EdgeInsets.all(5.0),
            margin: EdgeInsets.only(bottom: 3.0),
            child: Column(
              children: <Widget>[
                Image.network(val['image'], width: ScreenUtil().setWidth(375)),
                Text(
                  val['name'],
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: Colors.pink, fontSize: ScreenUtil().setSp(26)),
                ),
                Row(
                  children: <Widget>[
                    Text('￥${val['mallPrice']}'),
                    Text('${val['price']}',
                        style:
                            TextStyle(decoration: TextDecoration.lineThrough))
                  ],
                )
              ],
            ),
          ),
        );
      }).toList();
      return Wrap(spacing: 2, children: listWidget);
    } else {
      return Text('');
    }
  }

  Widget _hotGoods() {
    return Container(
      child: Column(
        children: <Widget>[hotTitle, wrapList()],
      ),
    );
  }
}

//首页banner
class SwiperDiy extends StatelessWidget {
  final List swiperList;

  SwiperDiy({Key key, this.swiperList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil().setWidth(330),
      child: Swiper(
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            onTap: () {
              Application.router.navigateTo(
                  context, "/detail?id=${swiperList[index]['goodsId']}");
            },
            child: Image.network(
              swiperList[index]['image'],
              fit: BoxFit.fill,
            ),
          );
        },
        itemCount: swiperList.length,
        pagination: SwiperPagination(),
        autoplay: true,
      ),
    );
  }
}

//下面的girdview
class TopNavgatorView extends StatelessWidget {
  final List navgatorList;

  TopNavgatorView({Key key, this.navgatorList}) : super(key: key);

  Widget _singTopView(item) {
    return InkWell(
      onTap: () {
        print('11111111111');
      },
      child: Column(
        children: <Widget>[
          Image.network(
            item['image'],
            width: ScreenUtil().setWidth(95),
            height: ScreenUtil().setHeight(95),
          ),
          Text(item['mallCategoryName'])
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (navgatorList.length > 10) {
      navgatorList.removeRange(10, navgatorList.length);
    }
    return Container(
      /*color: Colors.amber,*/
      height: ScreenUtil().setHeight(320),
      padding: EdgeInsets.all(5.0),
      child: GridView.count(
        crossAxisCount: 5,
        physics: NeverScrollableScrollPhysics(),
        children: navgatorList.map((item) {
          return _singTopView(item);
        }).toList(),
      ),
    );
  }
}

//广告banner
class AdBanner extends StatelessWidget {
  String picUrl;

  AdBanner({Key key, this.picUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.amber,
      child: Image.network(picUrl),
    );
  }
}

//首页电话
class LeaderPhone extends StatelessWidget {
  String leaderImage;
  String leaderPhone;

  LeaderPhone({Key key, this.leaderImage, this.leaderPhone}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: InkWell(
        onTap: _doPhone,
        child: Image.network(leaderImage),
      ),
    );
  }

  _doPhone() async {
    String url = 'tel:' + leaderPhone;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw '不正常的url';
    }
  }
}

//商品推荐
class Recommed extends StatelessWidget {
  List recommedList;

  Recommed({Key key, this.recommedList}) : super(key: key);

  //title
  Widget _titleWeiget() {
    return Container(
      height: ScreenUtil().setHeight(80),
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.only(left: 15.0),
      //居中方式
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border(bottom: BorderSide(width: 0.5, color: Colors.grey))),
      child: Text(
        '商品推荐',
        style: TextStyle(color: Colors.redAccent),
      ),
    );
  }

  //单个item
  Widget _item(context, index) {
    return InkWell(
      onTap: () {
        Application.router.navigateTo(
            context, "/detail?id=${recommedList[index]['goodsId']}");
      },
      child: Container(
        height: ScreenUtil().setHeight(360),
        width: ScreenUtil().setWidth(250),
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            right: BorderSide(width: 0.5, color: Colors.grey),
          ),
        ),
        child: Column(
          children: <Widget>[
            Image.network(
              recommedList[index]['image'],
            ),
            Text('￥${recommedList[index]['mallPrice']}',
                style: TextStyle(color: Colors.black54)),
            Text(
              '￥${recommedList[index]['price']}',
              style: TextStyle(
                decoration: TextDecoration.lineThrough, //删除线
                color: Colors.grey,
              ),
            )
          ],
        ),
      ),
    );
  }

  //列表数据
  Widget _RecommendList(context) {
    return Container(
      height: ScreenUtil().setHeight(330),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: recommedList.length,
        itemBuilder: (context, index) {
          return _item(context, index);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10.0),
      color: Colors.amberAccent,
      child: Container(
        child: Column(
          children: <Widget>[
            _titleWeiget(),
            _RecommendList(context),
          ],
        ),
      ),
    );
  }
}

//楼层效果
class FloorTitle extends StatelessWidget {
  final String titleImage;

  FloorTitle({Key key, this.titleImage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Image.network(
        titleImage,
        /*width: ScreenUtil().setWidth(375),*/
        height: ScreenUtil().setHeight(150),
      ),
    );
  }
}

//楼层商品组件
class FloorContent extends StatelessWidget {
  final List goodsList;

  FloorContent({Key key, this.goodsList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[_firstRow(context), _otherGoods(context)],
    );
  }

  _firstRow(context) {
    return Row(
      children: <Widget>[
        _bigGoodsItem(context, goodsList[0]),
        Column(
          children: <Widget>[
            _goodsItem(context, goodsList[1]),
            _goodsItem(context, goodsList[2]),
          ],
        )
      ],
    );
  }

  _otherGoods(context) {
    return Row(
      children: <Widget>[
        _goodsItem(context, goodsList[3]),
        _goodsItem(context, goodsList[4]),
      ],
    );
  }

  _goodsItem(context, goods) {
    return InkWell(
      onTap: () {
        Application.router
            .navigateTo(context, "/detail?id=${goods['goodsId']}");
      },
      child: Container(
        width: ScreenUtil().setWidth(375),
        height: ScreenUtil().setWidth(200),
        child: Image.network(goods['image']),
      ),
    );
  }

  _bigGoodsItem(context, goods) {
    return InkWell(
      onTap: () {
        Application.router
            .navigateTo(context, "/detail?id=${goods['goodsId']}");
      },
      child: Container(
        width: ScreenUtil().setWidth(375),
        height: ScreenUtil().setWidth(400),
        child: Image.network(goods['image']),
      ),
    );
  }
}
