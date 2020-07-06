import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:locationprojectflutter/core/constants/constants.dart';
import 'package:locationprojectflutter/data/data_resources/locals/sqflite_helper.dart';
import 'package:locationprojectflutter/data/models/model_sqfl/results_sqfl.dart';
import 'package:locationprojectflutter/presentation/pages/favorite_places.dart';
import 'package:locationprojectflutter/presentation/utils/responsive_screen.dart';

class AddOrEditFavoritesPlaces extends StatefulWidget {
  final double latList, lngList;
  final String nameList, addressList, photoList;
  final bool edit;
  final int id;

  AddOrEditFavoritesPlaces(
      {Key key,
      this.nameList,
      this.addressList,
      this.latList,
      this.lngList,
      this.photoList,
      this.edit,
      this.id})
      : super(key: key);

  @override
  _AddOrEditFavoritesPlacesState createState() =>
      _AddOrEditFavoritesPlacesState();
}

class _AddOrEditFavoritesPlacesState extends State<AddOrEditFavoritesPlaces> {
  TextEditingController _textName;
  TextEditingController _textAddress;
  TextEditingController _textLat;
  TextEditingController _textLng;
  SQFLiteHelper _db = SQFLiteHelper();
  String _API_KEY = Constants.API_KEY;

  @override
  void initState() {
    super.initState();

    _textName = TextEditingController(text: widget.nameList);
    _textAddress = TextEditingController(text: widget.addressList);
    _textLat = TextEditingController(text: widget.latList.toString());
    _textLng = TextEditingController(text: widget.lngList.toString());
  }

  @override
  void dispose() {
    super.dispose();

    _textName.dispose();
    _textAddress.dispose();
    _textLat.dispose();
    _textLng.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey,
      width: ResponsiveScreen().widthMediaQuery(context, 300),
      child: Column(
        children: <Widget>[
          SizedBox(
            height: ResponsiveScreen().heightMediaQuery(context, 10),
          ),
          Text(
            widget.edit ? 'Edit Place' : 'Add Place',
            style: TextStyle(
              color: Colors.white,
              fontSize: 25,
            ),
          ),
          SizedBox(
            height: ResponsiveScreen().heightMediaQuery(context, 20),
          ),
          Text(
            'Name',
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(
            height: ResponsiveScreen().heightMediaQuery(context, 2),
          ),
          _innerTextField(_textName),
          SizedBox(
            height: ResponsiveScreen().heightMediaQuery(context, 10),
          ),
          Text(
            'Address',
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(
            height: ResponsiveScreen().heightMediaQuery(context, 2),
          ),
          _innerTextField(_textAddress),
          SizedBox(
            height: ResponsiveScreen().heightMediaQuery(context, 10),
          ),
          Text(
            'Coordinates',
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(
            height: ResponsiveScreen().heightMediaQuery(context, 2),
          ),
          _innerTextField(_textLat),
          SizedBox(
            height: ResponsiveScreen().heightMediaQuery(context, 2),
          ),
          _innerTextField(_textLng),
          SizedBox(
            height: ResponsiveScreen().heightMediaQuery(context, 10),
          ),
          Text(
            'Photo',
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(
            height: ResponsiveScreen().heightMediaQuery(context, 2),
          ),
          CachedNetworkImage(
            fit: BoxFit.fill,
            height: ResponsiveScreen().heightMediaQuery(context, 75),
            width: ResponsiveScreen().heightMediaQuery(context, 175),
            imageUrl: widget.photoList.isNotEmpty
                ? "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=" +
                    widget.photoList +
                    "&key=$_API_KEY"
                : "https://upload.wikimedia.org/wikipedia/commons/7/75/No_image_available.png",
            placeholder: (context, url) => const CircularProgressIndicator(),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
          SizedBox(
            height: ResponsiveScreen().heightMediaQuery(context, 20),
          ),
          RaisedButton(
            padding: const EdgeInsets.all(0.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(80.0),
            ),
            onPressed: () => widget.edit
                ? updateItem(
                    widget.id,
                    _textName.text,
                    _textAddress.text,
                    double.parse(_textLat.text),
                    double.parse(_textLng.text),
                    widget.photoList,
                    context,
                  )
                : addItem(
                    _textName.text,
                    _textAddress.text,
                    double.parse(_textLat.text),
                    double.parse(_textLng.text),
                    widget.photoList,
                    context,
                  ),
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: <Color>[
                    Color(0xFF5e7974),
                    Color(0xFF6494ED),
                  ],
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(80.0),
                ),
              ),
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: Text(
                widget.edit ? 'Edit Your Place' : 'Add Your Place',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void addItem(String name, String vicinity, double lat, double lng,
      String photo, BuildContext context) {
    var add = ResultsSqfl.sqfl(name, vicinity, lat, lng, photo);
    _db.addResult(add).then(
      (_) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FavoritePlaces(),
          ),
        );
      },
    );
  }

  void updateItem(int id, String name, String vicinity, double lat, double lng,
      String photo, BuildContext context) {
    _db
        .updateResult(
      ResultsSqfl.fromSqfl(
        {
          'id': id,
          'name': name,
          'vicinity': vicinity,
          'lat': lat,
          'lng': lng,
          'photo': photo
        },
      ),
    )
        .then(
      (_) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FavoritePlaces(),
          ),
        );
      },
    );
  }

  Widget _innerTextField(TextEditingController textEditingController) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xff778899).withOpacity(0.9189918041229248),
        border: Border.all(
          color: Color(0xff778899),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: TextField(
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(10.0),
          border: InputBorder.none,
        ),
        style: TextStyle(color: Colors.lightGreenAccent),
        controller: textEditingController,
      ),
    );
  }
}
