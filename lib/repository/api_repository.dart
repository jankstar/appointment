import 'dart:async';

import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/models.dart';
import '../repository/lib_repository.dart';

class ApiRepository {
  /// doLogin
  Future<Token> doLogin({required String username, required String password}) async {
    // HTTP-Anfrage an den Webservice durchführen
    String basicAuth = 'Basic ${base64.encode(utf8.encode('$username:$password'))}';
    //print('Basic Auth: $basicAuth');
    final response = await http.post(
      Uri.parse('http://localhost:5173/token'), //
      headers: {'authorization': basicAuth, 'accept': 'application/json', 'Content-Type': 'application/x-www-form-urlencoded'},
      body: {'username': username, 'password': password},
    );

    //print('Login status: ${response.statusCode} body: ${response.body}');
    if (response.statusCode == 200) {
      // JSON-Antwort in ein Dart-Objekt umwandeln
      return Token.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to login');
    }
  }

  Future<Me> getMe({required String token}) async {
    String bearerAuth = 'Bearer $token';

    final response = await http.get(
      Uri.parse('http://localhost:5173/me'), //
      headers: {'authorization': bearerAuth, 'accept': 'application/json'},
      //body: { 'username': username, 'password': password },
    );

    LibRepository().getLogger().e('Me: ${response.statusCode} body: ${response.body}');
    if (response.statusCode == 200) {
      // JSON-Antwort in ein Dart-Objekt umwandeln
      return Me.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to get me data');
    }
  }

  Future getLogout({required String token}) async {
    String bearerAuth = 'Bearer $token';

    final response = await http.get(
      Uri.parse('http://localhost:5173/logout'), //
      headers: {'authorization': bearerAuth, 'accept': 'application/json'},
      //body: { 'username': username, 'password': password },
    );

    if (response.statusCode == 200) {
      // JSON-Antwort in ein Dart-Objekt umwandeln
      return;
    } else {
      throw Exception('Failed to logout');
    }
  }
}
