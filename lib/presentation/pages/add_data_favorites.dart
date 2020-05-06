import 'package:flutter/material.dart';
import 'package:locationprojectflutter/data/database/sqflite_helper.dart';
import 'package:locationprojectflutter/data/models/models_sqlf/ResultSql.dart';
import 'package:locationprojectflutter/presentation/widgets/drawer_total.dart';
import 'package:locationprojectflutter/presentation/widgets/responsive_screen.dart';
import 'package:locationprojectflutter/presentation/pages/favorites_data.dart';

class AddDataFavorites extends StatefulWidget {
  final double latList, lngList;
  final String nameList, addressList, photoList;

  AddDataFavorites(
      {Key key,
      this.nameList,
      this.addressList,
      this.latList,
      this.lngList,
      this.photoList})
      : super(key: key);

  @override
  _AddDataFavoritesState createState() => _AddDataFavoritesState();
}

class _AddDataFavoritesState extends State<AddDataFavorites> {
  SQFLiteHelper db = new SQFLiteHelper();
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
    textPhoto.text = widget.photoList;
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
            appBar: AppBar(
              backgroundColor: Colors.black,
              title: Text('Lovely Favorite Places'),
            ),
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
                      onPressed: () => _addResult(
                          textName.text,
                          textAddress.text,
                          double.parse(textLat.text),
                          double.parse(textLng.text),
                          textPhoto.text),
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
            ),
            drawer: DrawerTotal().drawerImpl(context)));
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

  void _addResult(String name, String vicinity, double lat, double lng,
      String photo) async {
    var add = ResultSql.sqlf(name, vicinity, lat, lng, photo);
    db.addResult(add).then((_) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FavoritesData(),
          ));
    });
  }
}
