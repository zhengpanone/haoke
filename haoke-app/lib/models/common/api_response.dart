class ApiResponse<T> {
  final int code;
  final String message;
  final bool success;
  final T? data;
  final dynamic errors;

  final int timestamp;

  const ApiResponse({
    this.data,
    this.errors,
    required this.success,
    required this.message,
    required this.code,
    required this.timestamp,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic)? fromJsonT,
  ) {
    return ApiResponse<T>(
      success: json['success'] ?? false,
      data: fromJsonT != null && json['data'] != null
          ? fromJsonT(json['data'])
          : json['data'],
      message: json['message'] ?? json['msg'] ?? '',
      code: json['code'] ?? 200,
      timestamp: json['timestamp'] as int? ?? DateTime.timestamp().millisecond,
    );
  }

// 添加一个静态方法处理无数据响应
  static ApiResponse<void> emptyFromJson(Map<String, dynamic> json) {
    return ApiResponse<void>(
      success: json['success'] ?? false,
      data: null,
      message: json['message'] ?? json['msg'] ?? '',
      code: json['code'] ?? 200,
      timestamp: json['timestamp'] as int? ?? DateTime.timestamp().millisecond,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'message': message,
      'data': data,
      'errors': errors,
      'timestamp': timestamp,
    };
  }

  bool get isSuccess => success == true;
  bool get isError => success != false;

  // bool get isSuccess => code == 200;
  // bool get isError => code != 200;

  factory ApiResponse.success(T data, {String message = 'success'}) {
    return ApiResponse<T>(
      success: true,
      data: data,
      message: message,
      code: 200,
      timestamp: DateTime.timestamp().millisecond,
    );
  }

  factory ApiResponse.error(String message, {int statusCode = 400}) {
    return ApiResponse<T>(
      success: false,
      data: null,
      message: message,
      code: statusCode,
      timestamp: DateTime.timestamp().millisecond,
    );
  }

  @override
  String toString() {
    return 'ApiResponse{code: $code, message: $message, data: $data, errors: $errors, timestamp: $timestamp}';
  }
}

// 分页响应模型
class PaginatedResponse<T> {
  final List<T> items;
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final bool hasNext;
  final bool hasPrev;

  PaginatedResponse({
    required this.items,
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
    required this.hasNext,
    required this.hasPrev,
  });

  factory PaginatedResponse.fromJson(
      Map<String, dynamic> json, T Function(dynamic) fromJson) {
    return PaginatedResponse<T>(
      items: List<T>.from((json['items'] ?? []).map(fromJson)),
      currentPage: json['currentPage'] ?? 1,
      totalPages: json['totalPages'] ?? 1,
      totalItems: json['totalItems'] ?? 0,
      hasNext: json['hasNext'] ?? false,
      hasPrev: json['hasPrev'] ?? false,
    );
  }
}
