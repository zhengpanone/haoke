import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:haoke_rent/pages/home/index.dart';
import 'package:haoke_rent/pages/login.dart';
import 'package:haoke_rent/pages/not_found.dart';
import 'package:haoke_rent/pages/register.dart';
import 'package:haoke_rent/pages/room_add/index.dart';
import 'package:haoke_rent/pages/room_detail/index.dart';
import 'package:haoke_rent/pages/room_manage/index.dart';
import 'package:haoke_rent/pages/settings/index.dart';

Handler homeHandler = Handler(
  handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
    return const HomePage();
  },
);

Handler loginHandler = Handler(
  handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
    return const LoginPage();
  },
);

Handler registerHandler = Handler(
  handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
    return const RegisterPage();
  },
);

Handler notFoundHandler = Handler(
  handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
    return const NotFoundPage();
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
    return const SettingsPage();
  },
);

Handler roomManageHandler = Handler(
  handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
    return const RoomManage();
  },
);

Handler roomAddHandler = Handler(
  handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
    return const RoomAdd();
  },
);
