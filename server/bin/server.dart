import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';

void main(List<String> args) async {
  final ip = InternetAddress.anyIPv4;
  final port = int.parse(Platform.environment['PORT'] ?? '8081');

  print("✅ Registered routes for 'users' CRUD operations:");
  print(" - GET /getusers");
  print(" - GET /getuser/<id>");
  print(" - POST /adduser");
  print(" - PATCH /updateuser/<id>");
  print(" - DELETE /deleteuser/<id>");

  print("✅ Registered routes for 'vehicles' CRUD operations:");
  print(" - GET /getvehicles");
  print(" - GET /getvehicle/<id>");
  print(" - POST /addvehicle");
  print(" - PATCH /updatevehicle/<id>");
  print(" - DELETE /deletevehicle/<id>");

  print("✅ Registered routes for 'parking' CRUD operations:");
  print(" - GET /getparkings");
  print(" - GET /getparking/<id>");
  print(" - POST /addparking");
  print(" - PATCH /updateparking/<id>");
  print(" - DELETE /deleteparking/<id>");

  print("✅ Registered routes for 'parking space' CRUD operations:");
  print(" - GET /getparkingspaces");
  print(" - GET /getparkingspace/<id>");
  print(" - POST /addparkingspace");
  print(" - PATCH /updateparkingspace/<id>");
  print(" - DELETE /deleteparkingspace/<id>");
  final handler = Pipeline()
      .addMiddleware(logRequests())
      .addHandler(_router.call);
  final server = await serve(handler, ip, port);

  print('📡 Server listening on port ${server.port}');
}

// Configure routes.
final _router =
    Router()
      ..get('/', _rootHandler)
      // User handler
      ..get('/getusers', _getUsersHandler)
      ..get('/getuser/<id>', _getUserByIdHandler)
      ..post('/adduser', _addUserHandler)
      ..patch('/updateuser/<id>', _updateUserHandler)
      ..delete('/deleteuser/<id>', _deleteUserHandler)
      // Vehicle handler
      ..get('/getvehicles', _getVehiclesHandler)
      ..get('/getvehicle/<id>', _getVehicleByIdHandler)
      ..post('/addvehicle', _addVehicleHandler)
      ..patch('/updatevehicle/<id>', _updateVehicleHandler)
      ..delete('/deletevehicle/<id>', _deleteVehicleHandler)
      // Parking handler
      ..get('/getparkings', _getParkingsHandler)
      ..get('/getparking/<id>', _getParkingByIdHandler)
      ..post('/addparking', _addParkingHandler)
      ..patch('/updateparking/<id>', _updateParkingHandler)
      ..delete('/deleteparking/<id>', _deleteParkingHandler);

Future<Response> _deleteParkingHandler(Request request, String id) async {
  final file = File('data/parking.json');
  List<dynamic> parkings = [];
  
  if (await file.exists()) {
    final contents = await file.readAsString();
    if (contents.isNotEmpty) {
      parkings = jsonDecode(contents);
    }
  }

  final parkingIndex = parkings.indexWhere(
    (parking) => parking['parkingId'].toString() == id,
  );

  if (parkingIndex == -1) {
    return Response.notFound(jsonEncode({'message': 'Parking not found'}));
  }

  parkings.removeAt(parkingIndex);
  await file.writeAsString(jsonEncode(parkings));

  return Response.ok(jsonEncode({'message': 'Parking deleted successfully'}));
}

Future<Response> _deleteVehicleHandler(Request request, String id) async {
  final file = File('data/vehicle.json');
  List<dynamic> vehicles = [];

  if (await file.exists()) {
    final contents = await file.readAsString();
    if (contents.isNotEmpty) {
      vehicles = jsonDecode(contents);
    }
  }

  final vehicleIndex = vehicles.indexWhere(
    (vehicle) => vehicle['licensePlate'].toString() == id,
  );

  if (vehicleIndex == -1) {
    return Response.notFound(jsonEncode({'message': 'Vehicle not found'}));
  }
  vehicles.removeAt(vehicleIndex);
  await file.writeAsString(jsonEncode(vehicles));

  return Response.ok(jsonEncode({'message': 'Vehicle deleted successfully'}));
}

Future<Response> _deleteUserHandler(Request request, String id) async {
  final file = File('data/person.json');
  List<dynamic> users = [];

  if (await file.exists()) {
    final contents = await file.readAsString();
    if (contents.isNotEmpty) {
      users = jsonDecode(contents);
    }
  }

  final userIndex = users.indexWhere(
    (user) => user["personId"].toString() == id,
  );

  if (userIndex == -1) {
    return Response.notFound(jsonEncode({'message': 'User not found'}));
  }

  //Remove the user from the list
  users.removeAt(userIndex);
  await file.writeAsString(jsonEncode(users));

  return Response.ok(jsonEncode({'message': 'User deleted successfully'}));
}

Future<Response> _updateParkingHandler(Request request, String id) async {
  final file = File('data/parking.json');
  List<dynamic> parkings = [];
  
  if (await file.exists()) {
    final contents = await file.readAsString();
    if (contents.isNotEmpty) {
      parkings = jsonDecode(contents);
    }
  }
  
  final parkingIndex = parkings.indexWhere(
    (parking) => parking['parkingId'].toString() == id,
  );

  if (parkingIndex == -1) {
    return Response.notFound(jsonEncode({'message': 'Parking not found'}));
  }

  final Map<String, dynamic> payload = jsonDecode(await request.readAsString());

  final Map<String, dynamic> existingParking =
      parkings[parkingIndex] as Map<String, dynamic>;

  parkings[parkingIndex] = {...existingParking, ...payload};

  await file.writeAsString(jsonEncode(parkings));

  return Response.ok(jsonEncode(parkings[parkingIndex]));
}

Future<Response> _updateVehicleHandler(Request request, String id) async {
  final file = File('data/vehicle.json');
  List<dynamic> vehicles = [];
  if (await file.exists()) {
    final contents = await file.readAsString();
    if (contents.isNotEmpty) {
      vehicles = jsonDecode(contents);
    }
  }

  final vehicleIndex = vehicles.indexWhere(
    (vehicle) => vehicle['licensePlate'].toString() == id,
  );

  if (vehicleIndex == -1) {
    return Response.notFound(jsonEncode({'message': 'Vehicle not founded'}));
  }

  final Map<String, dynamic> payload = jsonDecode(await request.readAsString());
  final Map<String, dynamic> existingVehicle =
      vehicles[vehicleIndex] as Map<String, dynamic>;

  vehicles[vehicleIndex] = {...existingVehicle, ...payload};
  await file.writeAsString(jsonEncode(vehicles));

  return Response.ok(jsonEncode(vehicles[vehicleIndex]));
}

Future<Response> _updateUserHandler(Request request, String id) async {
  final file = File('data/person.json');
  List<dynamic> users = [];

  if (await file.exists()) {
    final contents = await file.readAsString();
    if (contents.isNotEmpty) {
      users = jsonDecode(contents);
    }
  }

  final userIndex = users.indexWhere(
    (user) => user['personId'].toString() == id,
  );

  if (userIndex == -1) {
    return Response.notFound(jsonEncode({'message': 'User not found'}));
  }

  final Map<String, dynamic> payload = jsonDecode(await request.readAsString());

  // Ensure we are working with a Map<String, dynamic>
  final Map<String, dynamic> existingUser =
      users[userIndex] as Map<String, dynamic>;

  // Merge existing user data with new data
  users[userIndex] = {...existingUser, ...payload};

  await file.writeAsString(jsonEncode(users));

  return Response.ok(jsonEncode(users[userIndex]));
}

Future<Response> _getParkingByIdHandler(Request request, String id) async {
  final file = File('data/parking.json');
  List<dynamic> parkings = [];
  if (await file.exists()) {
    final contents = await file.readAsString();
    if (contents.isNotEmpty) {
      parkings = jsonDecode(contents);
    }
  }

  final parking = parkings.firstWhere(
    (parking) => parking['parkingId'].toString() == id,
    orElse: () => null,
  );
  stdout.writeln('Parking $parking');
  if (parking == null) {
    return Response.notFound(jsonEncode({'Error': 'Parking not found'}));
  }

  return Response.ok(
    jsonEncode(parking),
    headers: {'Content-Type': 'application/json'},
  );
}

Future<Response> _getVehicleByIdHandler(Request request, String id) async {
  final file = File('data/vehicle.json');
  List<dynamic> vehicles = [];
  if (await file.exists()) {
    final contents = await file.readAsString();
    if (contents.isNotEmpty) {
      vehicles = jsonDecode(contents);
    }
  }

  final vehicle = vehicles.firstWhere(
    (vehicle) => vehicle['licensePlate'].toString() == id,
    orElse: () => null,
  );
  stdout.writeln('Vehicle $vehicle');
  if (vehicle == null) {
    return Response.notFound(jsonEncode({'Error': 'Vehcicle not found'}));
  }

  return Response.ok(
    jsonEncode(vehicle),
    headers: {'Content-Type': 'application/json'},
  );
}

Future<Response> _getUserByIdHandler(Request request, String id) async {
  final file = File('data/person.json');
  List<dynamic> users = [];
  if (await file.exists()) {
    final contents = await file.readAsString();
    if (contents.isNotEmpty) {
      users = jsonDecode(contents);
    }
  }
  //Searching for personId that match the id arg.
  final user = users.firstWhere(
    (user) => user['personId'].toString() == id,
    orElse: () => null,
  );
  stdout.writeln('User $user');
  if (user == null) {
    return Response.notFound(jsonEncode({'error': 'User not found'}));
  }

  return Response.ok(
    jsonEncode(user),
    headers: {'Content-Type': 'application/json'},
  );
}

Future<Response> _addParkingHandler(Request request) async {
  try {
    final data = await request.readAsString();
    final json = jsonDecode(data);
    final file = File('data/parking,json');

    List<dynamic> parkings = [];
    if (await file.exists()) {
      final contents = await file.readAsString();

      if (contents.isNotEmpty) {
        parkings = jsonDecode(contents);
      }
    }
    parkings.add(json);

    await file.writeAsString(jsonEncode(parkings), mode: FileMode.write);
    stdout.writeln('Parking added successfully');

    return Response.ok(jsonEncode(json));
  } catch (e, stackTrace) {
    stderr.writeln('Error in _addParkingHandler: $e');
    stderr.writeln(stackTrace);
    return Response.internalServerError(body: 'Server error');
  }
}

Future<Response> _addVehicleHandler(Request request) async {
  try {
    final data = await request.readAsString();
    final json = jsonDecode(data);
    final file = File('data/vehicle.json');

    List<dynamic> vehicles = [];
    if (await file.exists()) {
      final contents = await file.readAsString();

      if (contents.isNotEmpty) {
        vehicles = jsonDecode(contents);
      }
    }
    vehicles.add(json);

    await file.writeAsString(jsonEncode(vehicles), mode: FileMode.write);
    stdout.writeln("Vehicle added successfully");

    return Response.ok(jsonEncode(json)); // Return added user
  } catch (e, stackTrace) {
    stderr.writeln("Error in _addVehicleHandler: $e");
    stderr.writeln(stackTrace);
    return Response.internalServerError(body: 'Server error');
  }
}

Future<Response> _addUserHandler(Request request) async {
  try {
    final data = await request.readAsString();
    // stdout.writeln("Received Data: $data");

    final json = jsonDecode(data);
    // stdout.writeln("Decoded JSON: $json");

    final file = File('data/person.json');
    // stdout.writeln("File Path: ${file.path}");

    List<dynamic> users = [];
    if (await file.exists()) {
      final contents = await file.readAsString();
      // stdout.writeln("Existing File Contents: $contents");

      if (contents.isNotEmpty) {
        users = jsonDecode(contents);
      }
    }

    users.add(json); // Add new user entry

    await file.writeAsString(jsonEncode(users), mode: FileMode.write); // Save
    stdout.writeln("User added successfully");

    return Response.ok(jsonEncode(json)); // Return added user
  } catch (e, stackTrace) {
    stderr.writeln("Error in _addUserHandler: $e");
    stderr.writeln(stackTrace);
    return Response.internalServerError(body: 'Server error');
  }
}

Future<Response> _getParkingsHandler(Request request) async {
  final file = File('data/parking.json');

  if (!await file.exists()) {
    print('ERROR: parking.json file not found!');
    return Response.notFound('Parking data file not found');
  }

  List<dynamic> parkings = [];
  if (await file.exists()) {
    final contents = await file.readAsString();
    if (contents.isNotEmpty) {
      parkings = jsonDecode(contents);
    }
  }
  return Response.ok(
    jsonEncode(parkings),
    headers: {'Content-Type': 'application/json'},
  );
}

Future<Response> _getVehiclesHandler(Request request) async {
  final file = File('data/vehicle.json');

  if (!await file.exists()) {
    print('ERROR: vehicle.json file not found!');
    return Response.notFound('Vehicle data file not found');
  }

  List<dynamic> vehicles = [];
  if (await file.exists()) {
    final contents = await file.readAsString();
    if (contents.isNotEmpty) {
      vehicles = jsonDecode(contents);
    }
  }
  return Response.ok(
    jsonEncode(vehicles),
    headers: {'Content-Type': 'application/json'},
  );
}

Future<Response> _getUsersHandler(Request request) async {
  final file = File('data/person.json');

  if (!await file.exists()) {
    print('ERROR: person.json file not found!');
    return Response.notFound('Vehicle data file not found');
  }

  List<dynamic> users = [];
  if (await file.exists()) {
    final contents = await file.readAsString();
    // stdout.writeln("Existing File Contents: $contents");
    if (contents.isNotEmpty) {
      users = jsonDecode(contents);
    }
  }

  return Response.ok(
    jsonEncode(users),
    headers: {'Content-Type': 'application/json'},
  );
}

Response _rootHandler(Request req) {
  return Response.ok('Hello, World!\n');
}
