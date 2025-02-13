import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'userManager.dart';
import '../utils/helperFunctions.dart';
import 'vehicleManager.dart';
import '../Models/vehicleModel.dart';
import 'parkingspaceManager.dart';

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
          print("TODO parkings");
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
/*   stdout.writeln("Welcome to HBG-Parking:");
  stdout.writeln("What do you want to handle:"); */
  stdout.writeln("1. User");
  stdout.writeln("2. Vehicle");
  stdout.writeln("3. Parkingspace");
  stdout.writeln("4. Parking");
  stdout.writeln("Q. Quit");
  stdout.write("Enter your choice: ");
}

class Parkingspace {
  final int id;
  final String address;
  final double hourRate;

  Parkingspace(
      {required this.id, required this.address, required this.hourRate});
}

class Parking {
  final Vehicle vehicle;
  final Parkingspace parkingspace;
  final DateTime startTime;
  final DateTime? endTime = null;

  Parking(
      {required this.vehicle,
      required this.parkingspace,
      required this.startTime});
}

void readFile() async {
  final file = File('file.txt');
  Stream<String> lines = file
      .openRead()
      .transform(utf8.decoder) // Decode bytes to UTF-8.
      .transform(LineSplitter()); // Convert stream to individual lines.
  try {
    await for (var line in lines) {
      print('$line: ${line.length} characters');
    }
    print('File is now closed.');
  } catch (e) {
    print('Error: $e');
  }
}
