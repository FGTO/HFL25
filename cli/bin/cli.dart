import 'dart:io';
import 'userManager.dart';
import 'vehicleManager.dart';
import 'parkingspaceManager.dart';
import 'parkingManager.dart';
import '../utils/helperFunctions.dart';

void main() {
  // readFile();
  stdout.writeln("-----------------------------------");
  stdout.write("Enter a number (1-5) or 'q' to quit: ");
  while (true) {
  printMainMenu();
    String? input = getUserStringInput();

    if (input.toLowerCase() == 'q') {
      print("Exiting...");
      break;
    }

    int? number = int.tryParse(input);
    if (number != null && number >= 1 && number <= 5) {
      switch (int.tryParse(input) ?? -1) {
        case 1:
          userMenu();
          break;
        case 2:
          vehcicleMenu();
          break;
        case 3:
          parkingspaceMenu();
          break;
        case 4:
          parkingMenu();
          break;
        case 5:
          return;
        default:
          print("Something went wrong. Try again.");
      }
    } else {
      print("Invalid input. Present enter a number between 1 and 5");
    }
  }
}

void printMainMenu() {
  stdout.writeln();
  stdout.writeln("1. User");
  stdout.writeln("2. Vehicle");
  stdout.writeln("3. Parkingspace");
  stdout.writeln("4. Parking");
  stdout.writeln("Q. Quit");
  stdout.write("Enter your choice: ");
}
