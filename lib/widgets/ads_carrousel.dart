import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class AdsCarrousel extends StatefulWidget {
  @override
  _AdsCarrouselState createState() => _AdsCarrouselState();
}

class _AdsCarrouselState extends State<AdsCarrousel> {
  List<String> ads = ['assets/ad1.png', 'assets/ad2.png', 'assets/ad3.png'];
  @override
  Widget build(BuildContext context) {
    // return CarouselSlider(
    //   items: ads.map((i) {
    //     Container(
    //         width: double.infinity,
    //         height: 125,
    //         decoration: BoxDecoration(
    //             borderRadius: BorderRadius.circular(10),
    //             border: Border.all(color: Colors.black)),
    //         child: Image.asset('$i', fit: BoxFit.cover));
    //   }).toList(),
    //   options: CarouselOptions(
    //     autoPlay: true,
    //     aspectRatio: 2.0,
    //     enlargeCenterPage: true,
    //   ),
    // );
    return Container(
        width: double.infinity,
        height: 125,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.black)),
        child: CarouselSlider(
          items: ads.map((i) {
            return Builder(
              builder: (BuildContext context) {
                return Image.asset('$i',
                    height: 125, width: double.infinity, fit: BoxFit.fill);
              },
            );
          }).toList(),
          options: CarouselOptions(
            autoPlay: true,
            aspectRatio: 2.0,
            enlargeCenterPage: true,
          ),
        ));
  }
}
