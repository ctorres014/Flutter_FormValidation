
import 'package:flutter/material.dart';

bool isNumeric(String value) {
  if(value.isEmpty) {
    return false;
  }

  final result = num.tryParse(value);

  return (result == null) ? false : true;

}

void showAlert(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Información incorrecta'),
        content: Text(message),
        actions: <Widget>[
          FlatButton(
            child: Text('ok'),
            onPressed: () => Navigator.of(context).pop(),
          )
        ],
      );
    }
  );
}