import 'dart:io';

String getUserStringInput() {
  return stdin.readLineSync()?.trim() ?? '';
}

String securityNumberCheck(String inputSecurityNumber) {
  inputSecurityNumber = inputSecurityNumber.replaceAll('-', '');

  if (inputSecurityNumber.length <= 9) {
    return "Social security number is too short. Try again.";
  } else if (inputSecurityNumber.length == 11) {
    return "Social security number length is incorrect. Try again.";
  } else if (inputSecurityNumber.length >= 13) {
    return "Social security number is too long. Try again.";
  }

  return "";
}

bool checkIfExists(String checkValue, String storageName) {
  switch (storageName) {
    case "person":
      // Check in person db
      break;
    case "vehicle":
      // Check vehicle
      break;
    case "parkingspace":
      // Check parking space db
      break;
    case "parking":
      // Check parkings db
      break;
  }
  return false;
}
