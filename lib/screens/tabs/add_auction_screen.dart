import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:subbi/models/user.dart';
import 'package:subbi/models/auction/lot.dart';
import 'package:subbi/screens/unauthenticated_box.dart';

class AddAuctionScreen extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<AddAuctionScreen> {
  final _formKey = GlobalKey<FormState>();
  var _lot = Lot();

  final _categories = getCategories();

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<User>(context);
    // testing

    if (!user.isSignedIn()) return UnauthenticatedBox();
    return Scaffold(
        appBar: AppBar(
          title: Text('Send new lot'),
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
                                value: _lot.category,
                                hint: Text('Select category'),
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
                                    this._lot.category = newValue;
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
                                    hintText: "Enter your lot name",
                                    labelText: "Name"),
                                onChanged: (String newValue) {
                                  setState(() {
                                    this._lot.name = newValue;
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
                                  hintText: "Enter your lot description",
                                  labelText: "Description",
                                ),
                                onChanged: (String newValue) {
                                  setState(() {
                                    this._lot.description = newValue;
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
                                              "Enter the item quantity in your lot",
                                          labelText: "Quantity",
                                        ),
                                        onChanged: (String newValue) {
                                          setState(() {
                                            this._lot.description = newValue;
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
                                              "Enter your desired initial price",
                                          labelText: "Initial Price",
                                        ),
                                        onChanged: (String newValue) {
                                          setState(() {
                                            this._lot.description = newValue;
                                          });
                                        },
                                      )))
                            ],
                          ),
                        ],
                      )))),
        ));
  }

  static List<String> getCategories() {
    return <String>['Juguetes', 'Insturmento', 'Joyas', 'Reloj', 'Wea cuantica']
        .toList();
  }
}
