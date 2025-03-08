import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';

// Configure routes.
final _router = Router()
  ..get('/', _rootHandler)
  ..get('/echo/<message>', _echoHandler)
  ..post('/adduser', _createUserHandler);

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
  final handler = Pipeline().addMiddleware(logRequests()).addHandler(_router.call);

  final port = int.parse(Platform.environment['PORT'] ?? '8081');
  final server = await serve(handler, ip, port);
  print('Server listening on port ${server.port}');
}

/* import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';

// Configure routes.
final _router =
    Router()
      ..get('/', _rootHandler)
      ..get('/echo/<message>', _echoHandler)
      ..post('/adduser', _createUserHandler);
      // ..get('/getusers/<id>', _getUserByIdHandler);

Future<Response> _createUserHandler(Request request) async {
  final data = await request.readAsString();
  stdout.writeln("data + $data");
  final json = jsonDecode(data);
  stdout.writeln("json + $json");

  final file = File('data/person.json');
  stdout.writeln("file + $file");

  List<dynamic> users = [];
  if (await file.exists()) {
    final contents = await file.readAsString();
    if (contents.isNotEmpty) {
      users = jsonDecode(contents);
    }
  }

  users.add(json); // Add new user entry

  await file.writeAsString(jsonEncode(users), mode: FileMode.write); // Save

  return Response.ok(jsonEncode(json));
}

/* Future<Response> _getUserByIdHandler(Request request, int id) async {
  final data = await request.readAsString();

} */

Response _rootHandler(Request req) {
  return Response.ok('Hello, World!\n');
}

Response _echoHandler(Request request) {
  final message = request.params['message'];
  return Response.ok('$message\n');
}

void main(List<String> args) async {
  // Use any available host or container IP (usually `0.0.0.0`).
  final ip = InternetAddress.anyIPv4;

  // Configure a pipeline that logs requests.
  final handler = Pipeline()
      .addMiddleware(logRequests())
      .addHandler(_router.call);

  // For running in containers, we respect the PORT environment variable.
  final port = int.parse(Platform.environment['PORT'] ?? '8081');
  final server = await serve(handler, ip, port);
  print('Server listening on port ${server.port}');
}
 */