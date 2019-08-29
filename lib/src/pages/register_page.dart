import 'package:flutter/material.dart';
import 'package:formvalidation/src/bloc/provider.dart';
import 'package:formvalidation/src/providers/user_provider.dart';

class RegisterPage extends StatelessWidget {
  final userProvider = new UserProvider();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: <Widget>[
        _createBackground(context),
        _loginForm(context)
      ],)
    );
  }



  Widget _createBackground(context) {
    final size = MediaQuery.of(context).size;

    final backgroundPurple = Container(
      height: size.height * 0.4,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: <Color> [
            Color.fromRGBO(63, 64, 156, 1.0),
            Color.fromRGBO(90, 70, 178, 1.0),
          ]
        )
      ),
    );

    final circle = Container(
      width: 100.0,
      height: 100.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: Color.fromRGBO(255, 255, 255, 0.05)

      ),

    );

    return Stack(
      children: <Widget>[
        backgroundPurple,
        Positioned(top: 90.0, left: 30.0, child: circle,),
        Positioned(top: -40.0,right: -30.0,child: circle,),
        Positioned(bottom: -50.0,right: -10.0,child: circle,),
        Positioned(bottom: 100.0,right: 50.0,child: circle,),
        Positioned(bottom: -50.0,left: -20.0,child: circle,),
        Container(
          padding: EdgeInsets.only(top: 40.0),
          child: Column(
            children: <Widget>[
              Icon(Icons.person_pin_circle, color: Colors.white, size: 100.0,),
              SizedBox(height: 10.0, width: double.infinity,),
              Text('Claudio Torres', style: TextStyle(fontSize: 30.0, color: Colors.white),)
            ],
          ),
        )
      ],
    );
  }

  Widget _loginForm(context) {
    final bloc = Provider.of(context);

    final size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          SafeArea(
            child: Container(
              height: 180.0,
            ),
          ),
          Container(
            width: size.width * 0.85,
            margin: EdgeInsets.symmetric(vertical: 20.0),
            padding: EdgeInsets.symmetric(vertical: 50.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5.0),
              boxShadow: <BoxShadow> [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 3.0,
                  offset: Offset(0.0, 5.0),
                  spreadRadius: 3.0
                  ),
              ]
            ),
            child: Column(
              children: <Widget>[
                Text('Crear cuenta', style: TextStyle(fontSize: 20.0),),
                _createEmail(bloc),
                SizedBox(height: 30.0),
                _createPassword(bloc),
                SizedBox(height: 30.0),
                _createBotton(bloc)
              ],
            ),
          ),
          FlatButton(
            child: Text('¿Ya tienes una cuenta? Login'),
            onPressed: () => Navigator.pushReplacementNamed(context, 'login'),
          ),
          SizedBox(height: 100.0,)
        ],
        ),
    );

  }


  Widget _createEmail(LoginBloc loginBloc) {

    return StreamBuilder(
      stream: loginBloc.emailStream , // Escuchar los cambios
      builder: (BuildContext context, AsyncSnapshot snapshot){
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: TextField(
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              icon: Icon(Icons.alternate_email, color: Colors.deepPurple,),
              hintText: 'ejemplo@correo.com',
              labelText: 'Correo electronico',
              counterText: snapshot.data,
              errorText: snapshot.error
            ),
            onChanged: loginBloc.changeEmail,
          ),
        );
      },
    );

    
  }

  Widget _createPassword(LoginBloc loginBloc) {

    return StreamBuilder(
      stream: loginBloc.passwordStream ,
      builder: (BuildContext context, AsyncSnapshot snapshot){
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: TextField(
            obscureText: true,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              icon: Icon(Icons.lock, color: Colors.deepPurple,),
              labelText: 'Password',
              counterText: snapshot.data,
              errorText: snapshot.error
            ),
            onChanged: loginBloc.changePassword,
          ),
        );
      },
    );

    
  }

  Widget _createBotton(LoginBloc loginBloc) {
    // formValidStream

    return StreamBuilder(
      stream: loginBloc.formValidStream ,
      builder: (BuildContext context, AsyncSnapshot snapshot){
        return RaisedButton(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 80.0, vertical: 15.0),
            child: Text('Registrarme', style: TextStyle(color: Colors.white),),
            ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
          elevation: 0.0,
          color: Colors.deepPurple,
          onPressed: snapshot.hasData ? () => _register(context, loginBloc) : null
        );
      },
    );

  }

  _register(BuildContext context, LoginBloc loginBloc) {
    // print('=============');
    // print('email: ${loginBloc.email}');
    // print('password: ${loginBloc.password}');
    // print('=============');

    userProvider.newUser(loginBloc.email, loginBloc.password);
    
    // Navigator.pushReplacementNamed(context, 'home');
  }



}