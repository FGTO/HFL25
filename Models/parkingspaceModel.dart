/* class Parkingspace {
  final String parkingSpaceId;
  final String number;
  final bool isOccupied;
  final String? vehicleId;
  final String parkingId;

  Parkingspace(
      {required this.parkingSpaceId,
      required this.number,
      required this.isOccupied,
      this.vehicleId,
      required this.parkingId});

  factory Parkingspace.fromJson(Map<String, dynamic> json) => Parkingspace(
      parkingSpaceId: json['parkingSpaceId'],
      number: json['number'],
      isOccupied: json['isOccupied'],
      vehicleId: json['vehicleId'],
      parkingId: json['parkingId']);

  Map<String, dynamic> toJson() => {
        'parkingSpaceId': parkingSpaceId,
        'number': number,
        'isOccupied': isOccupied,
        'vehicleId': vehicleId,
        'parkingId': parkingId
      };
} */

class Parkingspace {
  final String parkingSpaceId;
  final String number;
  final bool isOccupied;
  final String? vehicleId;
  final String parkingId;

  Parkingspace({
    required this.parkingSpaceId,
    required this.number,
    required this.isOccupied,
    this.vehicleId,
    required this.parkingId,
  });

  factory Parkingspace.fromJson(Map<String, dynamic> json) => Parkingspace(
        parkingSpaceId: json['parkingSpaceId'],
        number: json['number'],
        isOccupied: json['isOccupied'],
        vehicleId: json['vehicleId'],
        parkingId: json['parkingId'],
      );

  Map<String, dynamic> toJson() => {
        'parkingSpaceId': parkingSpaceId,
        'number': number,
        'isOccupied': isOccupied,
        'vehicleId': vehicleId,
        'parkingId': parkingId,
      };

  // Converts relevant fields to lowercase (if needed)
  Parkingspace toLowerCaseFields() {
    return Parkingspace(
      parkingSpaceId: parkingSpaceId, // Keep IDs unchanged
      number: number.toLowerCase(),   // Convert number to lowercase if needed
      isOccupied: isOccupied,
      vehicleId: vehicleId,           // Keep IDs unchanged
      parkingId: parkingId,           // Keep IDs unchanged
    );
  }
}
