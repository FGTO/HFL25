import 'dart:io';
import 'package:shared/shared.dart';

import '../utils/helperFunctions.dart';
import '../Repositories/parkingspaceRepository.dart';
import 'package:uuid/uuid.dart';
 
Future<void> parkingspaceMenu() async {
  while (true) {
    stdout.writeln();
    stdout.writeln("Handling parking space");
    stdout.writeln("1. Add new parking space");
    stdout.writeln("2. Show all parking space");
    stdout.writeln("3. Show all available parking space");
    stdout.writeln("4. Show parking space by id");
    stdout.writeln("5. Delete parking space");
    stdout.writeln("6. Return to main menu");
    stdout.writeln("Choose one option (1-6): ");

    var uuid = Uuid();
    String menuChoice = getUserStringInput();
    int? menuNum = int.tryParse(menuChoice);
    if (menuNum != null && menuNum >= 1 && menuNum <= 6) {
      var parkingspaceRepo = ParkingspaceRepository();
      switch (menuNum) {
        case 1:
          String parkingSpaceId = uuid.v4();

          stdout.writeln("Add new parking space");
          stdout.write("Enter name of the new parking space");
          String parkingId = getUserStringInput();

          stdout.write("Enter number for the parking space");
          String number =getUserStringInput();

          Parkingspace newSpace = Parkingspace(
              parkingSpaceId: parkingSpaceId,
              number: number,
              isOccupied: false,
              parkingId: parkingId);
          parkingspaceRepo.create(newSpace);
          break;
        case 2:
          stdout.writeln("List of parking spaces");
          stdout.writeln("__________________________");
          final parkingspaces = await parkingspaceRepo.getAll();
          for (var parkingspace in parkingspaces) {
            String isOccupied =
                parkingspace.isOccupied == true ? "Occupied" : "Available";
            print("${parkingspace.parkingId} is $isOccupied");
          }
          break;
        case 3:
          stdout.writeln("Available parking spaces");
          stdout.writeln("____________________________");
          final availableSpaces = await parkingspaceRepo.getAll();
          for (var availableSpace in availableSpaces) {
            if (!availableSpace.isOccupied) {
              print("${availableSpace.number} is available.");
            }
          }
          break;
        case 4:
          stdout.writeln("Get parking space info by id");
          stdout.write("Enter parking space id: ");
          String parkingId = getUserStringInput();
          final parkingspace = await parkingspaceRepo.getSpaceById(parkingId);
          if (parkingspace != null) {
            String isOccupied =
                parkingspace.isOccupied == true ? "Occupied" : "Available";
            print('''Found: Parking space id: ${parkingspace.parkingSpaceId}
            parking space number: ${parkingspace.number}
            parking id: ${parkingspace.parkingId}
            parking space is: $isOccupied''');
          } else {
            print('Parking space not found.');
          }
          break;
        case 5:
        stdout.writeln("Delete parking space");
          stdout.writeln("Enter parking space id: ");
          String parkingSpaceId = (getUserStringInput()).trim();
          final parkingspace = await parkingspaceRepo.getSpaceById(parkingSpaceId);
          if (parkingspace != null) {
            stdout.write("Are you sure you want to delete: ");
            stdout.write('Deleting : ${parkingspace.parkingSpaceId} - ${parkingspace.number} ? (y/n)');
            String deleting = getUserStringInput();
            if (deleting.toLowerCase() == 'y') {
              parkingspaceRepo.delete(parkingSpaceId);
            } else {
              print("Can't find any parking space with id: $parkingSpaceId.");
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
