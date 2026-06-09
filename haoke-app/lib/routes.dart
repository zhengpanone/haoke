import 'package:fluro/fluro.dart';
import 'package:haoke_app/routes_handlers.dart';

class Routes {
  // 1. 定义路由名称
  static const String home = '/';
  static const String notFound = '/notFound';
  static const String login = '/login';
  static const String register = '/register';
  static const String roomDetail = '/roomDetail/:roomId';
  static const String profile = '/profile';
  static const String profileEdit = '/profile/edit';
  static const String settings = '/settings';
  static const String roomManage = '/roomManage';
  static const String roomAdd = '/roomAdd';
  static const String communitySelect = '/communitySelect';
  static const String viewingHistory = '/viewingHistory';
  static const String myOrders = '/myOrders';
  static const String myFavorites = '/myFavorites';
  static const String identityVerification = '/identityVerification';
  static const String contactUs = '/contactUs';
  static const String eContract = '/eContract';
  static const String wallet = '/wallet';
  static const String search = '/search';

  // 2. 配置路由
  static void configureRoutes(FluroRouter router) {
    // 2.1. 配置未找到路由页面
    router.notFoundHandler = notFoundHandler;

    // 2.2. 配置路由
    router.define(home, handler: homeHandler);
    router.define(login, handler: loginHandler);
    router.define(register, handler: registerHandler);
    router.define(roomDetail, handler: roomDetailHandler);
    router.define(profileEdit, handler: profileEditHandler);
    router.define(settings, handler: settingsHandler);
    router.define(roomManage, handler: roomManageHandler);
    router.define(roomAdd, handler: roomAddHandler);
    router.define(communitySelect, handler: communitySelectHandler);
    router.define(viewingHistory, handler: viewingHistoryHandler);
    router.define(myOrders, handler: myOrdersHandler);
    router.define(myFavorites, handler: myFavoritesHandler);
    router.define(identityVerification, handler: identityVerificationHandler);
    router.define(contactUs, handler: contactUsHandler);
    router.define(eContract, handler: eContractHandler);
    router.define(wallet, handler: walletHandler);
    router.define(search, handler: searchHandler);
  }
}
