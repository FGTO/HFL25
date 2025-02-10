class Parking {
  final String parkingId;
  final String name;
  final String location;
  final List<String> parkingSpaceIds;

  Parking(
      {required this.parkingId,
      required this.name,
      required this.location,
      required this.parkingSpaceIds});

  factory Parking.fromJson(Map<String, dynamic> json) => Parking(
      parkingId: json['parkingId'],
      name: json['name'],
      location: json['location'],
      parkingSpaceIds: json['parkingSpaceIds']);

  Map<String, dynamic> toJson() => {
        'parkingId': parkingId,
        'name': name,
        'location': location,
        'parkingSpaceIds': parkingSpaceIds
      };
}
