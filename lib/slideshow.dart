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

  final Firestore datbase = Firestore.instance;
  Stream slides;
  String activeTag = 'favourites';

  int currentPage = 0;

  @override
  void initState() {
    _queryDatabase();
    controller.addListener(() {
      int next = controller.page.round();
      if (currentPage != next) {
        setState(() {
          currentPage = next;
        });
      }
    });
    super.initState();
  }

  Stream _queryDatabase({String tag = 'favourites'}) {
    Query query =
        datbase.collection('stories').where('tags', arrayContains: tag);

    // Map the slides to the data payload
    slides =
        query.snapshots().map((list) => list.documents.map((doc) => doc.data));

    // Update the active tag
    setState(() {
      activeTag = tag;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
