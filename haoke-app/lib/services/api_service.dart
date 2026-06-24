// ignore_for_file: use_null_aware_elements

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:haoke_app/models/common/api_response.dart';
import 'package:haoke_app/models/auth/login_request.dart';
import 'package:haoke_app/models/auth/login_response.dart';
import 'package:haoke_app/models/city/city_model.dart';
import 'package:haoke_app/models/community/community_model.dart';
import 'package:haoke_app/models/news/news_article.dart';
import 'package:haoke_app/models/profile/profile_models.dart';
import 'package:haoke_app/models/room/room_model.dart';
import 'package:haoke_app/models/room/room_publish_request.dart';
import 'package:haoke_app/models/user/update_user_profile_request.dart';
import 'package:haoke_app/models/user/user_model.dart';
import 'package:haoke_app/pages/room_detail/data.dart';
import 'package:haoke_app/services/dio_client.dart';
import 'package:haoke_app/services/storage_service.dart';
import 'package:haoke_app/utils/logger.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();

  factory ApiService() => _instance;

  ApiService._internal();

  final Dio _dio = DioClient().client;

  final StorageService _storage = StorageService.instance;

  // 用户注册
  Future<ApiResponse<LoginResponse>> register(RegisterRequest request) async {
    try {
      final response = await _dio.post(
        '/api/auth/register',
        data: request.toJson(),
      );
      final apiResponse = ApiResponse<LoginResponse>.fromJson(
        response.data,
        (data) => LoginResponse.fromJson(data as Map<String, dynamic>),
      );
      if (apiResponse.isSuccess && apiResponse.data != null) {
        await _persistLoginSession(apiResponse.data!);
      }
      return apiResponse;
    } catch (e) {
      AppLogger.e('用户注册失败： $e');
      rethrow;
    }
  }

  // 用户登录
  Future<ApiResponse<LoginResponse>> login(LoginRequest request) async {
    try {
      final response = await _dio.post(
        '/api/auth/login',
        data: request.toJson(),
      );
      final apiResponse = ApiResponse<LoginResponse>.fromJson(
        response.data,
        (data) => LoginResponse.fromJson(data as Map<String, dynamic>),
      );

      if (apiResponse.isSuccess && apiResponse.data != null) {
        await _persistLoginSession(apiResponse.data!);
      }
      AppLogger.i(apiResponse);
      return apiResponse;
    } catch (e) {
      AppLogger.e('用户登录失败: $e');
      rethrow;
    }
  }

  /// 持久化登录会话：保存 Token、用户信息与登录态
  Future<void> _persistLoginSession(LoginResponse data) async {
    await _storage.saveToken(data.token);
    final user = UserModel(
      id: data.userId,
      username: data.username,
      email: data.email,
      phone: data.phone,
      avatar: data.avatar,
      nickname: data.nickname,
      gender: data.gender ?? 'UNKNOWN',
      type: data.type ?? 'NORMAL',
      createTime: DateTime.now(),
      updateTime: DateTime.now(),
    );
    await _storage.saveUser(user);
    await _storage.saveLoginState(true);
  }

  /// 退出登录
  Future<ApiResponse<void>> logout() async {
    try {
      // Authorization 头由 DioClient 的鉴权拦截器统一附加
      final response = await _dio.post('/api/auth/logout');
      return ApiResponse.emptyFromJson(response.data);
    } catch (e) {
      AppLogger.e('退出登录失败: $e');
      rethrow;
    } finally {
      // 无论服务端登出成败，都清除本地登录态
      await _storage.clearAll();
    }
  }

  /// 解绑手机号
  Future<ApiResponse<UserModel>> unbindPhone() async {
    try {
      final response = await _dio.post('/api/user/unbindPhone');
      final apiResponse = ApiResponse<UserModel>.fromJson(
        response.data,
        (data) => UserModel.fromJson(data as Map<String, dynamic>),
      );
      if (apiResponse.isSuccess && apiResponse.data != null) {
        await _storage.saveUser(apiResponse.data!);
      }
      return apiResponse;
    } catch (e) {
      AppLogger.e('解绑手机号失败: $e');
      rethrow;
    }
  }

  //获取当前用户信息
  Future<ApiResponse<UserModel>> getCurrentUser() async {
    try {
      final response = await _dio.get('/api/user/me');
      return ApiResponse<UserModel>.fromJson(
        response.data,
        (data) => UserModel.fromJson(data as Map<String, dynamic>),
      );
    } catch (e) {
      AppLogger.e('获取用户信息失败：$e');
      rethrow;
    }
  }

  Future<ApiResponse<UserModel>> updateCurrentUser(
    UpdateUserProfileRequest request,
  ) async {
    try {
      final response = await _dio.put('/api/user/me', data: request.toJson());
      final apiResponse = ApiResponse<UserModel>.fromJson(
        response.data,
        (data) => UserModel.fromJson(data as Map<String, dynamic>),
      );
      if (apiResponse.isSuccess && apiResponse.data != null) {
        await _storage.saveUser(apiResponse.data!);
      }
      return apiResponse;
    } catch (e) {
      AppLogger.e('Update current user failed: $e');
      rethrow;
    }
  }

  Future<ApiResponse<void>> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      final response = await _dio.post(
        '/api/user/password',
        data: {'oldPassword': oldPassword, 'newPassword': newPassword},
      );
      return ApiResponse.emptyFromJson(response.data);
    } catch (e) {
      AppLogger.e('Change password failed: $e');
      rethrow;
    }
  }

  Future<ApiResponse<String>> sendPhoneCode(String phone) async {
    try {
      final response = await _dio.post(
        '/api/user/phone/code',
        data: {'phone': phone},
      );
      return ApiResponse<String>.fromJson(
        response.data,
        (data) => data?.toString() ?? '',
      );
    } catch (e) {
      AppLogger.e('Send phone code failed: $e');
      rethrow;
    }
  }

  Future<ApiResponse<UserModel>> bindPhone({
    required String phone,
    required String code,
  }) async {
    try {
      final response = await _dio.post(
        '/api/user/phone/bind',
        data: {'phone': phone, 'code': code},
      );
      final apiResponse = ApiResponse<UserModel>.fromJson(
        response.data,
        (data) => UserModel.fromJson(data as Map<String, dynamic>),
      );
      if (apiResponse.isSuccess && apiResponse.data != null) {
        await _storage.saveUser(apiResponse.data!);
      }
      return apiResponse;
    } catch (e) {
      AppLogger.e('Bind phone failed: $e');
      rethrow;
    }
  }

  Future<ApiResponse<String>> uploadAvatar(File file) async {
    try {
      final fileName = file.path.split(RegExp(r'[\\/]')).last;
      final response = await _dio.post(
        '/api/file/avatar',
        data: FormData.fromMap({
          'file': await MultipartFile.fromFile(file.path, filename: fileName),
        }),
      );
      return ApiResponse<String>.fromJson(
        response.data,
        (data) => data.toString(),
      );
    } catch (e) {
      AppLogger.e('Upload avatar failed: $e');
      rethrow;
    }
  }

  Future<ApiResponse<String>> uploadHouseImage(File file) async {
    try {
      final fileName = file.path.split(RegExp(r'[\\/]')).last;
      final response = await _dio.post(
        '/api/file/house',
        data: FormData.fromMap({
          'file': await MultipartFile.fromFile(file.path, filename: fileName),
        }),
      );
      return ApiResponse<String>.fromJson(
        response.data,
        (data) => data.toString(),
      );
    } catch (e) {
      AppLogger.e('Upload house image failed: $e');
      rethrow;
    }
  }

  Future<ApiResponse<List<CommunityModel>>> queryCommunities({
    String keyword = '',
  }) async {
    try {
      final response = await _dio.post(
        '/api/house/community/page',
        data: {'keyword': keyword, 'pageNum': 1, 'pageSize': 20},
      );
      final responseData = response.data;
      if (responseData is! Map<String, dynamic>) {
        throw FormatException(
          'Invalid community response: ${response.statusCode}',
        );
      }

      return ApiResponse<List<CommunityModel>>.fromJson(
        responseData,
        (data) => (data as List)
            .map(
              (item) => CommunityModel.fromJson(item as Map<String, dynamic>),
            )
            .toList(),
      );
    } catch (e) {
      AppLogger.e('Query communities failed: $e');
      rethrow;
    }
  }

  Future<ApiResponse<List<CityModel>>> queryCityTree() async {
    try {
      final response = await _dio.get('/api/house/city/tree');
      return ApiResponse<List<CityModel>>.fromJson(
        response.data,
        (data) => (data as List)
            .map((item) => CityModel.fromJson(item as Map<String, dynamic>))
            .toList(),
      );
    } catch (e) {
      AppLogger.e('Query city tree failed: $e');
      rethrow;
    }
  }

  // 创建小区
  Future<ApiResponse<CommunityModel>> createCommunity(
    CommunityModel community,
  ) async {
    try {
      final response = await _dio.post(
        '/api/house/community/create',
        data: community.toCreateJson(),
      );
      return ApiResponse<CommunityModel>.fromJson(
        response.data,
        (data) => CommunityModel.fromJson(data as Map<String, dynamic>),
      );
    } catch (e) {
      AppLogger.e('Create community failed: $e');
      rethrow;
    }
  }

  Future<ApiResponse<void>> publishRoom(RoomPublishRequest request) async {
    try {
      final response = await _dio.post(
        '/api/house/resource/create',
        data: request.toJson(),
      );
      return ApiResponse.emptyFromJson(response.data);
    } catch (e) {
      AppLogger.e('Publish room failed: $e');
      rethrow;
    }
  }

  Future<ApiResponse<RoomDetailData>> queryRoomDetail(String roomId) async {
    try {
      final response = await _dio.get('/api/house/resource/$roomId');
      return ApiResponse<RoomDetailData>.fromJson(
        response.data,
        (data) => RoomDetailData.fromJson(data as Map<String, dynamic>),
      );
    } catch (e) {
      AppLogger.e('Query room detail failed: $e');
      rethrow;
    }
  }

  /// 查询房源（我发布的 空置/已出租）
  /// [status] 可选过滤：VACANT（空置中）、RENTED（已出租），不传则查全部
  Future<ApiResponse<List<RoomModel>>> queryRooms({
    String? keyword,
    String? status,
    List<String>? statusList,
    int? rentMethod,
    int? minRent,
    int? maxRent,
    List<String>? houseTypes,
    List<String>? floorKeywords,
    List<int>? orientations,
    List<int>? decorations,
    int pageNum = 1,
    int pageSize = 10,
  }) {
    return _queryRoomList(
      '/api/house/resource/page',
      keyword: keyword,
      status: status,
      statusList: statusList,
      rentMethod: rentMethod,
      minRent: minRent,
      maxRent: maxRent,
      houseTypes: houseTypes,
      floorKeywords: floorKeywords,
      orientations: orientations,
      decorations: decorations,
      pageNum: pageNum,
      pageSize: pageSize,
    );
  }

  Future<ApiResponse<List<RoomModel>>> queryRecommendedRooms({
    int pageNum = 1,
    int pageSize = 4,
  }) {
    return _queryRoomList(
      '/api/house/resource/recommend',
      pageNum: pageNum,
      pageSize: pageSize,
    );
  }

  Future<ApiResponse<List<RoomModel>>> queryHotRooms({
    int pageNum = 1,
    int pageSize = 10,
  }) {
    return _queryRoomList(
      '/api/house/resource/hot',
      pageNum: pageNum,
      pageSize: pageSize,
    );
  }

  Future<ApiResponse<List<NewsArticle>>> queryNewsArticles({
    int pageNum = 1,
    int pageSize = 10,
  }) async {
    try {
      final response = await _dio.post(
        '/api/news/page',
        data: {'pageNum': pageNum, 'pageSize': pageSize},
      );
      return ApiResponse<List<NewsArticle>>.fromJson(
        response.data,
        (data) => _extractList(data)
            .map((item) => NewsArticle.fromJson(item as Map<String, dynamic>))
            .toList(),
      );
    } catch (e) {
      AppLogger.e('Query news articles failed: $e');
      rethrow;
    }
  }

  Future<ApiResponse<NewsArticle>> queryNewsArticleDetail(String id) async {
    try {
      final response = await _dio.get('/api/news/$id');
      return ApiResponse<NewsArticle>.fromJson(
        response.data,
        (data) => NewsArticle.fromJson(data as Map<String, dynamic>),
      );
    } catch (e) {
      AppLogger.e('Query news detail failed: $e');
      rethrow;
    }
  }

  Future<ApiResponse<List<RoomModel>>> queryPublishRooms({
    String? status,
    List<String>? statusList,
    int pageNum = 1,
    int pageSize = 2,
  }) async {
    try {
      final requestData = <String, dynamic>{
        'pageNum': pageNum,
        'pageSize': pageSize,
      };
      if (status != null && status.isNotEmpty) {
        requestData['status'] = status;
      }
      if (statusList != null && statusList.isNotEmpty) {
        requestData['statusList'] = statusList;
      }

      final response = await _dio.post(
        '/api/house/resource/page',
        data: requestData,
      );
      final responseData = response.data;
      if (responseData is! Map<String, dynamic>) {
        throw FormatException('Invalid rooms response: ${response.statusCode}');
      }

      return ApiResponse<List<RoomModel>>.fromJson(responseData, (data) {
        // 后端返回分页结构，data 是 Map，items 在 data['items'] 中
        if (data is Map<String, dynamic>) {
          final items = data['items'] ?? data['records'] ?? data['list'] ?? [];
          return (items as List)
              .map((item) => RoomModel.fromJson(item as Map<String, dynamic>))
              .toList();
        }
        if (data is List) {
          return data
              .map((item) => RoomModel.fromJson(item as Map<String, dynamic>))
              .toList();
        }
        return <RoomModel>[];
      });
    } catch (e) {
      AppLogger.e('Query publish rooms failed: $e');
      rethrow;
    }
  }

  Future<ApiResponse<List<ViewingRecordModel>>> queryViewingHistory({
    int pageNum = 1,
    int pageSize = 20,
  }) async {
    try {
      final response = await _dio.post(
        '/api/house/history/page',
        data: {'pageNum': pageNum, 'pageSize': pageSize},
      );
      return ApiResponse<List<ViewingRecordModel>>.fromJson(
        response.data,
        (data) => _extractList(data)
            .map(
              (item) =>
                  ViewingRecordModel.fromJson(item as Map<String, dynamic>),
            )
            .toList(),
      );
    } catch (e) {
      AppLogger.e('Query viewing history failed: $e');
      rethrow;
    }
  }

  Future<ApiResponse<ViewingRecordModel>> createViewingRecord({
    required String houseId,
    String? title,
    String? address,
    DateTime? appointmentTime,
    String? note,
  }) async {
    try {
      final response = await _dio.post(
        '/api/house/history/create',
        data: {
          'houseId': houseId,
          if (title != null) 'title': title,
          if (address != null) 'address': address,
          if (appointmentTime != null)
            'appointmentTime': appointmentTime.toIso8601String(),
          if (note != null) 'note': note,
        },
      );
      return ApiResponse<ViewingRecordModel>.fromJson(
        response.data,
        (data) => ViewingRecordModel.fromJson(data as Map<String, dynamic>),
      );
    } catch (e) {
      AppLogger.e('Create viewing record failed: $e');
      rethrow;
    }
  }

  Future<ApiResponse<List<HouseOrderModel>>> queryMyOrders({
    int pageNum = 1,
    int pageSize = 20,
  }) async {
    try {
      final response = await _dio.post(
        '/api/house/order/page',
        data: {'pageNum': pageNum, 'pageSize': pageSize},
      );
      return ApiResponse<List<HouseOrderModel>>.fromJson(
        response.data,
        (data) => _extractList(data)
            .map(
              (item) => HouseOrderModel.fromJson(item as Map<String, dynamic>),
            )
            .toList(),
      );
    } catch (e) {
      AppLogger.e('Query orders failed: $e');
      rethrow;
    }
  }

  Future<ApiResponse<HouseOrderModel>> createOrder({
    required String houseId,
    required String title,
    String? address,
    double? amount,
  }) async {
    try {
      final response = await _dio.post(
        '/api/house/order/create',
        data: {
          'houseId': houseId,
          'title': title,
          if (address != null) 'address': address,
          if (amount != null) 'amount': amount,
          'status': 'PENDING_SIGN',
          'actionText': '去签约',
        },
      );
      return ApiResponse<HouseOrderModel>.fromJson(
        response.data,
        (data) => HouseOrderModel.fromJson(data as Map<String, dynamic>),
      );
    } catch (e) {
      AppLogger.e('Create order failed: $e');
      rethrow;
    }
  }

  Future<ApiResponse<List<HouseFavoriteModel>>> queryMyFavorites({
    int pageNum = 1,
    int pageSize = 20,
  }) async {
    try {
      final response = await _dio.post(
        '/api/house/favorite/page',
        data: {'pageNum': pageNum, 'pageSize': pageSize},
      );
      return ApiResponse<List<HouseFavoriteModel>>.fromJson(
        response.data,
        (data) => _extractList(data)
            .map(
              (item) =>
                  HouseFavoriteModel.fromJson(item as Map<String, dynamic>),
            )
            .toList(),
      );
    } catch (e) {
      AppLogger.e('Query favorites failed: $e');
      rethrow;
    }
  }

  Future<ApiResponse<HouseFavoriteModel>> addFavorite({
    required String houseId,
    String? title,
    String? address,
    double? price,
    List<String>? tags,
    String? imageUrl,
  }) async {
    try {
      final response = await _dio.post(
        '/api/house/favorite/create',
        data: {
          'houseId': houseId,
          if (title != null) 'title': title,
          if (address != null) 'address': address,
          if (price != null) 'price': price,
          if (tags != null) 'tags': tags.join(','),
          if (imageUrl != null) 'imageUrl': imageUrl,
        },
      );
      return ApiResponse<HouseFavoriteModel>.fromJson(
        response.data,
        (data) => HouseFavoriteModel.fromJson(data as Map<String, dynamic>),
      );
    } catch (e) {
      AppLogger.e('Add favorite failed: $e');
      rethrow;
    }
  }

  Future<ApiResponse<void>> removeFavorite(String houseId) async {
    try {
      final response = await _dio.delete('/api/house/favorite/$houseId');
      return ApiResponse.emptyFromJson(response.data);
    } catch (e) {
      AppLogger.e('Remove favorite failed: $e');
      rethrow;
    }
  }

  Future<ApiResponse<bool>> checkFavorite(String houseId) async {
    try {
      final response = await _dio.get('/api/house/favorite/check/$houseId');
      return ApiResponse<bool>.fromJson(response.data, (data) => data == true);
    } catch (e) {
      AppLogger.e('Check favorite failed: $e');
      rethrow;
    }
  }

  Future<ApiResponse<IdentityVerificationModel>>
  getIdentityVerification() async {
    try {
      final response = await _dio.get('/api/user/identity/me');
      return ApiResponse<IdentityVerificationModel>.fromJson(
        response.data,
        (data) =>
            IdentityVerificationModel.fromJson(data as Map<String, dynamic>),
      );
    } catch (e) {
      AppLogger.e('Query identity verification failed: $e');
      rethrow;
    }
  }

  Future<ApiResponse<IdentityVerificationModel>> submitIdentityVerification({
    required String realName,
    required String idCardNo,
  }) async {
    try {
      final response = await _dio.post(
        '/api/user/identity/submit',
        data: {'realName': realName, 'idCardNo': idCardNo},
      );
      return ApiResponse<IdentityVerificationModel>.fromJson(
        response.data,
        (data) =>
            IdentityVerificationModel.fromJson(data as Map<String, dynamic>),
      );
    } catch (e) {
      AppLogger.e('Submit identity verification failed: $e');
      rethrow;
    }
  }

  Future<ApiResponse<List<ContactChannelModel>>> queryContactChannels() async {
    try {
      final response = await _dio.get('/api/support/contact');
      return ApiResponse<List<ContactChannelModel>>.fromJson(
        response.data,
        (data) => (data as List<dynamic>)
            .map(
              (item) =>
                  ContactChannelModel.fromJson(item as Map<String, dynamic>),
            )
            .toList(),
      );
    } catch (e) {
      AppLogger.e('Query contact channels failed: $e');
      rethrow;
    }
  }

  Future<ApiResponse<List<HouseContractModel>>> queryContracts({
    int pageNum = 1,
    int pageSize = 20,
  }) async {
    try {
      final response = await _dio.post(
        '/api/house/contract/page',
        data: {'pageNum': pageNum, 'pageSize': pageSize},
      );
      return ApiResponse<List<HouseContractModel>>.fromJson(
        response.data,
        (data) => _extractList(data)
            .map(
              (item) =>
                  HouseContractModel.fromJson(item as Map<String, dynamic>),
            )
            .toList(),
      );
    } catch (e) {
      AppLogger.e('Query contracts failed: $e');
      rethrow;
    }
  }

  Future<ApiResponse<HouseContractModel>> getContractByOrderId(
    String orderId,
  ) async {
    try {
      final response = await _dio.get('/api/house/contract/by-order/$orderId');
      return ApiResponse<HouseContractModel>.fromJson(
        response.data,
        (data) => HouseContractModel.fromJson(data as Map<String, dynamic>),
      );
    } catch (e) {
      AppLogger.e('Query contract by order failed: $e');
      rethrow;
    }
  }

  Future<ApiResponse<HouseContractModel>> signContract(
    String contractId,
  ) async {
    try {
      final response = await _dio.post('/api/house/contract/$contractId/sign');
      return ApiResponse<HouseContractModel>.fromJson(
        response.data,
        (data) => HouseContractModel.fromJson(data as Map<String, dynamic>),
      );
    } catch (e) {
      AppLogger.e('Sign contract failed: $e');
      rethrow;
    }
  }

  Future<ApiResponse<WalletOverviewModel>> queryWallet() async {
    try {
      final response = await _dio.get('/api/wallet/me');
      return ApiResponse<WalletOverviewModel>.fromJson(
        response.data,
        (data) => WalletOverviewModel.fromJson(data as Map<String, dynamic>),
      );
    } catch (e) {
      AppLogger.e('Query wallet failed: $e');
      rethrow;
    }
  }

  Future<ApiResponse<WalletOverviewModel>> rechargeWallet(double amount) async {
    try {
      final response = await _dio.post(
        '/api/wallet/recharge',
        data: {'amount': amount, 'title': '钱包充值'},
      );
      return ApiResponse<WalletOverviewModel>.fromJson(
        response.data,
        (data) => WalletOverviewModel.fromJson(data as Map<String, dynamic>),
      );
    } catch (e) {
      AppLogger.e('Recharge wallet failed: $e');
      rethrow;
    }
  }

  Future<ApiResponse<WalletOverviewModel>> withdrawWallet(double amount) async {
    try {
      final response = await _dio.post(
        '/api/wallet/withdraw',
        data: {'amount': amount, 'title': '余额提现'},
      );
      return ApiResponse<WalletOverviewModel>.fromJson(
        response.data,
        (data) => WalletOverviewModel.fromJson(data as Map<String, dynamic>),
      );
    } catch (e) {
      AppLogger.e('Withdraw wallet failed: $e');
      rethrow;
    }
  }

  Future<ApiResponse<List<RoomModel>>> _queryRoomList(
    String path, {
    String? keyword,
    String? status,
    List<String>? statusList,
    int? rentMethod,
    int? minRent,
    int? maxRent,
    List<String>? houseTypes,
    List<String>? floorKeywords,
    List<int>? orientations,
    List<int>? decorations,
    int pageNum = 1,
    int pageSize = 10,
  }) async {
    try {
      final requestData = <String, dynamic>{
        'pageNum': pageNum,
        'pageSize': pageSize,
      };
      if (keyword != null && keyword.trim().isNotEmpty) {
        requestData['keyword'] = keyword.trim();
      }
      if (status != null && status.isNotEmpty) {
        requestData['status'] = status;
      }
      if (statusList != null && statusList.isNotEmpty) {
        requestData['statusList'] = statusList;
      }
      if (rentMethod != null) {
        requestData['rentMethod'] = rentMethod;
      }
      if (minRent != null) {
        requestData['minRent'] = minRent;
      }
      if (maxRent != null) {
        requestData['maxRent'] = maxRent;
      }
      if (houseTypes != null && houseTypes.isNotEmpty) {
        requestData['houseTypes'] = houseTypes;
      }
      if (floorKeywords != null && floorKeywords.isNotEmpty) {
        requestData['floorKeywords'] = floorKeywords;
      }
      if (orientations != null && orientations.isNotEmpty) {
        requestData['orientations'] = orientations;
      }
      if (decorations != null && decorations.isNotEmpty) {
        requestData['decorations'] = decorations;
      }

      final response = await _dio.post(path, data: requestData);
      final responseData = response.data;
      if (responseData is! Map<String, dynamic>) {
        throw FormatException('Invalid rooms response: ${response.statusCode}');
      }

      return ApiResponse<List<RoomModel>>.fromJson(
        responseData,
        (data) => _extractList(data)
            .map((item) => RoomModel.fromJson(item as Map<String, dynamic>))
            .toList(),
      );
    } catch (e) {
      AppLogger.e('Query rooms failed: $e');
      rethrow;
    }
  }

  List<dynamic> _extractList(dynamic data) {
    if (data is List<dynamic>) {
      return data;
    }
    if (data is Map<String, dynamic>) {
      final items = data['records'] ?? data['items'] ?? data['list'] ?? [];
      return items is List<dynamic> ? items : <dynamic>[];
    }
    return <dynamic>[];
  }
}
