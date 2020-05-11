import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:subbi/apis/server_api.dart';
import 'package:subbi/models/user.dart';
import 'package:subbi/others/country_state_list.dart';
import 'package:subbi/others/dropdown.dart';

class SignupScreen extends StatefulWidget{

  @override
  _SignupScreenState createState() => _SignupScreenState();

}


class _SignupScreenState extends State<SignupScreen> {

  PersonalInformation personalInfo;
  var formKey; 
  var nameKey;


  @override
  void initState() {
    personalInfo = PersonalInformation();
    formKey = GlobalKey<FormState>(debugLabel: 'form');
    nameKey = GlobalKey<FormFieldState>();

    super.initState();
  }


  @override
  Widget build(BuildContext context) {


    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,

      body: SingleChildScrollView(
        child: Center(
          child: Form(
            key: formKey,
            child: Builder(
              builder: (formContext){
                return Column(
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
                                'Bienvenidoo',
                                style: Theme.of(context).textTheme.title,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: buildFormBody(nameKey),
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
                          onPressed: (){
                            if(true)   // TODO: Remove develop condition
                              signUp(formKey);
                          }
                        ),
                      )
                    ),

                  ]
                );
              }
            )
          ),
        ),
      ),

    );

  }


  /* ----------------------------------------------------------------------------
    Asks for Name, Document and Phone
  ---------------------------------------------------------------------------- */

  Widget buildFormBody(GlobalKey<FormFieldState> nameKey){

    return Container(
      height: 600,
      width: 300,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: [

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

                  key: nameKey,

                  decoration: const InputDecoration(
                    hintText: 'Nombre',
                  ),

                  validator: (String text){
                    return text==null || text.length==0
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

                  key: GlobalKey<FormFieldState>(),

                  initialValue: personalInfo.surname,

                  decoration: const InputDecoration(
                    hintText: 'Apellido',
                  ),

                  validator: (String text){
                    return text==null || text.length==0
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

                  key: GlobalKey<FormFieldState>(),

                  decoration: const InputDecoration(
                    hintText: 'Documento',
                  ),

                  validator: (String text){
                    return text==null || text.length==0
                      ? 'Campo requerido'
                      : null;
                  },

                  onSaved: (docId) => personalInfo.docId = docId,

                ),
              ),


              //  ------------------------------- Document type -------------------------------

              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: DropdownButtonFormField<DocType>(
              //     icon: Icon(Icons.arrow_downward), iconSize: 24, elevation: 16,

              //     key: GlobalKey<FormFieldState>(),

              //     value: personalInfo.docType,

              //     hint: Text('Tipo de documento'),

              //     items: DocType.values.map((DocType docType){
              //       String text;
              //       switch(docType){
              //         case DocType.DNI: text='DNI'; break;
              //         case DocType.CI: text='CI'; break;
              //         case DocType.PASSPORT: text='Passport'; break;
              //       }

              //       return DropdownMenuItem<DocType>(
              //         value: docType,
              //         child: Text(text),
              //       );
              //     }).toList(),

              //     validator: (DocType type){
              //       return type==null
              //           ? 'Campo requerido'
              //           : null;
              //     },
                  
              //     onChanged: (DocType newValue) => setState((){ personalInfo.docType = newValue; })
                  
              //   ),
              // ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropDown<DocType>(

                  hint: 'Tipo de documento',

                  items: {
                    DocType.DNI: 'DNI',
                    DocType.CI: 'CI'
                  },

                  validator: (DocType type){
                    return type==null
                        ? 'Campo requerido'
                        : null;
                  },

                  onSaved:(DocType type) => personalInfo.docType = type

                ),
              ),

              //  ------------------------------- Phone number -------------------------------

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(

                  key: GlobalKey<FormFieldState>(),

                  decoration: const InputDecoration(
                    hintText: 'Teléfono',
                  ),

                  validator: (String text){
                    return text==null || text.length==0
                      ? 'Campo requerido'
                      : null;
                  },

                  onSaved: (phone) => personalInfo.phone = phone,

                ),
              ),

              //  ------------------------------- Phone type -------------------------------

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonFormField<PhoneType>(
                  icon: Icon(Icons.arrow_downward), iconSize: 24, elevation: 16,

                  key: GlobalKey<FormFieldState>(),

                  value: personalInfo.phoneType,

                  hint: Text('Tipo de teléfono'),

                  items: PhoneType.values.map((PhoneType phoneType){
                    String text;
                    switch(phoneType){
                      case PhoneType.MOBILE: text='Celular'; break;
                      case PhoneType.LANDLINE: text='Fijo'; break;
                    }

                    return DropdownMenuItem<PhoneType>(
                      value: phoneType,
                      child: Text(text),
                    );
                  }).toList(),

                  validator: (PhoneType type){
                    return type==null
                        ? 'Campo requerido'
                        : null;
                  },
                  
                  onChanged: (PhoneType newValue) => setState((){ personalInfo.phoneType = newValue; })
                  
                ),
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
                child: DropdownButtonFormField<String>(
                  icon: Icon(Icons.arrow_downward), iconSize: 24, elevation: 16,

                  key: GlobalKey<FormFieldState>(),

                  value: personalInfo.country,

                  hint: Text('País'),

                  items: CountryStateList.countries.keys.map((String country){
                    return DropdownMenuItem<String>(
                      value: country,
                      child: Text(country),
                    );
                  }).toList(),

                  validator: (String country){
                    return country==null
                        ? 'Campo requerido'
                        : null;
                  },
                  
                  onChanged: (String newValue) => setState((){ personalInfo.country = newValue; })
                  
                ),
              ),

              //  ------------------------------- State -------------------------------

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonFormField<String>(
                  icon: Icon(Icons.arrow_downward), iconSize: 24, elevation: 16,

                  key: GlobalKey<FormFieldState>(),

                  value: personalInfo.state,

                  hint: Text('Estado'),

                  items: personalInfo.country != null
                   ? CountryStateList.countries[personalInfo.country].map((String state){
                      return DropdownMenuItem<String>(
                        value: state,
                        child: Text(state),
                      );
                    }).toList()
                  : null,

                  validator: (String state){
                    return state==null
                        ? 'Campo requerido'
                        : null;
                  },
                  
                  onChanged: (String newValue) => setState((){ personalInfo.state = newValue; })
                  
                ),
              ),

              //  ------------------------------- City -------------------------------
              
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(

                  key: GlobalKey<FormFieldState>(),

                  decoration: const InputDecoration(
                    hintText: 'Ciudad',
                  ),

                  validator: (String text){
                    return text==null || text.length==0
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

                  key: GlobalKey<FormFieldState>(),

                  decoration: const InputDecoration(
                    hintText: 'Dirección',
                  ),

                  validator: (String text){
                    return text==null || text.length==0
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

                  key: GlobalKey<FormFieldState>(),

                  decoration: const InputDecoration(
                    hintText: 'Altura',
                  ),

                  validator: (String text){
                    return text==null || text.length==0
                      ? 'Campo requerido'
                      : null;
                  },

                  onSaved: (addressNumber) => personalInfo.addressNumber = addressNumber,

                ),
              ),

              //  ------------------------------- Zip code -------------------------------
              
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(

                  key: GlobalKey<FormFieldState>(),

                  decoration: const InputDecoration(
                    hintText: 'Código postal',
                  ),

                  validator: (String text){
                    return text==null || text.length==0
                      ? 'Campo requerido'
                      : null;
                  },

                  onSaved: (zip) => personalInfo.zip = zip,

                ),
              ),


            ]
          ),
        ),
      ),
    );

  }



  Future<void> signUp(GlobalKey<FormState> formKey) async{

    formKey.currentState.validate();

    print('Sign up'); return;

    Form.of(context).save();

    User user = Provider.of<User>(context); 

    user.personalInfo = personalInfo;
    
    await user.signUp();

    Navigator.pop(context);
  
  }

}