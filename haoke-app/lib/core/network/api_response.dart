class ApiResponse<T> {
  final bool success;
  final T? data;
  final String message;
  final int statusCode;

  ApiResponse({
    required this.success,
    this.data,
    required this.message,
    required this.statusCode,
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
      message: json['message'] ?? '',
      statusCode: json['statusCode'] ?? 200,
    );
  }

  factory ApiResponse.success(T data, {String message = 'Success'}) {
    return ApiResponse<T>(
      success: true,
      data: data,
      message: message,
      statusCode: 200,
    );
  }

  factory ApiResponse.error(String message, {int statusCode = 400}) {
    return ApiResponse<T>(
      success: false,
      data: null,
      message: message,
      statusCode: statusCode,
    );
  }
}
