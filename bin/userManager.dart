import 'dart:io';
import 'helperFunctions.dart';

void userMenu() {
  while (true) {
    stdout.writeln();
    stdout.writeln("Handling user");
    stdout.writeln("1. Create new user");
    stdout.writeln("2. Show all users");
    stdout.writeln("3. Get user by social security number");
    stdout.writeln("4. Update user information");
    stdout.writeln("5. Delete user");
    stdout.writeln("6. Return to main menu");
    stdout.writeln("Choose one option (1-5): ");

    String subChoice = getUserStringInput();

   /*  if (subChoice.toLowerCase() == '5') {
      stdout.writeln("Exiting application...");
      return;
    } */

    var personRepo = PersonRepository();
    switch (int.tryParse(subChoice) ?? -1) {
      case 1:
        stdout.write("Enter first name: ");
        String newFirstName = getUserStringInput();
        stdout.write("Enter surname: ");
        String newSurname = getUserStringInput();
        stdout.write("Enter  social security number (12 numbers): ");
        String newSecurityNum = getUserStringInput();
        personRepo.addPerson(newFirstName, newSurname, newSecurityNum);
        break;
      case 2:
        stdout.writeln("Show all users");
        personRepo.getAllPersons();
        break;
      case 3:
        stdout.writeln("Get user by security number");
        stdout.write("Enter user's social security number: ");
        String securityNum = getUserStringInput();
        personRepo.getPersonById(securityNum);
        return;
      case 4:
        stdout.writeln("Update user information");
        stdout.write("Enter user's social security number: ");
        String securityNum = getUserStringInput();
        stdout.write("Enter first name: ");
        String updateFirstName = getUserStringInput();
        stdout.write("Enter surname: ");
        String updateSurname = getUserStringInput();
        personRepo.updatePerson(securityNum, updateFirstName, updateSurname);
        return;
      case 5:
        stdout.writeln("Delete user");
        stdout.writeln("Enter user's social security number to delete: ");
        String securityNumber = getUserStringInput();
        personRepo.deletePerson(securityNumber);
        return;
      case 6:
        return;
      default:
        stdout.writeln("Something iwent wrong. Try again.");
    }
  }
}

class PersonRepository {
  final List<Person> _persons = [];

  void addPerson(String firstName, String surName, String securityNumber) {
    _persons.add(Person(
        firstName: firstName,
        surName: surName,
        securityNumber: securityNumber));
  }

  List<Person> getAllPersons() {
    return List.unmodifiable(_persons);
  }

  Person? getPersonById(String securityNumber) {
    for (var person in _persons) {
      if (person.securityNumber == securityNumber) {
        return person;
      }
    }
    return null;
  }

  bool updatePerson(
      String securityNumber, String updateFirstName, String updateSurname) {
    for (var person in _persons) {
      if (person.securityNumber == securityNumber) {
        person.surName = updateSurname;
        person.firstName = updateFirstName;
        return true;
      }
    }
    return false;
  }

  bool deletePerson(String securityNumber) {
    for (var person in _persons) {
      if (person.securityNumber == securityNumber) {
        _persons.remove(person);
        return true;
      }
    }
    return false;
  }
}

class Person {
  late String firstName;
  late String surName;
  late String securityNumber;

  Person(
      {required this.firstName,
      required this.surName,
      required this.securityNumber});
}
