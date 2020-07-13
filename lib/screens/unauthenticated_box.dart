import 'package:flutter/material.dart';

class UnauthenticatedBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Debes iniciar sesión para ver esta página'),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: RaisedButton(
              child: Text('Iniciar Sesión'),
              onPressed: () {
                Navigator.pushNamed(context, '/signin');
              },
            ),
          )
        ],
      ),
    );
  }
}
