/* class Vehicle {
  final String vehicleId;
  final String ownerId;
  final String licensePlate;
  final String model;
  final String? parkingSpaceId;

  Vehicle(
      {required this.vehicleId,
      required this.ownerId,
      required this.licensePlate,
      required this.model,
      this.parkingSpaceId});

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
 */

class Vehicle {
  final String vehicleId;
  final String ownerId;
  final String licensePlate;
  final String model;
  final String? parkingSpaceId;

  Vehicle({
    required this.vehicleId,
    required this.ownerId,
    required String licensePlate, // Use setter-like logic
    required String model, // Use setter-like logic
    String? parkingSpaceId,
  })  : licensePlate = licensePlate.toLowerCase(),
        model = model.toLowerCase(),
        parkingSpaceId = parkingSpaceId?.toLowerCase(); // Convert to lowercase if not null

  factory Vehicle.fromJson(Map<String, dynamic> json) => Vehicle(
        vehicleId: json['vehicleId'],
        ownerId: json['ownerId'],
        licensePlate: json['licensePlate'],
        model: json['model'],
        parkingSpaceId: json['parkingSpaceId'],
      );

  Map<String, dynamic> toJson() => {
        'vehicleId': vehicleId,
        'ownerId': ownerId,
        'licensePlate': licensePlate,
        'model': model,
        'parkingSpaceId': parkingSpaceId,
      };

  /// Method to create a lowercase copy of an existing Vehicle
  Vehicle toLowerCaseFields() {
    return Vehicle(
      vehicleId: vehicleId,
      ownerId: ownerId,
      licensePlate: licensePlate.toLowerCase(),
      model: model.toLowerCase(),
      parkingSpaceId: parkingSpaceId?.toLowerCase(),
    );
  }
}

enum VehicleType { vehicle, largeVehicle, motorCycle, other }

VehicleType? getVehicleTypeFromInput(String input) {
  switch (input) {
    case '1':
      return VehicleType.vehicle;
    case '2':
      return VehicleType.largeVehicle;
    case '3':
      return VehicleType.motorCycle;
    case '4':
      return VehicleType.other;
    default:
      return null; // Handle invalid input
  }
}