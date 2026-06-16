class RoomPublishRequest {
  final String title;
  final String estateId;
  final int rent;
  final int rentMethod;
  final String houseType;
  final double coveredArea;
  final int orientation;
  final int decoration;
  final String? floor;
  final String? facilities;
  final String? pic;
  final String? houseDesc;

  const RoomPublishRequest({
    required this.title,
    required this.estateId,
    required this.rent,
    required this.rentMethod,
    required this.houseType,
    required this.coveredArea,
    required this.orientation,
    required this.decoration,
    this.floor,
    this.facilities,
    this.pic,
    this.houseDesc,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'estateId': estateId,
      'rent': rent,
      'rentMethod': rentMethod,
      'houseType': houseType,
      'coveredArea': coveredArea,
      'orientation': orientation,
      'decoration': decoration,
      if (floor != null && floor!.isNotEmpty) 'floor': floor,
      if (facilities != null && facilities!.isNotEmpty)
        'facilities': facilities,
      if (pic != null && pic!.isNotEmpty) 'pic': pic,
      if (houseDesc != null && houseDesc!.isNotEmpty) 'houseDesc': houseDesc,
    };
  }
}
