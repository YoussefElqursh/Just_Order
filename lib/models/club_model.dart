class Club {
  String clubId;
  String name;
  String location;
  List<String>? restaurantIds;

  Club({
    required this.clubId,
    required this.name,
    required this.location,
    this.restaurantIds,
  });

  static Future<Club> fromMap(Map<String, dynamic> map) {
    return Future.value(Club(
        clubId: map['clubId'], name: map['name'], location: map['location']));
  }
}