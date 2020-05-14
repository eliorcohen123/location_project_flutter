import 'package:flutter/material.dart';
import 'package:locationprojectflutter/presentation/state_management/provider/results_sqfl_provider.dart';
import 'package:locationprojectflutter/presentation/widgets/drawer_total.dart';
import 'package:locationprojectflutter/presentation/widgets/responsive_screen.dart';
import 'package:provider/provider.dart';
//import 'package:locationprojectflutter/presentation/state_management/mobx/results_sqfl_mobx.dart';

class AddOrEditDataFavorites extends StatefulWidget {
  final double latList, lngList;
  final String nameList, addressList, photoList;
  final bool edit;
  final int id;

  AddOrEditDataFavorites(
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
  _AddOrEditDataFavoritesState createState() => _AddOrEditDataFavoritesState();
}

class _AddOrEditDataFavoritesState extends State<AddOrEditDataFavorites> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ResultsSqflProvider>(
        create: (context) => ResultsSqflProvider(),
        child:
            Consumer<ResultsSqflProvider>(builder: (context, results, child) {
          return AddOrEditDataFavoritesProv(
              nameList: widget.nameList,
              addressList: widget.addressList,
              latList: widget.latList,
              lngList: widget.lngList,
              photoList: widget.photoList,
              edit: widget.edit,
              id: widget.id);
        }));
  }
}

class AddOrEditDataFavoritesProv extends StatefulWidget {
  final double latList, lngList;
  final String nameList, addressList, photoList;
  final bool edit;
  final int id;

  AddOrEditDataFavoritesProv(
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
  _AddOrEditDataFavoritesProvState createState() =>
      _AddOrEditDataFavoritesProvState();
}

class _AddOrEditDataFavoritesProvState
    extends State<AddOrEditDataFavoritesProv> {
  final textName = TextEditingController();
  final textAddress = TextEditingController();
  final textLat = TextEditingController();
  final textLng = TextEditingController();
  final textPhoto = TextEditingController();
  var _sqflProv;

//  final ResultsSqlfStore _sqlfMobx = ResultsSqlfStore(); // MobX

  @override
  void initState() {
    super.initState();

    textName.text = widget.nameList;
    textAddress.text = widget.addressList;
    textLat.text = widget.latList.toString();
    textLng.text = widget.lngList.toString();
    textPhoto.text = widget.photoList;
    _sqflProv =
        Provider.of<ResultsSqflProvider>(context, listen: false); // Provider
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
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        backgroundColor: Colors.grey,
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text(
            'Lovely Favorite Places',
            style: TextStyle(color: Color(0xFFE9FFFF)),
          ),
          iconTheme: new IconThemeData(color: Color(0xFFE9FFFF)),
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
                  widget.edit ? 'Edit Place' : 'Add Place',
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
                  onPressed: () => widget.edit
                      ? _sqflProv.updateItem(
                          widget.id,
                          textName.text,
                          textAddress.text,
                          double.parse(textLat.text),
                          double.parse(textLng.text),
                          textPhoto.text,
                          context) // Provider
                      : _sqflProv.addItem(
                          textName.text,
                          textAddress.text,
                          double.parse(textLat.text),
                          double.parse(textLng.text),
                          textPhoto.text,
                          context), // Provider
//                      ? _sqlfMobx.updateItem(
//                          widget.id,
//                          textName.text,
//                          textAddress.text,
//                          double.parse(textLat.text),
//                          double.parse(textLng.text),
//                          textPhoto.text,
//                          context) // MobX
//                      : _sqlfMobx.addItem(
//                          textName.text,
//                          textAddress.text,
//                          double.parse(textLat.text),
//                          double.parse(textLng.text),
//                          textPhoto.text,
//                          context), // MobX
                  child: Container(
                    decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: <Color>[
                            Color(0xFF5e7974),
                            Color(0xFF6494ED),
                          ],
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(80.0))),
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                    child: Text(
                      widget.edit ? 'Edit Your Place' : 'Add Your Place',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          )),
        ),
        drawer: DrawerTotal());
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
