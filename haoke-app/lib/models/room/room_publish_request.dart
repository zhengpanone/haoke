class RoomPublishRequest {
  final String title;
  final String estateId;
  final int rent;
  final int rentMethod;
  final String houseType;
  final double coveredArea;
  final int orientation;
  final int decoration;

  const RoomPublishRequest({
    required this.title,
    required this.estateId,
    required this.rent,
    required this.rentMethod,
    required this.houseType,
    required this.coveredArea,
    required this.orientation,
    required this.decoration,
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
    };
  }
}
