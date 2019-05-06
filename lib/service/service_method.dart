import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';

import '../config/service_url.dart';

Future requestHttp(url, {formData}) async {
  try {
    Response response;
    Dio dio = Dio();
    dio.options.contentType =
        ContentType.parse('application/x-www-form-urlencoded');
    if (formData != null) {
      response = await dio.post(servicePath[url], data: formData);
    } else {
      response = await dio.post(servicePath[url]);
    }

    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('后端接口有问题');
    }
  } catch (e) {
    return print('出现异常$e');
  }
}

Future getHomePageContent() async {
  try {
    Response response;
    var formData = {'lon': '104.07642', 'lat': '38.6518'};

    Dio dio = Dio();
    dio.options.contentType =
        ContentType.parse('application/x-www-form-urlencoded');
    response = await dio.post(servicePath['homePageContext'], data: formData);
    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('后端接口有问题');
    }
  } catch (e) {
    return print('出现异常$e');
  }
}

Future getHomeHotGoods() async {
  try {
    Response response;
    Dio dio = Dio();
    int page = 1;
    dio.options.contentType =
        ContentType.parse('application/x-www-form-urlencoded');
    response = await dio.post(servicePath['homePageBelowContent'], data: page);
    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('后端接口有问题');
    }
  } catch (e) {
    return print('出现异常$e');
  }
}
