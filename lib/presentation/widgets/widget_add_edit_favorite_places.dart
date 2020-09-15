import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:locationprojectflutter/core/constants/constants_colors.dart';
import 'package:locationprojectflutter/core/constants/constants_urls_keys.dart';
import 'package:locationprojectflutter/data/data_resources/locals/sqflite_helper.dart';
import 'package:locationprojectflutter/data/models/model_sqfl/results_sqfl.dart';
import 'package:locationprojectflutter/presentation/utils/responsive_screen.dart';
import 'package:locationprojectflutter/presentation/utils/shower_pages.dart';
import 'package:locationprojectflutter/presentation/utils/utils_app.dart';

class WidgetAddEditFavoritePlaces extends StatefulWidget {
  final double latList, lngList;
  final String nameList, addressList, photoList;
  final bool edit;
  final int id;

  const WidgetAddEditFavoritePlaces(
      {Key key,
      @required this.nameList,
      @required this.addressList,
      @required this.latList,
      @required this.lngList,
      @required this.photoList,
      @required this.edit,
      @required this.id})
      : super(key: key);

  @override
  _WidgetAddEditFavoritePlacesState createState() =>
      _WidgetAddEditFavoritePlacesState();
}

class _WidgetAddEditFavoritePlacesState
    extends State<WidgetAddEditFavoritePlaces> {
  final SQFLiteHelper _db = SQFLiteHelper();
  final String _API_KEY = ConstantsUrlsKeys.API_KEY_GOOGLE_MAPS;
  TextEditingController _textName;
  TextEditingController _textAddress;
  TextEditingController _textLat;
  TextEditingController _textLng;

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
          UtilsApp.dividerHeight(context, 10),
          _title(),
          UtilsApp.dividerHeight(context, 20),
          _textFieldsData(),
          UtilsApp.dividerHeight(context, 10),
          _imagePlace(),
          UtilsApp.dividerHeight(context, 20),
          _buttonSave(),
        ],
      ),
    );
  }

  Widget _title() {
    return Text(
      widget.edit ? 'Edit Place' : 'Add Place',
      style: const TextStyle(
        color: Colors.white,
        fontSize: 25,
      ),
    );
  }

  Widget _textFieldsData() {
    return Column(
      children: [
        _innerTextField(_textName),
        UtilsApp.dividerHeight(context, 10),
        const Text(
          'Address',
          style: TextStyle(color: Colors.white),
        ),
        UtilsApp.dividerHeight(context, 2),
        _innerTextField(_textAddress),
        UtilsApp.dividerHeight(context, 10),
        const Text(
          'Coordinates',
          style: TextStyle(color: Colors.white),
        ),
        UtilsApp.dividerHeight(context, 2),
        _innerTextField(_textLat),
        UtilsApp.dividerHeight(context, 2),
        _innerTextField(_textLng),
      ],
    );
  }

  Widget _imagePlace() {
    return Column(
      children: [
        const Text(
          'Photo',
          style: TextStyle(color: Colors.white),
        ),
        UtilsApp.dividerHeight(context, 2),
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
      ],
    );
  }

  Widget _buttonSave() {
    return RaisedButton(
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
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: <Color>[
              ConstantsColors.GRAY3,
              ConstantsColors.BLUE,
            ],
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(80.0),
          ),
        ),
        padding: EdgeInsets.symmetric(
          vertical: ResponsiveScreen().heightMediaQuery(context, 10),
          horizontal: ResponsiveScreen().widthMediaQuery(context, 20),
        ),
        child: Text(
          widget.edit ? 'Edit Your Place' : 'Add Your Place',
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _innerTextField(TextEditingController textEditingController) {
    return Container(
      decoration: BoxDecoration(
        color: ConstantsColors.GRAY4.withOpacity(1),
        border: Border.all(
          color: ConstantsColors.GRAY4,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: TextField(
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.all(10.0),
          border: InputBorder.none,
        ),
        style: const TextStyle(color: Colors.lightGreenAccent),
        controller: textEditingController,
      ),
    );
  }

  void addItem(String name, String vicinity, double lat, double lng,
      String photo, BuildContext context) {
    var add = ResultsSqfl.sqfl(name, vicinity, lat, lng, photo);
    _db.addResult(add).then(
      (_) {
        ShowerPages.pushPageFavoritePlaces(context);
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
        ShowerPages.pushPageFavoritePlaces(context);
      },
    );
  }
}
