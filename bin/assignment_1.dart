import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'userManager.dart';
// import 'helperFunctions.dart';
import 'vehicleManager.dart';


void main() {
  print("Running");
  final personRepo = PersonRepository();
   final persons = personRepo.getPersonById("P1");
    print(persons);
  }
  // readFile();
/*   while (true) {
    printMainMenu();
    String choice = getUserStringInput();

    if (choice.toLowerCase() == 'q') {
      stdout.writeln("Terminate application...");
      return;
    }
    switch (int.tryParse(choice) ?? -1) {
      case 1:
        userMenu();
        break;
      case 2:
        vehcicleMenu();
        break;
      case 3:
        print("TODO parkingspace");
        break;
      case 4:
        print("TODO parkings");
        break;
      case 5:
        return;
      default:
        print("Something went wrong. Try again.");
    }
  } */


void printMainMenu() {
  stdout.writeln();
  stdout.writeln("Welcome to HBG-Parking:");
  stdout.writeln("What do you want to handle:");
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
  Stream<String> lines = file.openRead()
    .transform(utf8.decoder)       // Decode bytes to UTF-8.
    .transform(LineSplitter());    // Convert stream to individual lines.
  try {
    await for (var line in lines) {
      print('$line: ${line.length} characters');
    }
    print('File is now closed.');
  } catch (e) {
    print('Error: $e');
  }
}