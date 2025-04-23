class Vehicle {
  final String vehicleId;
  final String ownerId;
  final String licensePlate;
  final String model;
  final String? parkingSpaceId;
  final String? vehicleType;

  Vehicle({
    required this.vehicleId,
    required this.ownerId,
    required String licensePlate, // Use setter-like logic
    required String model, // Use setter-like logic
    String? parkingSpaceId,
    this.vehicleType,
  }) : licensePlate = licensePlate.toLowerCase(),
       model = model.toLowerCase(),
       parkingSpaceId =
           parkingSpaceId?.toLowerCase(); // Convert to lowercase if not null

  factory Vehicle.fromJson(Map<String, dynamic> json) => Vehicle(
    vehicleId: json['vehicleId'],
    ownerId: json['ownerId'],
    licensePlate: json['licensePlate'],
    model: json['model'],
    parkingSpaceId: json['parkingSpaceId'],
    vehicleType: json['vehicleType'],
  );

  Map<String, dynamic> toJson() => {
    'vehicleId': vehicleId,
    'ownerId': ownerId,
    'licensePlate': licensePlate,
    'model': model,
    'parkingSpaceId': parkingSpaceId,
    'vehicleTypr': vehicleType,
  };

  /// Method to create a lowercase copy of an existing Vehicle
  Vehicle toLowerCaseFields() {
    return Vehicle(
      vehicleId: vehicleId,
      ownerId: ownerId,
      licensePlate: licensePlate.toLowerCase(),
      model: model.toLowerCase(),
      parkingSpaceId: parkingSpaceId?.toLowerCase(),
      vehicleType: vehicleType,
    );
  }
}

enum VehicleType { vehicle, largeVehicle, motorCycle, other }

String? getVehicleTypeFromInput(String input) {
  switch (input) {
    case '1':
      return 'Vehicle';
    case '2':
      return 'Large vehicle';
    case '3':
      return 'MotorCycle';
    case '4':
      return 'Other';
    default:
      return null; // Handle invalid input
  }
}
