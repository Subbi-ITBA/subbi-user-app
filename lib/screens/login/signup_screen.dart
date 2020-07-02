import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:subbi/apis/server_api.dart';
import 'package:subbi/models/user.dart';
import 'package:subbi/others/country_state_list.dart';
import 'package:subbi/others/dropdown.dart';

class SignupScreen extends StatelessWidget {
  final personalInfo = PersonalInformation();

  final formKey = GlobalKey<FormState>(
    debugLabel: 'form',
  );

  final Map<String, GlobalKey<FormFieldState>> fieldKeys = {
    'name': GlobalKey<FormFieldState>(),
    'surname': GlobalKey<FormFieldState>(),
    'docType': GlobalKey<FormFieldState>(),
    'docId': GlobalKey<FormFieldState>(),
    'phoneType': GlobalKey<FormFieldState>(),
    'phone': GlobalKey<FormFieldState>(),
    'country': GlobalKey<FormFieldState>(),
    'state': GlobalKey<FormFieldState>(),
    'city': GlobalKey<FormFieldState>(),
    'address': GlobalKey<FormFieldState>(),
    'addressNumber': GlobalKey<FormFieldState>(),
    'zip': GlobalKey<FormFieldState>()
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: SingleChildScrollView(
            child: Center(
                child: Form(
                    key: formKey,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: 50,
                              width: 300,
                              child: Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                    child: Text(
                                      'Bienvenido',
                                      style:
                                          Theme.of(context).textTheme.headline6,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: buildFormBody(context),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: 50,
                              width: 300,
                              child: RaisedButton(
                                  color: Theme.of(context).accentColor,
                                  textColor: Colors.white,
                                  child: Text('Finalizar'),
                                  onPressed: () {
                                    if (formKey.currentState
                                        .validate()) // TODO: Remove develop condition
                                      signUp(formKey, context);
                                  }),
                            ),
                          ),
                        ])))));
  }

  /* ----------------------------------------------------------------------------
    Asks for Name, Document and Phone
  ---------------------------------------------------------------------------- */

  Widget buildFormBody(BuildContext context) {
    return Container(
      height: 1000,
      width: 300,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(children: [
            //  ------------------------------- Name -------------------------------

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Sobre vos',
                style: Theme.of(context).textTheme.headline6,
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                initialValue: 'NAME',
                key: fieldKeys['name'],
                decoration: const InputDecoration(
                  hintText: 'Nombre',
                ),
                validator: (String text) {
                  return text == null || text.length == 0
                      ? 'Campo requerido'
                      : null;
                },
                onSaved: (name) => personalInfo.name = name,
              ),
            ),

            //  ------------------------------- Surname -------------------------------

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                initialValue: 'SURNAME',
                key: fieldKeys['surname'],
                decoration: const InputDecoration(
                  hintText: 'Apellido',
                ),
                validator: (String text) {
                  return text == null || text.length == 0
                      ? 'Campo requerido'
                      : null;
                },
                onSaved: (surname) => personalInfo.surname = surname,
              ),
            ),

            //  ------------------------------- Document id -------------------------------

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                initialValue: '12345678',
                key: fieldKeys['docId'],
                decoration: const InputDecoration(
                  hintText: 'Documento',
                ),
                validator: (String text) {
                  return text == null || text.length == 0
                      ? 'Campo requerido'
                      : null;
                },
                onSaved: (docId) => personalInfo.docId = docId,
              ),
            ),

            //  ------------------------------- Document type -------------------------------

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropDown<DocType>(
                  initialValue: DocType.DNI,
                  key: fieldKeys['docType'],
                  hint: 'Tipo de documento',
                  items: {
                    DocType.DNI: 'DNI',
                    DocType.CI: 'CI',
                  },
                  validator: (DocType type) {
                    return type == null ? 'Campo requerido' : null;
                  },
                  onSaved: (DocType type) => personalInfo.docType = type),
            ),

            //  ------------------------------- Phone number -------------------------------

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                initialValue: '1234',
                key: fieldKeys['phone'],
                decoration: const InputDecoration(
                  hintText: 'Teléfono',
                ),
                validator: (String text) {
                  return text == null || text.length == 0
                      ? 'Campo requerido'
                      : null;
                },
                onSaved: (phone) => personalInfo.phone = phone,
              ),
            ),

            //  ------------------------------- Phone type -------------------------------

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropDown<PhoneType>(
                  initialValue: PhoneType.LANDLINE,
                  key: fieldKeys['phoneType'],
                  hint: 'Tipo de teléfono',
                  items: {
                    PhoneType.MOBILE: 'Celular',
                    PhoneType.LANDLINE: 'Fijo'
                  },
                  validator: (PhoneType type) {
                    return type == null ? 'Campo requerido' : null;
                  },
                  onSaved: (PhoneType type) => personalInfo.phoneType = type),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 32.0, 8.0, 8.0),
              child: Text(
                'Tu ubicación',
                style: Theme.of(context).textTheme.headline6,
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropDown<String>(
                  initialValue: 'Argentina',
                  key: fieldKeys['country'],
                  hint: 'País',
                  items: CountryStateList.countries.map(
                    (country, states) => MapEntry(country, country),
                  ),
                  validator: (String country) {
                    return country == null ? 'Campo requerido' : null;
                  },
                  onSaved: (String country) => personalInfo.country = country),
            ),

            //  ------------------------------- State -------------------------------

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropDown<String>(
                  initialValue: 'Buenos Aires',
                  key: fieldKeys['state'],
                  hint: 'Estado',
                  items: Map.fromEntries(
                    CountryStateList.countries['Argentina'].map(
                      (state) => MapEntry(state, state),
                    ),
                  ),
                  validator: (String country) {
                    return country == null ? 'Campo requerido' : null;
                  },
                  onSaved: (String state) => personalInfo.state = state),
            ),

            //  ------------------------------- City -------------------------------

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                initialValue: 'CITY',
                key: fieldKeys['city'],
                decoration: const InputDecoration(
                  hintText: 'Ciudad',
                ),
                validator: (String text) {
                  return text == null || text.length == 0
                      ? 'Campo requerido'
                      : null;
                },
                onSaved: (city) => personalInfo.city = city,
              ),
            ),

            //  ------------------------------- Address -------------------------------

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                initialValue: 'ADDRESS',
                key: fieldKeys['address'],
                decoration: const InputDecoration(
                  hintText: 'Dirección',
                ),
                validator: (String text) {
                  return text == null || text.length == 0
                      ? 'Campo requerido'
                      : null;
                },
                onSaved: (address) => personalInfo.address = address,
              ),
            ),

            //  ------------------------------- Address Number -------------------------------

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                initialValue: '12',
                key: fieldKeys['addressNumber'],
                decoration: const InputDecoration(
                  hintText: 'Altura',
                ),
                validator: (String text) {
                  return text == null || text.length == 0
                      ? 'Campo requerido'
                      : null;
                },
                onSaved: (addressNumber) =>
                    personalInfo.addressNumber = addressNumber,
              ),
            ),

            //  ------------------------------- Zip code -------------------------------

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                initialValue: '4321',
                key: fieldKeys['zip'],
                decoration: const InputDecoration(
                  hintText: 'Código postal',
                ),
                validator: (String text) {
                  return text == null || text.length == 0
                      ? 'Campo requerido'
                      : null;
                },
                onSaved: (zip) => personalInfo.zip = zip,
              ),
            ),
          ]),
        ),
      ),
    );
  }

  Future<void> signUp(
      GlobalKey<FormState> formKey, BuildContext context) async {
    formKey.currentState.save();

    var user = Provider.of<User>(context);

    user.personalInfo = personalInfo;

    await user.signUp();

    Navigator.pop(context);
  }
}
