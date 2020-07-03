import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:subbi/apis/server_api.dart';
import 'package:subbi/models/auction/auction.dart';
import 'package:subbi/models/user.dart';
import 'package:subbi/screens/unauthenticated_box.dart';
import 'dart:convert';
import 'package:subbi/widgets/image_uploader_view.dart';

class AddAuctionScreen extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<AddAuctionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _categories = getCategories();

  User _user;
  String _category;
  String _name;
  String _description;
  int _quantity;
  double _initialPrice;
  bool _autovalidate = false;
  final int _descLength = 350;
  final int _nameLength = 80;

  @override
  Widget build(BuildContext context) {
    _user = Provider.of<User>(context);

    // if (!_user.isSignedIn()) return UnauthenticatedBox();
    return Scaffold(
        appBar: AppBar(
          title: Text('Enviar lote'),
          leading: Icon(Icons.description),
        ),
        body: SingleChildScrollView(
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 16,
            ),
            child: Builder(
              builder: (context) => Form(
                key: _formKey,
                autovalidate: _autovalidate,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: DropdownButtonFormField<String>(
                        isExpanded: true,
                        value: _category,
                        hint: Text('Elija una categoría'),
                        icon: Icon(Icons.arrow_downward),
                        iconSize: 24,
                        elevation: 16,
                        style: TextStyle(
                          color: Colors.deepPurple,
                        ),
                        onChanged: (String newValue) {
                          setState(() {
                            _category = newValue;
                          });
                        },
                        validator: (value) => value != null
                            ? null
                            : "Categoria no puede ser vacía",
                        items: _categories
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: TextFormField(
                        maxLength: _nameLength,
                        decoration: InputDecoration(
                          hintText: "Inserte el título del lote",
                          labelText: "Título",
                        ),
                        onChanged: (String newValue) {
                          setState(() {
                            _name = newValue;
                          });
                        },
                        validator: (value) =>
                            value.isEmpty ? "Nombre no puede ser vacío" : null,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: TextFormField(
                        maxLines: 3,
                        maxLength: _descLength,
                        decoration: InputDecoration(
                          isDense: true,
                          hintText: "Inserte la descripción del lote",
                          labelText: "Descripción",
                        ),
                        onChanged: (String newValue) {
                          setState(() {
                            _description = newValue;
                          });
                        },
                        validator: (value) => value.isEmpty
                            ? "Descripción no puede ser vacío"
                            : null,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        maxLength: 3,
                        decoration: InputDecoration(
                          hintText:
                              "Inserte la cantidad de artículos en su lote",
                          labelText: "Cantidad",
                        ),
                        onChanged: (String newValue) {
                          setState(() {
                            if (newValue != null) {
                              _quantity = int.parse(newValue);
                            }
                          });
                        },
                        validator: (value) => (value.isEmpty ||
                                value == null ||
                                (value.isNotEmpty && int.parse(value) <= 0))
                            ? "Cantidad debe ser un número entero mayor a cero"
                            : null,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: TextFormField(
                        initialValue: null,
                        keyboardType: TextInputType.number,
                        maxLength: 6,
                        decoration: InputDecoration(
                          icon: Icon(Icons.monetization_on,
                              color: Theme.of(context).primaryColor),
                          isDense: true,
                          hintText: "Inserte su precio deseado",
                          labelText: "Precio inicial",
                        ),
                        onChanged: (String newValue) {
                          setState(() {
                            _initialPrice = double.parse(newValue);
                          });
                        },
                        validator: (value) => (value.isEmpty ||
                                (value.isNotEmpty && int.parse(value) <= 0))
                            ? "Precio inicial debe ser un numero mayor a cero"
                            : "ta bien",
                      ),
                    ),
                    Text(
                      'Incluya fotos del producto (al menos 3)',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 17,
                      ),
                    ),
                    ImageUploaderView(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[_buildSendLotButton()],
                    )
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  static List<String> getCategories() {
    return <String>[
      'Musica',
      'Autos',
      'Consolas & Videojuegos',
      'Juguetes & Juegos',
      'Joyas y Relojes',
      'Electrodomésticos',
      'Peliculas & Series',
      'Antigüedades',
      'Muebles'
    ].toList();
  }

  Widget _buildSendLotButton() {
    return new RaisedButton.icon(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18.0),
      ),
      onPressed: () {
        if (_formKey.currentState.validate()) {
          print(
              "isValid $_name, $_description $_category $_initialPrice $_quantity");
          //form is valid, proceed further
          //  _formKey.currentState
          //    .save(); //save once fields are valid, onSaved method invoked for every form fields
          ServerApi.instance().postLot(
            title: _name,
            category: _category,
            description: _description,
            initialPrice: _initialPrice,
            quantity: _quantity,
          );
        } else {
          setState(() {
            _autovalidate = true; //enable realtime validation
          });
        }
      },
      color: Theme.of(context).primaryColor,
      textColor: Colors.white,
      icon: Icon(Icons.send),
      label: Text(
        "Enviar lote".toUpperCase(),
        style: TextStyle(
          fontSize: 12,
        ),
      ),
    );
  }
}
