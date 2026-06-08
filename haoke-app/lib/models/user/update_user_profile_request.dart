class UpdateUserProfileRequest {
  final String username;
  final String? nickname;
  final String? email;
  final String? phone;
  final String? avatar;

  const UpdateUserProfileRequest({
    required this.username,
    this.nickname,
    this.email,
    this.phone,
    this.avatar,
  });

  UpdateUserProfileRequest copyWith({
    String? username,
    String? nickname,
    String? email,
    String? phone,
    String? avatar,
  }) {
    return UpdateUserProfileRequest(
      username: username ?? this.username,
      nickname: nickname ?? this.nickname,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      avatar: avatar ?? this.avatar,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'nickname': nickname,
      'email': email,
      'phone': phone,
      'avatar': avatar,
    };
  }
}
