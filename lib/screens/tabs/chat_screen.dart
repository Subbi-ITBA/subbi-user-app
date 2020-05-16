import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:subbi/models/user.dart';
import 'package:subbi/screens/unauthenticated_box.dart';

class ChatScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    var user = Provider.of<User>(context);
    
    if(! user.isSignedIn())
      return UnauthenticatedBox();

    return Container();

  }

}