import 'package:flutter/material.dart';
import 'package:subbi/apis/server_api.dart';

class Category {
  String name;
  String description;
  String iconName;

  Category(
      {@required this.name,
      @required this.description,
      @required this.iconName});

  factory Category.fromJson(Map<String,dynamic> parsedJson){
    return new Category(
      name: parsedJson['name'],
      description: parsedJson['description'],
      iconName: parsedJson['iconName'],
    );
  }

  static Future<List<Category>> getCategories() async{
    var jsons = await ServerApi.instance().getCategories();
    return jsons.map((e) => Category.fromJson(e));
  }

  @override
  String toString() {
    return 'Category{name: $name, description: $description, iconName: $iconName}';
  }
}
