import 'dart:io';
import 'package:shared/shared.dart';

import '../utils/helperFunctions.dart';
import '../repositories/parkingRepository.dart';
import 'package:uuid/uuid.dart';

Future<void> parkingMenu() async {
  while (true) {
    stdout.writeln();
    stdout.writeln("Handling parking");
    stdout.writeln("1. Add new parking");
    stdout.writeln("2. Show all parking ");
    stdout.writeln("3. Search parking by id");
    stdout.writeln("4. Edit parking");
    stdout.writeln("5. Delete parking");
    stdout.writeln("6. Return to main menu");
    stdout.writeln("Choose one option (1-6): ");

    var uuid = Uuid();
    String menuChoice = getUserStringInput();
    int? menuNum = int.tryParse(menuChoice);
    if (menuNum != null && menuNum >= 1 && menuNum <= 6) {
      var parkingRepo = ParkingRepository();
      switch (menuNum) {
        case 1:
          String parkingId = uuid.v4();

          stdout.write("Add new parking");
          stdout.write("Enter name of the new parking");
          String name = getUserStringInput();

          stdout.write("Enter address");
          String location = getUserStringInput();

          stdout.write(
              "Enter parking space id(s), separated by commas if multiple: ");
          String parkingSpaceInput = getUserStringInput();
          List<String> parkingSpaceIds = parkingSpaceInput.isNotEmpty
              ? parkingSpaceInput.split(',').map((v) => v.trim()).toList()
              : [];

          Parking newParking = Parking(
              parkingId: parkingId,
              name: name,
              location: location,
              parkingSpaceIds: parkingSpaceIds);
          parkingRepo.create(newParking);
          break;
        case 2:
          stdout.writeln("List of parkings");
          stdout.writeln("__________________________");
          final parkings = await parkingRepo.getAll();
          for (var parking in parkings) {
            print("${parking.location} with ${parking.parkingSpaceIds}");
          }
          break;
        case 3:
          stdout.writeln("Get parking info by id");
          stdout.write("Enter parking id: ");
          String parkingId = getUserStringInput();
          final parking = await parkingRepo.getParkingById(parkingId);
          if (parking != null) {
            print('''Found: Parking id: ${parking.parkingId}
            parking location: ${parking.location}
            parking name: ${parking.name}
            parking space is: ${parking.parkingSpaceIds}''');
          } else {
            print('Parking space not found.');
          }
          break;
        case 4:
          stdout.writeln("Update parking information");
          stdout.write("Enter parking id: ");
          String parkingId = getUserStringInput();

          final parking = await parkingRepo.getParkingById(parkingId);
          if (parking != null) {
            stdout.write("Enter new name: ");
            String newParkingName = getUserStringInput();
            stdout.write("Enter new location: ");
            String newParkingLocation = getUserStringInput();

            Parking updatedParking = Parking(
                parkingId: parking.parkingId,
                name: newParkingName,
                location: newParkingLocation,
                parkingSpaceIds: parking.parkingSpaceIds);

            parkingRepo.update(parkingId, updatedParking);
          } else {
            print('Security number not found.');
          }
          break;
        case 5:
          stdout.writeln("Delete parking");
          stdout.writeln("Enter parking id: ");
          String parkingId = (getUserStringInput()).trim();
          final parking = await parkingRepo.getParkingById(parkingId);

          if (parking != null) {
            stdout.write("Are you sure you want to delete: ");
            stdout.write(
                'Deleting : ${parking.parkingId} - ${parking.name} ? (y/n)');
            String deleting = getUserStringInput();
            if (deleting.toLowerCase() == 'y') {
              parkingRepo.delete(parkingId);
            } else {
              print("Can't find any parking space with id: $parkingId.");
              break;
            }
            break;
          }
        case 6:
          return;
        default:
          break;
      }
    }
  }
}
