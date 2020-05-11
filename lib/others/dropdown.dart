import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DropDown<T> extends StatefulWidget{

  final String hint;
  final Map<T, String> items;
  final String Function(T item) validator;
  final void Function(T item) onSaved;

  const DropDown({Key key, @required this.hint, @required this.items, @required this.validator, @required this.onSaved}) : super(key: key);

  @override
  State<StatefulWidget> createState() => DropDownState<T>();

}


class DropDownState<T> extends State<DropDown<T>>{

  T value;

  @override
  Widget build(BuildContext context) {
    
    return DropdownButtonFormField<T>(

      key: GlobalKey<FormFieldState>(),

      icon: Icon(Icons.arrow_downward),
      iconSize: 24,
      elevation: 16,

      value: value,

      hint: Text(widget.hint),

      items: widget.items?.entries?.map((entry){

        return DropdownMenuItem<T>(
          value: entry.key,
          child: Text(entry.value)
        );

      })?.toList(),

      validator: widget.validator,
      
      onChanged: (T newValue) => setState((){ value = newValue; }),

      onSaved: widget.onSaved

    );

  }

}