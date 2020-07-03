import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';

class ImageUploaderView extends StatefulWidget {

  @override
  _ImageUploaderViewState createState() => _ImageUploaderViewState();
}

class _ImageUploaderViewState extends State<ImageUploaderView> {
  final _picker = ImagePicker();

  Future getImages() async{
    PickedFile file = await _picker.getImage(source: ImageSource.gallery);

  }
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
