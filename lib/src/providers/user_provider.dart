import 'dart:convert';

import 'package:formvalidation/src/preference_user/preferences_user.dart';
import 'package:http/http.dart' as http;

class UserProvider {
  final String fireBaseToken = 'AIzaSyBSQEko53NKq0l9oRmFFNDs14-z4GNSqlI';
  final prefer = new PreferenciasUsuario();

  Future<Map<String, dynamic>>  login(String email, String password) async {
    // Definimos la estructura de datos que vamos a enviar a FireBase
    final authData = {
      'email'     : email,
      'password'  : password,
      'returnSecureToken' : true // Indicamos a FireBase que nos devuelva el token
    };

    final resp = await http.post(
      'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=$fireBaseToken',
      body: json.encode(authData)
    );

    Map<String, dynamic> decodeResp = json.decode(resp.body);
    print(decodeResp);

    if(decodeResp.containsKey('idToken')) {
      // save in storage
      prefer.token = decodeResp['idToken'];
      return { 'ok': true, 'token': decodeResp['idToken'] };
    } else {
      // problem
      return { 'ok': false, 'message': decodeResp['error']['message'] };

    }



  }

  Future<Map<String, dynamic>>  newUser(String email, String password) async {

    // Definimos la estructura de datos que vamos a enviar a FireBase
    final authData = {
      'email'     : email,
      'password'  : password,
      'returnSecureToken' : true // Indicamos a FireBase que nos devuelva el token
    };

    final resp = await http.post(
      'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$fireBaseToken',
      body: json.encode(authData)
    );

    Map<String, dynamic> decodeResp = json.decode(resp.body);
    print(decodeResp);

    if(decodeResp.containsKey('idToken')) {
      // save in storage
      prefer.token = decodeResp['idToken'];
      return { 'ok': true, 'token': decodeResp['idToken'] };
    } else {
      // problem
      return { 'ok': false, 'message': decodeResp['error']['message'] };

    }

  }


}