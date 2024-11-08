import 'dart:async';

import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/models.dart';
import '../repository/lib_repository.dart';

class ApiRepository {
  /// doLogin
  Future<Token> doLogin({required String username, required String password}) async {
    // HTTP-Anfrage an den Webservice durchführen
    http.Response response;
    String basicAuth = 'Basic ${base64.encode(utf8.encode('$username:$password'))}';
    //print('Basic Auth: $basicAuth');
    try {
      response = await http.post(
        Uri.parse('http://localhost:5173/token'), //
        headers: {'authorization': basicAuth, 'accept': 'application/json', 'Content-Type': 'application/x-www-form-urlencoded'},
        body: {'username': username, 'password': password},
      );
    } catch (e) {
      throw Exception('Failed to login - Connection refused ');
    }

    //print('Login status: ${response.statusCode} body: ${response.body}');
    if (response.statusCode == 200) {
      // JSON-Antwort in ein Dart-Objekt umwandeln
      return Token.fromJson(json.decode(response.body));
    } else {
      var lfDetail = json.decode(response.body)['detail'] as String;
      throw Exception('Failed to login status: ${response.statusCode}  - $lfDetail');
    }
  }

  Future<Me> getMe({required String token}) async {
    String bearerAuth = 'Bearer $token';

    final response = await http.get(
      Uri.parse('http://localhost:5173/me'), //
      headers: {'authorization': bearerAuth, 'accept': 'application/json'},
    );

    LibRepository().getLogger().d('Get Me: ${response.statusCode} body: ${response.body}');
    if (response.statusCode == 200) {
      // JSON-Antwort in ein Dart-Objekt umwandeln
      return Me.fromJson(json.decode(response.body));
    } else {
      var lfDetail = json.decode(response.body)['detail'] as String;
      throw Exception('Failed to get me data  - $lfDetail');
    }
  }

  Future<Me> setMe({required String token, required Me me}) async {
    String bearerAuth = 'Bearer $token';

    final Map<String, dynamic> body = {
      'username': me.username,
      'name': me.name,
      'avatar_url': me.avatar_url,
      'secondary_email': me.secondary_email,
      'timezone': me.timezone ?? 'Europe/Dublin'
    };

    LibRepository().getLogger().d('Set Me body: ${jsonEncode(body)}');

    final response = await http.put(
      Uri.parse('http://localhost:5173/me'), //
      headers: {'authorization': bearerAuth, 'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    LibRepository().getLogger().d('Set Me: ${response.statusCode} body: ${response.body}');
    if (response.statusCode == 200) {
      // JSON-Antwort in ein Dart-Objekt umwandeln
      return Me.fromJson(json.decode(response.body));
    } else {
      var lfDetail = json.decode(response.body)['detail'] as String;
      throw Exception('Failed to set me data - $lfDetail');
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
      var lfDetail = json.decode(response.body)['detail'] as String;
      throw Exception('Failed to logout - $lfDetail');
    }
  }
}
