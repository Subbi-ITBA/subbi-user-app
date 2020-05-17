import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CrossShrinkedListView extends StatelessWidget {
  final int itemCount;
  final Function itemBuilder;
  final Axis alignment;
  final List<Widget> items;

  CrossShrinkedListView(
      {this.itemCount,
      this.itemBuilder,
      this.items,
      this.alignment = Axis.vertical});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: alignment == Axis.horizontal
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:
                    items ?? List<Widget>.generate(itemCount, itemBuilder))
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:
                    items ?? List<Widget>.generate(itemCount, itemBuilder)));
  }
}
