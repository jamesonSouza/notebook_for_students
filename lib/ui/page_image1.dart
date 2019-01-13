import 'package:flutter/material.dart';
import 'package:zoomable_image/zoomable_image.dart';

class PageImage1 extends StatelessWidget {
  final String pageImage1;

  PageImage1(this.pageImage1);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Image 2"),
        backgroundColor: Colors.white,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.info),
              onPressed: () {
                _show(context);
              })
        ],
      ),
      body: Hero(
        tag: "tes1",
        child: Center(
          child: ZoomableImage(AssetImage(pageImage1),
              placeholder:
                  const Center(child: const CircularProgressIndicator()),
              backgroundColor: Colors.black),
        ),
      ),
    );
  }

  void _show(context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            actions: <Widget>[
              FlatButton(
                child: Text("Ok"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
            title: Text("Info"),
            content: Text(
              "For zoom in touch 2x or 2x for zoom out.",
              style: TextStyle(fontSize: 20),
            ),
          );
        });
  }
}
