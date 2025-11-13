import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:haoke_rent/pages/home/index.dart';
import 'package:haoke_rent/pages/login.dart';
import 'package:haoke_rent/pages/not_found.dart';
import 'package:haoke_rent/pages/register.dart';
import 'package:haoke_rent/pages/room_add/index.dart';
import 'package:haoke_rent/pages/room_detail/index.dart';
import 'package:haoke_rent/pages/room_manage/index.dart';
import 'package:haoke_rent/pages/settings.dart';

Handler homeHandler = Handler(
  handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
    return HomePage();
  },
);

Handler loginHandler = Handler(
  handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
    return LoginPage();
  },
);

Handler registerHandler = Handler(
  handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
    return RegisterPage();
  },
);

Handler notFoundHandler = Handler(
  handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
    return NotFoundPage();
  },
);

// 房源详情页
Handler roomDetailHandler = Handler(
  handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
    return RoomDetailPage(roomId: params['roomId']![0]);
  },
);

// 设置
Handler settingsHandler = Handler(
  handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
    return Settings();
  },
);

Handler roomManageHandler = Handler(
  handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
    return RoomManage();
  },
);

Handler roomAddHandler = Handler(
  handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
    return RoomAdd();
  },
);
