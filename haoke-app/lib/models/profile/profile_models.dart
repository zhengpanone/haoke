class ViewingRecordModel {
  final String id;
  final String houseId;
  final String title;
  final String address;
  final DateTime? appointmentTime;
  final String contactName;
  final String contactPhone;
  final String status;
  final String statusText;
  final String note;

  const ViewingRecordModel({
    required this.id,
    required this.houseId,
    required this.title,
    required this.address,
    this.appointmentTime,
    required this.contactName,
    required this.contactPhone,
    required this.status,
    required this.statusText,
    required this.note,
  });

  factory ViewingRecordModel.fromJson(Map<String, dynamic> json) {
    return ViewingRecordModel(
      id: '${json['id'] ?? ''}',
      houseId: '${json['houseId'] ?? ''}',
      title: json['title']?.toString() ?? '',
      address: json['address']?.toString() ?? '',
      appointmentTime: _parseDateTime(json['appointmentTime']),
      contactName: json['contactName']?.toString() ?? '',
      contactPhone: json['contactPhone']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      statusText: json['statusText']?.toString() ?? '',
      note: json['note']?.toString() ?? '',
    );
  }
}

class HouseOrderModel {
  final String id;
  final String houseId;
  final String orderNo;
  final String title;
  final String address;
  final double amount;
  final String status;
  final String statusText;
  final String actionText;
  final DateTime? orderTime;

  const HouseOrderModel({
    required this.id,
    required this.houseId,
    required this.orderNo,
    required this.title,
    required this.address,
    required this.amount,
    required this.status,
    required this.statusText,
    required this.actionText,
    this.orderTime,
  });

  factory HouseOrderModel.fromJson(Map<String, dynamic> json) {
    return HouseOrderModel(
      id: '${json['id'] ?? ''}',
      houseId: '${json['houseId'] ?? ''}',
      orderNo: json['orderNo']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      address: json['address']?.toString() ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0,
      status: json['status']?.toString() ?? '',
      statusText: json['statusText']?.toString() ?? '',
      actionText: json['actionText']?.toString() ?? '查看详情',
      orderTime: _parseDateTime(json['orderTime']),
    );
  }
}

class HouseFavoriteModel {
  final String id;
  final String houseId;
  final String title;
  final String address;
  final double price;
  final List<String> tags;
  final String imageUrl;
  final DateTime? favoriteTime;

  const HouseFavoriteModel({
    required this.id,
    required this.houseId,
    required this.title,
    required this.address,
    required this.price,
    required this.tags,
    required this.imageUrl,
    this.favoriteTime,
  });

  factory HouseFavoriteModel.fromJson(Map<String, dynamic> json) {
    return HouseFavoriteModel(
      id: '${json['id'] ?? ''}',
      houseId: '${json['houseId'] ?? ''}',
      title: json['title']?.toString() ?? '',
      address: json['address']?.toString() ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0,
      tags:
          (json['tags'] as List<dynamic>?)?.map((item) => '$item').toList() ??
          const [],
      imageUrl: json['imageUrl']?.toString() ?? '',
      favoriteTime: _parseDateTime(json['favoriteTime']),
    );
  }
}

class IdentityVerificationModel {
  final String id;
  final String realName;
  final String idCardNo;
  final String status;
  final String statusText;
  final String rejectReason;
  final DateTime? submittedAt;
  final DateTime? reviewedAt;

  const IdentityVerificationModel({
    required this.id,
    required this.realName,
    required this.idCardNo,
    required this.status,
    required this.statusText,
    required this.rejectReason,
    this.submittedAt,
    this.reviewedAt,
  });

  factory IdentityVerificationModel.fromJson(Map<String, dynamic> json) {
    return IdentityVerificationModel(
      id: '${json['id'] ?? ''}',
      realName: json['realName']?.toString() ?? '',
      idCardNo: json['idCardNo']?.toString() ?? '',
      status: json['status']?.toString() ?? 'NOT_SUBMITTED',
      statusText: json['statusText']?.toString() ?? '未认证',
      rejectReason: json['rejectReason']?.toString() ?? '',
      submittedAt: _parseDateTime(json['submittedAt']),
      reviewedAt: _parseDateTime(json['reviewedAt']),
    );
  }
}

class HouseContractModel {
  final String id;
  final String houseId;
  final String orderId;
  final String contractNo;
  final String title;
  final DateTime? periodStart;
  final DateTime? periodEnd;
  final String status;
  final String statusText;
  final String pdfUrl;
  final String signUrl;

  const HouseContractModel({
    required this.id,
    required this.houseId,
    required this.orderId,
    required this.contractNo,
    required this.title,
    this.periodStart,
    this.periodEnd,
    required this.status,
    required this.statusText,
    required this.pdfUrl,
    required this.signUrl,
  });

  factory HouseContractModel.fromJson(Map<String, dynamic> json) {
    return HouseContractModel(
      id: '${json['id'] ?? ''}',
      houseId: '${json['houseId'] ?? ''}',
      orderId: '${json['orderId'] ?? ''}',
      contractNo: json['contractNo']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      periodStart: _parseDateTime(json['periodStart']),
      periodEnd: _parseDateTime(json['periodEnd']),
      status: json['status']?.toString() ?? '',
      statusText: json['statusText']?.toString() ?? '',
      pdfUrl: json['pdfUrl']?.toString() ?? '',
      signUrl: json['signUrl']?.toString() ?? '',
    );
  }
}

class WalletOverviewModel {
  final double balance;
  final double frozenAmount;
  final List<WalletRecordModel> records;

  const WalletOverviewModel({
    required this.balance,
    required this.frozenAmount,
    required this.records,
  });

  factory WalletOverviewModel.fromJson(Map<String, dynamic> json) {
    return WalletOverviewModel(
      balance: (json['balance'] as num?)?.toDouble() ?? 0,
      frozenAmount: (json['frozenAmount'] as num?)?.toDouble() ?? 0,
      records:
          (json['records'] as List<dynamic>?)
              ?.map(
                (item) =>
                    WalletRecordModel.fromJson(item as Map<String, dynamic>),
              )
              .toList() ??
          const [],
    );
  }
}

class WalletRecordModel {
  final String id;
  final String recordType;
  final String title;
  final double amount;
  final bool income;
  final String status;
  final String statusText;
  final DateTime? recordTime;

  const WalletRecordModel({
    required this.id,
    required this.recordType,
    required this.title,
    required this.amount,
    required this.income,
    required this.status,
    required this.statusText,
    this.recordTime,
  });

  factory WalletRecordModel.fromJson(Map<String, dynamic> json) {
    return WalletRecordModel(
      id: '${json['id'] ?? ''}',
      recordType: json['recordType']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0,
      income: json['income'] == true,
      status: json['status']?.toString() ?? '',
      statusText: json['statusText']?.toString() ?? '',
      recordTime: _parseDateTime(json['recordTime']),
    );
  }
}

class ContactChannelModel {
  final String type;
  final String title;
  final String value;
  final String description;

  const ContactChannelModel({
    required this.type,
    required this.title,
    required this.value,
    required this.description,
  });

  factory ContactChannelModel.fromJson(Map<String, dynamic> json) {
    return ContactChannelModel(
      type: json['type']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      value: json['value']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
    );
  }
}

DateTime? _parseDateTime(dynamic value) {
  if (value == null) return null;
  if (value is List && value.length >= 3) {
    return DateTime(
      value[0] as int,
      value[1] as int,
      value[2] as int,
      value.length > 3 ? value[3] as int : 0,
      value.length > 4 ? value[4] as int : 0,
      value.length > 5 ? value[5] as int : 0,
    );
  }
  return DateTime.tryParse(value.toString());
}
