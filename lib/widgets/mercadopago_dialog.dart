import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:subbi/models/auction/auction.dart';
import 'package:mercado_pago_mobile_checkout/mercado_pago_mobile_checkout.dart';

import 'package:subbi/widgets/profile_info.dart';

class MercadoPagoDialog {
  static bool corriendo = false;
  // static const String MP_PUBLIC_KEY =
  //     "TEST-b501df4e-24d0-4f27-8864-21a4e789bb22";
  static const String MP_PUBLIC_KEY =
      "TEST-ae79dc4b-a423-48a1-911c-1e1859dba1b6";

  static void showWinnerDialog(
      BuildContext context, double highestBid, Auction auction, String prefID) {
    print("highesbid: " +
        highestBid.toString() +
        " auction: " +
        auction.toString() +
        " prefid: " +
        prefID);
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Center(
                child: Text(
              'Fuiste el mayor postor en la subasta \'${auction.title}\'',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            )),
            contentPadding: EdgeInsets.all(10),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Divider(color: Colors.grey),
                Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.fromLTRB(4, 8, 8, 4),
                      child: Text('Vendedor',
                          style:
                              TextStyle(color: Theme.of(context).accentColor)),
                    )
                  ],
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          ProfileInfo(
                            profileId: auction.ownerUid,
                          ),
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          RaisedButton.icon(
                            onPressed: () => {},
                            icon: Icon(Icons.chat),
                            label: Text('Chat'),
                            textColor: Colors.white,
                            color: Colors.deepPurple[300],
                          )
                        ],
                      ),
                    ]),
                Divider(color: Colors.grey),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text('Total a pagar: \$$highestBid ',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Theme.of(context).accentColor,
                            fontSize: 14)),
                    RaisedButton(
                      onPressed: () {
                        mp(context, prefID);
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Pagar con MercadoPago',
                        style: TextStyle(color: Colors.white),
                      ),
                      color: Colors.lightBlueAccent,
                    )
                  ],
                )
              ],
            ),
            actions: <Widget>[],
          );
        });
  }

  static void mp(BuildContext context, String prefID) async {
    PaymentResult result = await MercadoPagoMobileCheckout.startCheckout(
      MP_PUBLIC_KEY,
      prefID,
    );
    print(result.toString());
    showDialog(
      context: context,
      builder: (buildContext) {
        if (result.statusDetail == "accredited") {
          return AlertDialog(
            title: Text('Pago recibido'),
            content: Text('Gracias por participar en la subasta!',
                style: TextStyle(
                    fontSize: 15, color: Theme.of(context).accentColor)),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.of(buildContext).pop();
                },
                child: Text('CLOSE'),
              )
            ],
          );
        } else {
          return AlertDialog(
            title: Text('Pago fallido'),
            content: Text('Pruebe nuevamente',
                style: TextStyle(
                    fontSize: 15, color: Theme.of(context).accentColor)),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.of(buildContext).pop();
                  mp(context, prefID);
                },
                child: Text('REINTENTAR'),
              )
            ],
          );
        }
      },
    );
  }
}
