import 'dart:io';
import 'package:shared/shared.dart';

import '../utils/helperFunctions.dart';
import '../repositories/personRepository.dart';
import 'package:uuid/uuid.dart';

Future<void> userMenu() async {
  while (true) {
    stdout.writeln();
    stdout.writeln("Handling user");
    stdout.writeln("1. Create new user");
    stdout.writeln("2. Show all users");
    stdout.writeln("3. Get user by social security number");
    stdout.writeln("4. Update user information");
    stdout.writeln("5. Delete user");
    stdout.writeln("6. Return to main menu");
    stdout.write("Choose one option (1-6): ");

    String firstName;
    String surname;
    String email;
    String securityNum;
    String validationMessage;

    String menuChoice = getUserStringInput();
    int? menuNum = int.tryParse(menuChoice);
    if (menuNum != null && menuNum >= 1 && menuNum <= 6) {
      var uuid = Uuid();
      var personRepo = PersonRepository();
      switch (menuNum) {
        case 1:
          //Prompt for firstname.
          do {
            stdout.write("Enter first name: ");
            firstName = getUserStringInput();
            if (!RegExp(r'^[a-zA-Z]+$').hasMatch(firstName)) {
              print(
                  "Invalid input. Only alphabetical letters are allowed. Try again.");
            }
          } while (!RegExp(r'^[a-zA-Z]+$').hasMatch(firstName));
          //Prompt for surname.
          do {
            stdout.write("Enter surname name: ");
            surname = getUserStringInput();
            if (!RegExp(r'^[a-zA-Z]+$').hasMatch(surname)) {
              print(
                  "Invalid input. Only alphabetical letters are allowed. Try again.");
            }
          } while (!RegExp(r'^[a-zA-Z]+$').hasMatch(surname));
          do {
            stdout.write("Enter email: ");
            email = getUserStringInput();
            if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
                .hasMatch(email)) {
              print(
                  "Invalid input. Incorrect email address format. Try again.");
            }
          } while (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
              .hasMatch(email));
          do {
            stdout.write("Enter social security number: ");
            securityNum = getUserStringInput();
            validationMessage = securityNumberCheck(securityNum);

            if (validationMessage.isNotEmpty) {
              print(validationMessage);
            }
          } while (validationMessage.isNotEmpty);

          String personUuid = uuid.v4();
          Person newAddPerson = Person(
              personUuid: personUuid,
              personId: securityNum.replaceAll('-', ''),
              firstName: firstName,
              surname: surname,
              email: email,
              vehicleIds: []);
          try {
            await personRepo.create(newAddPerson);
            stdout.writeln("");
            stdout.writeln("User successfully created!");
          } catch (e, stackTrace) {
            stderr.writeln("Error creating user: $e");
            stderr.writeln(stackTrace);
          }

          break;
        case 2:
          stdout.writeln("List of users");
          stdout.writeln("__________________________");
          final persons = await personRepo.getAll();
          for (var person in persons) {
            print("${person.firstName} ${person.surname} - ${person.personId}");
          }
          break;
        case 3:
          stdout.writeln("Get user by security number");
          stdout.write("Enter user's social security number: ");
          String securityNum = getUserStringInput();
          securityNum = securityNum.replaceAll('-', '').trim();

          final person = await personRepo.getUserById(securityNum);
          if (person != null) {
            print(
                'Found: ${person.firstName} ${person.surname} - ${person.email}');
          } else {
            print('Person not found.');
          }
          break;
        case 4:
          stdout.writeln("Update user information");
          stdout.write("Enter user's social security number: ");
          String securityNum = getUserStringInput();
          securityNum = securityNum.replaceAll('-', '').trim();
          final person = await personRepo.getUserById(securityNum);
          if (person != null) {
            print("Edit: ${person.firstName} ${person.surname}");
            await editPersonMenu(person, personRepo);
          } else {
            print("Can't find any user with $securityNum in the database");
          }
          break;
        case 5:
          stdout.writeln("Delete user");
          stdout.writeln("Enter user's social security number to delete: ");
          String sec = (getUserStringInput()).trim();
          final person = await personRepo.getUserById(sec);
          if (person != null) {
            stdout.write("Are you sure you want to delete: ");
            stdout.write(
                'Deleting : ${person.firstName} ${person.surname} - ${person.email} ? (y/n)');
            String deleting = getUserStringInput();
            if (deleting.toLowerCase() == 'y') {
              await personRepo.delete(sec);
            } else {
              print("Can't find anyone with this social security number.");
              break;
            }
            break;
          }
        case 6:
          return;
        default:
          stdout.writeln("Something went wrong. Try again.");
      }
    } else {
      print("Incorrect input. Try again.");
    }
  }
}

editPersonMenu(Person person, PersonRepository personRepo) async {
  while (true) {
    stdout.writeln();
    stdout.writeln("1. Edit firstname");
    stdout.writeln("2. Edit surname");
    stdout.writeln("3. Edit email address");
    stdout.writeln("4. Return to user menu");
    stdout.writeln("Choose one option (1-4): ");

    String editPersonMenuOpt = getUserStringInput();
    switch (editPersonMenuOpt) {
      case "1":
        stdout.write("Enter new first name: ");
        String updatedFirstname = getUserStringInput();
        var updatePersonInfo = Person(
            personUuid: person.personUuid,
            personId: person.personId,
            firstName: updatedFirstname,
            surname: person.surname,
            email: person.email,
            vehicleIds: person.vehicleIds);
        await personRepo.update(person.personId, updatePersonInfo);
        break;
      case "2":
        stdout.write("Enter new surname: ");
        String updatedSurname = getUserStringInput();
        var updatePersonInfo = Person(
            personUuid: person.personUuid,
            personId: person.personId,
            firstName: person.firstName,
            surname: updatedSurname,
            email: person.email,
            vehicleIds: person.vehicleIds);
        await personRepo.update(person.personUuid, updatePersonInfo);
        break;
      case "3":
        stdout.write("Enter new email: ");
        String updatedEmail = getUserStringInput();
        var updatePersonInfo = Person(
            personUuid: person.personUuid,
            personId: person.personId,
            firstName: person.firstName,
            surname: person.surname,
            email: updatedEmail,
            vehicleIds: person.vehicleIds);
        await personRepo.update(person.personUuid, updatePersonInfo);
        break;
      case "4":
        return;
      default:
        break;
    }
  }
}
