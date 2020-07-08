import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:subbi/models/auction/category.dart';

class CategoryList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 120,
        child: FutureBuilder<List<Category>>(
          future: Category.getCategories(),
          builder:
              (BuildContext context, AsyncSnapshot<List<Category>> snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data.length,
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemBuilder: (context, i) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          "/category_auctions",
                          arguments: {'category': snapshot.data[i].name},
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
                                int.parse('0x${snapshot.data[i].iconName}'),
                                fontFamily: 'MaterialIcons',
                              ),
                              size: 48,
                              color: Colors.deepPurple,
                            ),
                          ),
                          Container(
                              width: 75,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Flexible(
                                    child: Text(
                                      snapshot.data[i].name,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ],
                              ))
                        ],
                      ),
                    );
                  });
            } else {
              return Container();
            }
          },
        ));
  }
}
