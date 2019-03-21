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

  void _queryDatabase({String tag = 'favourites'}) {
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

  Container _buildTagPage() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your Stories',
            style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
          ),
          Text('FILTER', style: TextStyle(color: Colors.black26)),
          _buildButton('favourites'),
          _buildButton('happy'),
          _buildButton('sad')
        ],
      ),
    );
  }

  FlatButton _buildButton(tag) {
    Color color = tag == activeTag ? Colors.blue : Colors.white;
    return FlatButton(
      color: color,
      child: Text(
        '#$tag',
        textAlign: TextAlign.left,
      ),
      onPressed: () => _queryDatabase(tag: tag),
    );
  }

  AnimatedContainer _buildStoryPage(Map data, bool active) {
    // Animated properties
    final double blur = active ? 30 : 0;
    final double offset = active ? 20 : 0;
    final double top = active ? 100 : 200;

    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      curve: Curves.easeOutQuint,
      margin: EdgeInsets.only(top: top, bottom: 50, right: 30),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: DecorationImage(
          fit: BoxFit.cover,
          image: NetworkImage(data['image']),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black87,
            blurRadius: blur,
            offset: Offset(offset, offset),
          ),
        ],
      ),
      child: Center(
        child: Text(
          data['title'],
          style: TextStyle(fontSize: 40, color: Colors.white),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: slides,
      initialData: [],
      builder: (context, AsyncSnapshot snap) {
        List slideList = snap.data.toList();
        return PageView.builder(
          controller: controller,
          itemCount: slideList.length + 1,
          itemBuilder: (context, int currentIndex) {
            if (currentIndex == 0) {
              return _buildTagPage();
            } else if (slideList.length >= currentIndex) {
              bool active = currentIndex == currentPage;
              return _buildStoryPage(slideList[currentIndex - 1], active);
            }
          },
        );
      },
    );
  }
}
