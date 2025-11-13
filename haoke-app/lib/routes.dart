import 'package:fluro/fluro.dart';
import 'package:haoke_rent/routes_handlers.dart';

class Routes {
  // 1. 定义路由名称
  static const String home = '/';
  static const String notFound = '/notFound';
  static const String login = '/login';
  static const String register = '/register';
  static const String roomDetail = '/roomDetail/:roomId';
  static const String profile = '/profile';
  static const String settings = '/settings';
  static const String roomManage = '/roomManage';
  static const String roomAdd = '/roomAdd';

  // 2. 配置路由
  static void configureRoutes(FluroRouter router) {
    // 2.1. 配置未找到路由页面
    router.notFoundHandler = notFoundHandler;

    // 2.2. 配置路由
    router.define(home, handler: homeHandler);
    router.define(login, handler: loginHandler);
    router.define(register, handler: registerHandler);
    router.define(roomDetail, handler: roomDetailHandler);
    router.define(settings, handler: settingsHandler);
    router.define(roomManage, handler: roomManageHandler);
    router.define(roomAdd, handler: roomAddHandler);
  }
}
