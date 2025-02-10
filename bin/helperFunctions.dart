import 'dart:io';

String getUserStringInput() {
  return stdin.readLineSync()?.trim() ?? '';
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
