import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Image.asset('assets/logo-white.png', scale: 0.8),
            splashColor: Colors.transparent,
            onPressed: () {}),
        title: TextField(
          decoration: InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: 'Search',
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.all(Radius.circular(32.0))),
              contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0)),
        ),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.notifications_none),
          )
        ],
      ),
    );
    // return Column(
    //   children: [

    //     Container(
    //       height: 100,
    //       child: AppBar(),
    //     ),

    //     Expanded(
    //       child: Center(
    //         child: Text('Hello'),
    //       ),
    //     )

    //   ]
    // );
  }
}
