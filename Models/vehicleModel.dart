class Vehicle {
  final String vehicleId;
  final String ownerId;
  final String licensePlate;
  final String model;
  final String parkingSpaceId;

  Vehicle(
      {required this.vehicleId,
      required this.ownerId,
      required this.licensePlate,
      required this.model,
      required this.parkingSpaceId});

  factory Vehicle.fromJson(Map<String, dynamic> json) => Vehicle(
      vehicleId: json['vehicleId'],
      ownerId: json['ownerId'],
      licensePlate: json['licensePlate'],
      model: json['model'],
      parkingSpaceId: json['parkingSpaceId']);

  Map<String, dynamic> toJson() => {
        'vehicleId': vehicleId,
        'ownerId': ownerId,
        'licensePlate': licensePlate,
        'model': model,
        'parkingSpaceId': parkingSpaceId
      };
}

