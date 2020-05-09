import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SignupScreen extends StatelessWidget{

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,

      body: Center(
        child: Container(
          height: 600,
          width: 300,
          child: Card(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Welcome',
                      style: Theme.of(context).textTheme.title,
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '',
                      style: Theme.of(context).textTheme.title,
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      decoration: const InputDecoration(
                        hintText: 'State',
                      ),
                      validator: (String text){
                        return text==null || text.length==0
                          ? 'Required field'
                          : null;
                      },
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      decoration: const InputDecoration(
                        hintText: 'City',
                      ),
                      validator: (String text){
                        return text==null || text.length==0
                          ? 'Required field'
                          : null;
                      },
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      decoration: const InputDecoration(
                        hintText: 'Address',
                      ),
                      validator: (String text){
                        return text==null || text.length==0
                          ? 'Required field'
                          : null;
                      },
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      decoration: const InputDecoration(
                        hintText: 'Phone',
                      ),
                      validator: (String text){
                        return text==null || text.length==0
                          ? 'Required field'
                          : null;
                      },
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: OutlineButton(
                      child: Text('Finish'),
                      onPressed: () => signUp(),
                    ),
                  ),

                ]
              ),
            ),
          ),
        ),
      ),

    );

  }


  void signUp(){

  }


}