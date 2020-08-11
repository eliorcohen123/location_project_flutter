import 'dart:io';
import 'package:flutter/material.dart';
import 'package:simple_image_crop/simple_image_crop.dart';

class SimpleImageCrop extends StatelessWidget {
  final File image;
  final cropKey = GlobalKey<ImgCropState>();

  SimpleImageCrop({Key key, this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context),
      body: _showImage(),
      floatingActionButton: _floatingActionButton(context),
    );
  }

  PreferredSizeWidget _appBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.blueAccent,
      leading: IconButton(
        icon: Icon(
          Icons.navigate_before,
          color: Color(0xFFE9FFFF),
          size: 40,
        ),
        onPressed: () => Navigator.of(context).pop(),
      ),
    );
  }

  Widget _showImage() {
    return image != null
        ? Center(
            child: ImgCrop(
              key: cropKey,
              maximumScale: 3,
              image: FileImage(image),
            ),
          )
        : Container(
            child: Center(
              child: Text('Click on the return button'),
            ),
          );
  }

  FloatingActionButton _floatingActionButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () async {
        final crop = cropKey.currentState;
        final croppedFile = await crop.cropCompleted(
          image,
          pictureQuality: 600,
        );
        Navigator.pop(context, croppedFile);
      },
      child: Text('Crop'),
    );
  }
}
