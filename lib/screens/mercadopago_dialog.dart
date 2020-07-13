import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MercadoPagoDialog {
  static void showWinnerDialog(
      BuildContext context, double highestBid, Auction auction, String prefID) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Center(child: Text('Finalizó la subasta de Auto volador')),
            contentPadding: EdgeInsets.all(10),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text('Fuiste el mayor postor con una puja de \$400'),
                Text('Contactate con el vendedor'),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: CircleAvatar(
                        radius: 25,
                        backgroundImage: NetworkImage(
                            'https://www.google.com/url?sa=i&url=https%3A%2F%2Fhappytravel.viajes%2Fhappytravel-opiniones%2Fattachment%2F146-1468479_my-profile-icon-blank-profile-picture-circle-hd%2F&psig=AOvVaw0reWr7NuYshsqiL6xdoPV7&ust=1594069920312000&source=images&cd=vfe&ved=0CAIQjRxqFwoTCNiRq7uDt-oCFQAAAAAdAAAAABAe'),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        InkWell(
                            onTap: () {},
                            child: Text(
                              'Javier James Joliwood',
                              style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Theme.of(context).accentColor),
                            )),
                        InkWell(
                          onTap: () {},
                          child: Icon(Icons.message),
                        )
                      ],
                    ),
                  ],
                )
              ],
            ),
            actions: <Widget>[
              RaisedButton(
                onPressed: () {},
                child: Text(
                  'Pagar con MercadoPago',
                  style: TextStyle(color: Colors.white),
                ),
                color: Colors.lightBlueAccent,
              )
            ],
          );
        });
  }
}
