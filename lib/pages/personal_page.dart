import 'package:flutter/material.dart';
import 'package:flutter_shop/weight/src/cached_image_widget.dart';

import '../weight/flutter_screenutil.dart';

class PersonalPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('会员中心'),
      ),
      body: ListView(
        children: <Widget>[
          /* _demoWidget(context),*/
          _topHeader(),
          _orderTitle(),
          _orderType(),
          _actionList(),
        ],
      ),
    );
  }

  Widget _topHeader() {
    return Container(
      width: ScreenUtil().setWidth(750),
      padding: EdgeInsets.all(20),
      color: Colors.pinkAccent,
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 30),
            child: ClipOval(
              child: Image.network(
                'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1556532393846&di=2817eb4509ed9d604fbd59abc4259013&imgtype=0&src=http%3A%2F%2Fhbimg.b0.upaiyun.com%2F00bc8151242c7d2460d0b7d4b913c6ed97f957cc158f9-SXd0Yk_fw658',
                width: 200.0,
                height: 200.0,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 10),
            child: Text(
              'ydd',
              style: TextStyle(
                fontSize: ScreenUtil().setSp(36),
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
    );
  }

  //我的订单顶部
  Widget _orderTitle() {
    return Container(
      margin: EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border(bottom: BorderSide(width: 1, color: Colors.black12))),
      child: ListTile(
        leading: Icon(Icons.list),
        title: Text('我的订单'),
        trailing: Icon(Icons.arrow_right),
      ),
    );
  }

  Widget _orderType() {
    return Container(
      margin: EdgeInsets.only(top: 5),
      width: ScreenUtil().setWidth(750),
      height: ScreenUtil().setHeight(150),
      padding: EdgeInsets.only(top: 20),
      color: Colors.white,
      child: Row(
        children: <Widget>[
          Container(
            width: ScreenUtil().setWidth(187),
            child: Column(
              children: <Widget>[
                Icon(
                  Icons.party_mode,
                  size: 30,
                ),
                Text('待付款'),
              ],
            ),
          ),
          //-----------------
          Container(
            width: ScreenUtil().setWidth(187),
            child: Column(
              children: <Widget>[
                Icon(
                  Icons.query_builder,
                  size: 30,
                ),
                Text('待发货'),
              ],
            ),
          ),
          //-----------------
          Container(
            width: ScreenUtil().setWidth(187),
            child: Column(
              children: <Widget>[
                Icon(
                  Icons.directions_car,
                  size: 30,
                ),
                Text('待收货'),
              ],
            ),
          ),
          Container(
            width: ScreenUtil().setWidth(187),
            child: Column(
              children: <Widget>[
                Icon(
                  Icons.content_paste,
                  size: 30,
                ),
                Text('待评价'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _myListTile(String title) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border(bottom: BorderSide(width: 1, color: Colors.black12))),
      child: ListTile(
        leading: Icon(Icons.blur_circular),
        title: Text(title),
        trailing: Icon(Icons.arrow_right),
      ),
    );
  }

  Widget _actionList() {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Column(
        children: <Widget>[
          _myListTile('领取优惠券'),
          _myListTile('已领取优惠券'),
          _myListTile('地址管理'),
          _myListTile('客服电话'),
          _myListTile('关于我们'),
        ],
      ),
    );
  }

  Widget _demoWidget(context) {
    return Column(
      children: <Widget>[
        CachedNetworkImage(
          //带缓存的网络图片
          imageUrl:
              'http://pic15.nipic.com/20110628/1369025_192645024000_2.jpg',
          placeholder: (context, url) => new CircularProgressIndicator(),
          errorWidget: (context, url, error) => new Icon(Icons.error),
        ),
        CloseButton(),
        BackButton(),
        FractionallySizedBox(
            //盛满宽度
            widthFactor: 1,
            child: Container(
              decoration: BoxDecoration(color: Colors.red),
              child: InkWell(
                child: Text('11111111'),
                onTap: () {
                  _bottomDialog(context);
                },
              ),
            )),
        Image(width: 100, height: 100, image: AssetImage('images/aaa.png')),
        Chip(
          label: Text('个人中心chip'),
          /*avatar: CircleAvatar(
            backgroundColor: Colors.blue,
            child: Text('1'),
          ),*/
          avatar: Icon(
            Icons.people,
            color: Colors.blue,
            size: 20,
          ),
          backgroundColor: Colors.red,
        ),
        ClipRRect(
          //圆角矩形
          borderRadius: BorderRadius.circular(50),
          child: Image(
              image: AssetImage('images/aaa.png'), width: 100, height: 100),
        ),
        ClipOval(
          //圆形裁剪
          child: Image.asset(
            "images/aaa.png",
            width: 100.0,
            height: 100.0,
            fit: BoxFit.cover,
          ),
        ),
        CircleAvatar(
          backgroundImage: NetworkImage(
              'https://ss0.baidu.com/6ONWsjip0QIZ8tyhnq/it/u=3463668003,3398677327&fm=58'),
          child: new Text("李二"),
          radius: 50, //半径
        ),
        Divider(
          //这个高是容器的高度，设置不了线的高度
          height: 10,
          indent: 30, //距离左侧边距
          color: Colors.red,
        ),
        AlertDialog(
          title: Text('11111111'),
          content: Text('222222222222222222222222'),
        ),
      ],
    );
  }

  _bottomDialog(context) {
    return showModalBottomSheet(
        context: context,
        builder: (context) => Container(
              height: 140,
              child: Column(
                children: <Widget>[
                  Text('我是bottom弹出框'),
                  Image.asset(
                    'images/aaa.png',
                    width: 100,
                    height: 100,
                  ),
                ],
              ),
            ));
  }
}
