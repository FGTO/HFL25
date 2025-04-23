class Parking {
  final String parkingId;
  final String name;
  final String location;
  final List<String> parkingSpaceIds;

  Parking({
    required this.parkingId,
    required this.name,
    required this.location,
    required this.parkingSpaceIds,
  });

  factory Parking.fromJson(Map<String, dynamic> json) => Parking(
        parkingId: json['parkingId'],
        name: json['name'],
        location: json['location'],
        parkingSpaceIds: List<String>.from(json['parkingSpaceIds']),
      );

  Map<String, dynamic> toJson() => {
        'parkingId': parkingId,
        'name': name,
        'location': location,
        'parkingSpaceIds': parkingSpaceIds,
      };

  // Convert relevant fields to lowercase (if needed)
  Parking toLowerCaseFields() {
    return Parking(
      parkingId: parkingId, // Keep IDs unchanged
      name: name.toLowerCase(),
      location: location.toLowerCase(),
      parkingSpaceIds: parkingSpaceIds, // IDs remain unchanged
    );
  }
}
