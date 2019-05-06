import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ThenPage extends StatefulWidget {
  @override
  _ThenPageState createState() => _ThenPageState();
}

class _ThenPageState extends State<ThenPage> {
  TextEditingController typeController = TextEditingController();
  String showText = '11111111111111';

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        resizeToAvoidBottomPadding: false, //防止输入法弹出的手，页面显示问题

        appBar: AppBar(
          title: Text('天上人间'),
        ),
        body: Column(
          children: <Widget>[
            TextField(
              controller: typeController,
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(10.0),
                  labelText: '不好d',
                  helperText: '你好',
                  hintText: '1111'),
              autofocus: false,
            ),
            RaisedButton(
              onPressed: _chooseAction,
              child: Text('提交'),
            ),
            Text(
              showText,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ],
        ),
      ),
    );
  }

  _chooseAction() {
    if (typeController.text.toString() == '') {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text('aaaaaaaaaaaaaaa'),
              ));
    } else {
      getHttp(typeController.text.toString()).then((data) {
        setState(() {
          showText = data['data']['name'].toString();
        });
      });
    }
  }
}

Future getHttp(content) async {
  try {
    Response response;
    var data = {'name': content};
    response = await Dio().get(
        "http://www.easy-mock.com/mock/5c60131a4bed3a6342711498/baixing/dabaojian?name=$content");
    return response.data;
  } catch (e) {
    return print(e);
  }
}
