import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:haoke_app/pages/home/index.dart';
import 'package:haoke_app/pages/login.dart';
import 'package:haoke_app/pages/not_found.dart';
import 'package:haoke_app/pages/profile_edit/index.dart';
import 'package:haoke_app/pages/register.dart';
import 'package:haoke_app/pages/community_select/index.dart';
import 'package:haoke_app/pages/room_add/index.dart';
import 'package:haoke_app/pages/room_detail/index.dart';
import 'package:haoke_app/pages/room_manage/index.dart';
import 'package:haoke_app/pages/settings/index.dart';
import 'package:haoke_app/pages/viewing_history/index.dart';

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
Handler profileEditHandler = Handler(
  handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
    return const ProfileEditPage();
  },
);

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

Handler communitySelectHandler = Handler(
  handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
    return const CommunitySelectPage();
  },
);

Handler viewingHistoryHandler = Handler(
  handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
    return const ViewingHistoryPage();
  },
);
