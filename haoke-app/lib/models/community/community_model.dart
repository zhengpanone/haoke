class CommunityModel {
  final String id;
  final String name;
  final String province;
  final String city;
  final String area;
  final String address;
  final String year;
  final String type;
  final String propertyCost;
  final String propertyCompany;
  final String developers;

  const CommunityModel({
    this.id = '',
    required this.name,
    this.province = '',
    this.city = '',
    this.area = '',
    this.address = '',
    this.year = '',
    this.type = '',
    this.propertyCost = '',
    this.propertyCompany = '',
    this.developers = '',
  });

  factory CommunityModel.fromJson(Map<String, dynamic> json) {
    return CommunityModel(
      id: '${json['id'] ?? ''}',
      name: json['name']?.toString() ?? '',
      province: json['province']?.toString() ?? '',
      city: json['city']?.toString() ?? '',
      area: json['area']?.toString() ?? '',
      address: json['address']?.toString() ?? '',
      year: json['year']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
      propertyCost: json['propertyCost']?.toString() ?? '',
      propertyCompany: json['propertyCompany']?.toString() ?? '',
      developers: json['developers']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toCreateJson() {
    return {
      'name': name,
      'province': province,
      'city': city,
      'area': area,
      'address': address,
      'year': year,
      'type': type,
      'propertyCost': propertyCost,
      'propertyCompany': propertyCompany,
      'developers': developers,
    };
  }

  String get displayAddress {
    final parts = [city, area, address].where((item) => item.isNotEmpty);
    return parts.isEmpty ? '-' : parts.join(' ');
  }
}
