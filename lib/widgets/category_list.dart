import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:subbi/models/auction/category.dart';

class CategoryList extends StatelessWidget {
  final List<Category> categories = [
    Category(
      name: 'Musica',
      description: 'musica',
      iconName: 'e405',
    ),
    Category(
      name: 'Autos',
      description: 'auto',
      iconName: 'e531',
    ),
    Category(
      name: 'Consolas & Videojuegos',
      description: 'consolas',
      iconName: 'e338',
    ),
    Category(
      name: 'Juguetes & Juegos',
      description: 'juegos',
      iconName: 'eb40',
    ),
    Category(
      name: 'Joyas',
      description: 'joyas',
      iconName: 'e334',
    ),
    Category(
      name: 'Electrodomésticos',
      description: 'cosas de la casa',
      iconName: 'eb47',
    ),
    Category(
      name: 'Peliculas & Series',
      description: 'pelis y series',
      iconName: 'e63b',
    ),
    Category(
      name: 'Antigüedades',
      description: 'antiguedades',
      iconName: 'e40b',
    ),
    Category(
      name: 'Muebles',
      description: 'sofas',
      iconName: 'e16b',
    ),
    Category(
      name: 'Inmuebles',
      description: 'casas',
      iconName: 'e88a',
    )
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 120,
        child: ListView.builder(
            itemCount: categories.length,
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemBuilder: (context, i) {
              return GestureDetector(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    "/category_auctions",
                    arguments: {'category': categories[i].name},
                  );
                },
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.fromLTRB(10, 5.0, 10, 0),
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(180.0),
                        ),
                        color: Colors.white,
                        border: Border.all(
                          width: 1,
                          color: Colors.grey,
                        ),
                      ),
                      child: Icon(
                        IconData(
                          int.parse('0x${categories[i].iconName}'),
                          fontFamily: 'MaterialIcons',
                        ),
                        size: 40,
                        color: Colors.deepPurple,
                      ),
                    ),
                    Container(
                        width: 60,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Flexible(
                              child: Text(
                                categories[i].name,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ],
                        ))
                  ],
                ),
              );
            }));
  }
}
