import 'dart:io';
import 'helperFunctions.dart';
// import 'userManager.dart';

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

    String subChoice = getUserStringInput();
    
    switch (int.tryParse(subChoice) ?? -1) {
      case 1:
        stdout.write("Enter registration number: ");
        String regNum = getUserStringInput();
        stdout.writeln("1. Vehicle (>3.5 T)");
        stdout.writeln("2. Large vehicle (<3,5 T)");
        stdout.writeln("3. Motorcycle");
        stdout.writeln("4. Other");
        String selectedVehicleType = getUserStringInput();
        VehicleType vehicleType =
            getVehicleTypeFromInput(selectedVehicleType) ?? VehicleType.other;
        stdout.writeln("Input vehicle owner social security number: ");
        String ownerNumber = getUserStringInput();
        break;
      case 2:
        stdout.writeln("Show all vehicle");
        break;
      case 3:
        stdout.writeln("Update vehicle information");
        return;
      case 4:
        stdout.writeln("Delete vehicle");
        return;
      case 5:
        return;
      default:
        stdout.writeln("Something went wrong. Try again.");
    }
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

class Vehicle {
  late String registrationNumber;
  late VehicleType vehicleType;
  late String ownerNumber;

  Vehicle(
      {required this.registrationNumber,
      required this.vehicleType,
      required this.ownerNumber});
}
