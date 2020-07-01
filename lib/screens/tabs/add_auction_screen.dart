import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:subbi/models/auction/auction.dart';
import 'package:subbi/models/user.dart';
import 'package:subbi/screens/unauthenticated_box.dart';

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
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              child: Builder(
                  builder: (context) => Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Padding(
                              padding: EdgeInsets.all(8.0),
                              child: DropdownButton<String>(
                                isExpanded: true,
                                value: _category,
                                hint: Text('Elija una categoría'),
                                icon: Icon(Icons.arrow_downward),
                                iconSize: 24,
                                elevation: 16,
                                style: TextStyle(color: Colors.deepPurple),
                                underline: Container(
                                  height: 2,
                                  color: Colors.deepPurpleAccent,
                                ),
                                onChanged: (String newValue) {
                                  setState(() {
                                    _category = newValue;
                                  });
                                },
                                items: _categories
                                    .map<DropdownMenuItem<String>>(
                                        (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              )),
                          Padding(
                              padding: EdgeInsets.all(8.0),
                              child: TextFormField(
                                maxLength: 30,
                                decoration: InputDecoration(
                                    hintText: "Inserte el título del lote",
                                    labelText: "Título"),
                                onChanged: (String newValue) {
                                  setState(() {
                                    _name = newValue;
                                  });
                                },
                              )),
                          Padding(
                              padding: EdgeInsets.all(8.0),
                              child: TextFormField(
                                maxLines: 2,
                                maxLength: 512,
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
                              )),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Expanded(
                                  child: Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: TextFormField(
                                        maxLines: 1,
                                        maxLength: 3,
                                        decoration: InputDecoration(
                                          isDense: true,
                                          hintText:
                                              "Inserte la cantidad de artículos en su lote",
                                          labelText: "Cantidad",
                                        ),
                                        onChanged: (String newValue) {
                                          setState(() {
                                            _quantity = int.parse(newValue);
                                          });
                                        },
                                      ))),
                              Expanded(
                                  child: Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: TextFormField(
                                        maxLines: 1,
                                        maxLength: 3,
                                        decoration: InputDecoration(
                                          icon: Icon(Icons.monetization_on,
                                              color: Theme.of(context)
                                                  .primaryColor),
                                          isDense: true,
                                          hintText:
                                              "Inserte su precio deseado (el experto podrá modificarlo)",
                                          labelText: "Precio inicial",
                                        ),
                                        onChanged: (String newValue) {
                                          setState(() {
                                            _initialPrice =
                                                double.parse(newValue);
                                          });
                                        },
                                      )))
                            ],
                          ),
                        ],
                      )))),
        ));
  }

  void submit() {
    Auction auction = new Auction(
      ownerUid: _user.fbUser.uid,
      title: _name,
      description: _description,
      category: _category,
      imageURL: null,
      deadLine: null,
      quantity: _quantity,
      initialPrice: _initialPrice,
    );

    auction.post();
  }

  static List<String> getCategories() {
    return <String>['Juguetes', 'Insturmento', 'Joyas', 'Reloj', 'Wea cuantica']
        .toList();
  }
}
