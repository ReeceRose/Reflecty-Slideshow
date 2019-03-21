import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

class Slideshow extends StatefulWidget {
  @override
  _SlideshowState createState() => _SlideshowState();
}

class _SlideshowState extends State<Slideshow> {
  // This will give them 80% width which will allow other slides to appear on the side
  final PageController controller = PageController(viewportFraction: 0.8);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
