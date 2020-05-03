import 'package:flutter/material.dart';
import 'package:locationprojectflutter/presentation/others/responsive_screen.dart';

class AddDataFavorites extends StatefulWidget {
  final double latList, lngList;
  final String nameList, addressList;

  AddDataFavorites(
      {Key key, this.nameList, this.addressList, this.latList, this.lngList})
      : super(key: key);

  @override
  _AddDataFavoritesState createState() => _AddDataFavoritesState();
}

class _AddDataFavoritesState extends State<AddDataFavorites> {
  final textName = TextEditingController();
  final textAddress = TextEditingController();
  final textLat = TextEditingController();
  final textLng = TextEditingController();
  final textPhoto = TextEditingController();

  @override
  void initState() {
    super.initState();

    textName.text = widget.nameList;
    textAddress.text = widget.addressList;
    textLat.text = widget.latList.toString();
    textLng.text = widget.lngList.toString();
  }

  @override
  void dispose() {
    super.dispose();

    textName.dispose();
    textAddress.dispose();
    textLat.dispose();
    textLng.dispose();
    textPhoto.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            resizeToAvoidBottomPadding: false,
            backgroundColor: Colors.grey,
            body: SingleChildScrollView(
              child: Center(
                  child: Container(
                width: ResponsiveScreen().widthMediaQuery(context, 300),
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: ResponsiveScreen().heightMediaQuery(context, 10),
                    ),
                    Row(
                      children: <Widget>[
                        RawMaterialButton(
                          onPressed: () => Navigator.pop(context),
                          elevation: 2.0,
                          fillColor: Colors.white,
                          child: Icon(
                            Icons.arrow_back,
                            size: 20.0,
                          ),
                          padding: EdgeInsets.all(10.0),
                          shape: CircleBorder(),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: ResponsiveScreen().heightMediaQuery(context, 10),
                    ),
                    Text(
                      'Add Place',
                      style: TextStyle(color: Colors.white, fontSize: 25),
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
                    _editText(textName),
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
                    _editText(textAddress),
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
                    _editText(textLat),
                    SizedBox(
                      height: ResponsiveScreen().heightMediaQuery(context, 2),
                    ),
                    _editText(textLng),
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
                    _editText(textPhoto),
                    SizedBox(
                      height: ResponsiveScreen().heightMediaQuery(context, 20),
                    ),
                    RaisedButton(
                      padding: const EdgeInsets.all(0.0),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(80.0)),
                      onPressed: () => null,
                      child: Container(
                        decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: <Color>[
                                Color(0xFF5e7974),
                                Color(0xFF6494ED),
                              ],
                            ),
                            borderRadius:
                                BorderRadius.all(Radius.circular(80.0))),
                        padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                        child: const Text(
                          'Add Your Place',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              )),
            )));
  }

  _editText(TextEditingController textEditingController) {
    return Container(
      decoration: new BoxDecoration(
          color: Color(0xff778899).withOpacity(0.9189918041229248),
          border: Border.all(color: Color(0xff778899), width: 1),
          borderRadius: BorderRadius.circular(24)),
      child: TextField(
        decoration: new InputDecoration(
          contentPadding: EdgeInsets.all(10.0),
          border: InputBorder.none,
        ),
        style: TextStyle(color: Colors.lightGreenAccent),
        controller: textEditingController,
      ),
    );
  }
}
