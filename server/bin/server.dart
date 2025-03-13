import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';

void main(List<String> args) async {
  final ip = InternetAddress.anyIPv4;
  final port = int.parse(Platform.environment['PORT'] ?? '8081');

  print("✅ Registered routes:");
  print(" - GET /getusers");
  print(" - GET /getuser/<id>");
  print(" - POST /adduser");
  print(" - PATCH /updateuser/<id>");
  print(" - DELETE /deleteuser/<id>");

  print(" - GET /getvehicles");
  print(" - PUT /addvehicle");
  final handler = Pipeline()
      .addMiddleware(logRequests())
      .addHandler(_router.call);
  final server = await serve(handler, ip, port);

  print('🚀 Server listening on port ${server.port}');
}

// Configure routes.
final _router =
    Router()
      ..get('/', _rootHandler)
      ..get('/getusers', _getUsersHandler)
      ..get('/getuser/<id>', _getUserByIdHandler)
      ..post('/adduser', _createUserHandler)
      ..patch('/updateuser/<id>', _updateUserHandler)
      ..delete('/deleteuser/<id>', _deleteUserHandler)
      ..get('/getvehicles', _getVehiclesHandler)
      ..get('/getvehicle/<id>', _getVehicleByIdHandler)
      ..post('/addvehicle', _createVehicleHandler)
      ..patch('/updatevehicle/<id>', _updateVehicleHandler);

Future<Response> _updateVehicleHandler(Request request, String id) async {
  final file = File('data/vehicle.json');
  List<dynamic> vehicles = [];
  if(await file.exists()){
    final contents = await file.readAsString();
    if(contents.isNotEmpty){
      vehicles = jsonDecode(contents);
    }
  }

  final vehicleIndex = vehicles.indexWhere(
    (vehicle)=> vehicle['licensePlate'].toString() == id,
  );

  if(vehicleIndex == -1){
    return Response.notFound(jsonEncode({'message':'Vehicle not founded'}));
  }

final Map<String, dynamic> payload = jsonDecode(await request.readAsString());

  final Map<String, dynamic> existingVehicle =
    vehicles[vehicleIndex] as Map<String,dynamic>;

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
    headers: {'Content-Type':'application/json'},
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

Future<Response> _createVehicleHandler(Request request) async {
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
    stderr.writeln("Error in _createVehicleHandler: $e");
    stderr.writeln(stackTrace);
    return Response.internalServerError(body: 'Server error');
  }
}

Future<Response> _createUserHandler(Request request) async {
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
    stderr.writeln("Error in _createUserHandler: $e");
    stderr.writeln(stackTrace);
    return Response.internalServerError(body: 'Server error');
  }
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

Response _rootHandler(Request req) {
  return Response.ok('Hello, World!\n');
}
