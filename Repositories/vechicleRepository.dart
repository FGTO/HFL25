import 'dataRespository.dart';
import '../Models/vehicleModel.dart';

class VehicleRepository extends DataRepository<Vehicle> {
  VehicleRepository([super.filePath = 'storage/vehicle.json']);

  @override
  Vehicle fromJson(Map<String, dynamic> json) => Vehicle.fromJson(json);

  @override
  Map<String, dynamic> toJson(Vehicle item) => item.toJson();

  Vehicle? getVehicleById(String id) {
    final vehicles = getAll();

   /*  print("Searching for: '$id'");
    print("Available IDs: ${persons.map((p) => p.personId).toList()}");
 */
    for (var vehicle in vehicles) {
      // print("Comparing '${person.personId}' with '$id'");
      if (vehicle.licensePlate.trim() == id.trim()) {
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
