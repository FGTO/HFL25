
import 'package:shared/shared.dart';

class VehicleRepository extends DataRepository<Vehicle> {
  VehicleRepository([super.filePath = 'storage/vehicle.json']);

  @override
  Vehicle fromJson(Map<String, dynamic> json) => Vehicle.fromJson(json);

  @override
  Map<String, dynamic> toJson(Vehicle item) => item.toJson();

  Future<Vehicle?> getVehicleById(String id) async {
    final vehicles =await getAll();

    print("Searching for: '$id'");
    print("Available IDs: ${vehicles.map((p) => p.licensePlate).toList()}");

    for (var vehicle in vehicles) {
      // print("Comparing '${person.personId}' with '$id'");
      if (vehicle.licensePlate.toLowerCase().trim() == id.trim().toLowerCase()) {
        return vehicle; // Found the person, return it.
      }
    }

    // print("Person with ID '$id' not found.");
    return null; // Explicitly return null.
  }

  @override
  String getId(Vehicle vehicle) {
    return vehicle.licensePlate; // Ensure `Person` has an `id` property
  }
}
