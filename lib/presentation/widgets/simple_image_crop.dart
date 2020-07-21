import 'dart:io';
import 'package:flutter/material.dart';
import 'package:simple_image_crop/simple_image_crop.dart';

class SimpleImageCrop extends StatefulWidget {
  final File image;

  const SimpleImageCrop({Key key, this.image}) : super(key: key);

  @override
  _SimpleImageCropState createState() => _SimpleImageCropState();
}

class _SimpleImageCropState extends State<SimpleImageCrop> {
  final cropKey = GlobalKey<ImgCropState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: new IconButton(
          icon: Icon(
            Icons.navigate_before,
            color: Colors.black,
            size: 40,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: widget.image != null
          ? Center(
              child: ImgCrop(
                key: cropKey,
                maximumScale: 3,
                image: FileImage(widget.image),
              ),
            )
          : Container(
              child: Center(
                child: Text('Click on the return button'),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final crop = cropKey.currentState;
          final croppedFile = await crop.cropCompleted(
            widget.image,
            pictureQuality: 600,
          );
          Navigator.pop(context, croppedFile);
        },
        child: Text('Crop'),
      ),
    );
  }
}
