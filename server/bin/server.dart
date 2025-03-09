import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';

// Configure routes.
final _router =
    Router()
      ..get('/', _rootHandler)
      ..get('/echo/<message>', _echoHandler)
      ..post('/adduser', _createUserHandler)
      ..get('/getusers', _getAllUserHandler)
      ..get('/getuser/<id>', _getUserById);

/* Future<Response> _getUserById(Request request, String id) async {
  print("🔹 _getUserById called with ID: $id");  // Debug log
  return Response.ok(jsonEncode({"message": "Test response"}));
} */

Future<Response> _getUserById(Request request, String id) async {
  stdout.writeln('Stage 1');
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

Future<Response> _getAllUserHandler(Request request) async {
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

Response _rootHandler(Request req) {
  return Response.ok('Hello, World!\n');
}

Response _echoHandler(Request request) {
  final message = request.params['message'];
  return Response.ok('$message\n');
}

void main(List<String> args) async {
  final ip = InternetAddress.anyIPv4;
  final port = int.parse(Platform.environment['PORT'] ?? '8081');

  print("✅ Registered routes:");
  print(" - GET /");
  print(" - GET /echo/<message>");
  print(" - POST /adduser");
  print(" - GET /getusers");
  print(" - GET /getuser/<id>");

  final handler = Pipeline()
      .addMiddleware(logRequests())
      .addHandler(_router.call);
  final server = await serve(handler, ip, port);

  print('🚀 Server listening on port ${server.port}');
}

/* void main(List<String> args) async {
  final ip = InternetAddress.anyIPv4;
  final handler = Pipeline().addMiddleware(logRequests()).addHandler(_router.call);

  final port = int.parse(Platform.environment['PORT'] ?? '8081');
  final server = await serve(handler, ip, port);
  print('Server listening on port ${server.port}');
} */
