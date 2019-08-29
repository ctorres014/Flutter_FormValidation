import 'package:flutter/material.dart';

import 'package:formvalidation/src/bloc/provider.dart';

import 'package:formvalidation/src/pages/login_page.dart';
import 'package:formvalidation/src/pages/home_page.dart';
import 'package:formvalidation/src/pages/product_page.dart';
import 'package:formvalidation/src/pages/register_page.dart';

import 'package:formvalidation/src/preference_user/preferences_user.dart';
 
void main() async {
  final prefs = new PreferenciasUsuario();
  await prefs.initPrefs();

  runApp(MyApp());
}
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider(child: 
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      initialRoute: 'register',
      routes: {
        'login'     : (BuildContext context) => LoginPage(),
        'home'      : (BuildContext context) => HomePage(),
        'product'   : (BuildContext context) => ProductPage(),
        'register'  : (BuildContext context) => RegisterPage()

      },
      theme: ThemeData(primaryColor: Colors.deepPurple),
    ),
  );
    
    
    
  }
}