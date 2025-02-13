class Parkingspace {
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
}