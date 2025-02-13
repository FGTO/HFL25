import 'dart:io';
import '../utils/helperFunctions.dart';
import '../Repositories/vechicleRepository.dart';
import 'package:uuid/uuid.dart';
import '../Models/vehicleModel.dart';

var uuid = Uuid();

void vehcicleMenu() {
  while (true) {
    stdout.writeln("Handling vehicle");
    stdout.writeln("1. Create new vehicle");
    stdout.writeln("2. Show all vehicle");
    stdout.writeln("3. Get car by registration number");
    stdout.writeln("4. Update vehicle information");
    stdout.writeln("5. Delete vehicle");
    stdout.writeln("6. Return to main menu");
    stdout.writeln("Choose one option (1-6): ");

    String menuChoice = getUserStringInput();
    int? menuNum = int.tryParse(menuChoice);
    if (menuNum != null && menuNum >= 1 && menuNum <= 6) {
      var vehicleRepo = VehicleRepository();
      switch (menuNum) {
        case 1:
          stdout.write("Enter registration number: ");
          String licensePlate = getUserStringInput();
          stdout.writeln("1. Vehicle (>3.5 T)");
          stdout.writeln("2. Large vehicle (<3,5 T)");
          stdout.writeln("3. Motorcycle");
          stdout.writeln("4. Other");
          String selectedVehicleType = getUserStringInput();
          VehicleType vehicleType =
              getVehicleTypeFromInput(selectedVehicleType) ?? VehicleType.other;
          stdout.writeln("Input vehicle owner social security number: ");
          String securityNum = getUserStringInput();
          String vehicleId = uuid.v4();

          Vehicle newVehicle = Vehicle(
              vehicleId: vehicleId,
              ownerId: securityNum,
              licensePlate: licensePlate,
              model: vehicleType.toString());

          vehicleRepo.add(newVehicle);
          break;
        case 2:
          stdout.writeln("List all vehicle");
          stdout.writeln("__________________________");
          final vehicles = vehicleRepo.getAll();
          for (var vehicle in vehicles) {
            print("${vehicle.licensePlate} ${vehicle.ownerId}");
          }
          break;
        case 3:
          stdout.writeln("Get car by security number");
          stdout.write("Enter user's social security number (YYYYMMDD-XXXX): ");
          String securityNum = getUserStringInput();
          final vehicles = vehicleRepo.getVehicleById(securityNum);
          if (vehicles != null) {
            print('Found: ${vehicles.licensePlate} - ${vehicles.vehicleId}');
          } else {
            print('Vehicle not found.');
          }
          break;
        case 4:
          stdout.writeln("Update vehicle information");
          stdout.write("Enter license plate: ");
          String licensePlate = getUserStringInput();

          final vehicle = vehicleRepo.getVehicleById(licensePlate);
          if (vehicle != null) {
            stdout.write("Enter new license plate: ");
            String newPlate = getUserStringInput();
            stdout.write("Enter new surname: ");
            Vehicle updatedVehicle = Vehicle(
                vehicleId: vehicle.vehicleId,
                ownerId: vehicle.ownerId,
                licensePlate: newPlate,
                model: vehicle.model,
                parkingSpaceId: vehicle.parkingSpaceId);
            vehicleRepo.update(licensePlate, updatedVehicle);
          } else {
            print('License plate not found.');
          }
          break;
        case 5:
          stdout.writeln("Delete user");
          stdout.writeln("Enter license plate to delete: ");
          String plate = getUserStringInput().trim();
          print("calling getPersonById");
          final vehicle = vehicleRepo.getVehicleById(plate);

          if (vehicle != null) {
            stdout.write("Are you sure you want to delete this vehicle ${vehicle.licensePlate}: ");
            stdout.write('Deleting ? (y/n)');
            String deleting = getUserStringInput();
            if (deleting.toLowerCase() == 'y') {
              vehicleRepo.delete(plate);
            } else {
              print("Can't find vehicle with this vehicle with this ${vehicle.licensePlate} licesen plate.");
              break;
            }
            break;
          }
        default:
          stdout.writeln("Something went wrong. Try again.");
      }
    } else {
      print("Incorrect input. Try again.");
    }
  }
}
