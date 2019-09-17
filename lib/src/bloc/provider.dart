
import 'package:flutter/material.dart';
import 'package:formvalidation/src/bloc/login_bloc.dart';
import 'package:formvalidation/src/bloc/products_bloc.dart';
// Añadimos el export para poder hacer referencia LoginBloc
export 'package:formvalidation/src/bloc/login_bloc.dart';
export 'package:formvalidation/src/bloc/products_bloc.dart';


class Provider extends InheritedWidget {
  final loginBloc = LoginBloc();
  final _productsBloc = ProductBloc();

  // Implementamos el patron singleton para evitar perder los datos
  // en el caso de realizar un hotreload
  static Provider _instance;
  // El factory lo creamos para determinar si necesitamos crear una nueva instancia
  // o utilizar una ya existente
  factory Provider({ Key key, Widget child}) {
    if(_instance == null) {
      _instance = new Provider._internal(key: key, child: child,); // internal representa un constructor privado
    }

    return _instance;
  }

  Provider._internal({ Key key, Widget child}) 
   : super( key: key, child: child);



  // Provider({ Key key, Widget child}) 
  //  : super( key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true; // Al actualizarce debe notificar a los hijos (True o False)

  // Buscara internamente en el arbol de widget y retornara la instancia del bloc
  static LoginBloc of (BuildContext context) {
    return (context.inheritFromWidgetOfExactType(Provider) as Provider).loginBloc;
  }

  static ProductBloc productsBloc (BuildContext context) {
    return (context.inheritFromWidgetOfExactType(Provider) as Provider)._productsBloc;
  }


}