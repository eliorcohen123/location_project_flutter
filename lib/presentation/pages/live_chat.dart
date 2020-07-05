import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:locationprojectflutter/data/models/model_live_chat/results_live_chat.dart';
import 'package:locationprojectflutter/presentation/state_management/provider/live_chat_provider.dart';
import 'package:locationprojectflutter/presentation/widgets/appbar_total.dart';
import 'package:locationprojectflutter/presentation/widgets/drawer_total.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LiveChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<LiveChatProvider>(
      builder: (context, results, child) {
        return LiveChatProv();
      },
    );
  }
}

class LiveChatProv extends StatefulWidget {
  const LiveChatProv({Key key}) : super(key: key);

  @override
  _LiveChatProvState createState() => _LiveChatProvState();
}

class _LiveChatProvState extends State<LiveChatProv> {
  StreamSubscription<QuerySnapshot> _placeSub;
  Stream<QuerySnapshot> _snapshots =
      Firestore.instance.collection('liveMessages').limit(50).snapshots();
  TextEditingController _messageController = TextEditingController();
  final _databaseReference = Firestore.instance;
  String _valueUserEmail;
  var _provider;

  @override
  void initState() {
    super.initState();

    _provider = Provider.of<LiveChatProvider>(context, listen: false);

    _initGetSharedPrefs();
    _readFirebase();
  }

  @override
  void dispose() {
    super.dispose();

    _placeSub?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: AppBarTotal(),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                  reverse: true,
                  itemCount: _provider.placesGet.length,
                  itemBuilder: (BuildContext ctx, int index) {
                    return _message(
                      _provider.placesGet[index].from,
                      _provider.placesGet[index].text,
                      _valueUserEmail == _provider.placesGet[index].from,
                    );
                  }),
            ),
            Container(
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.white,
                      ),
                      child: TextFormField(
                        style: TextStyle(color: Colors.blueGrey),
                        onSaved: (value) => callback(),
                        decoration: InputDecoration(
                          hintText: 'Type your message...',
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide(
                              color: Colors.green,
                              width: 2,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide(
                              color: Colors.green,
                              width: 3,
                            ),
                          ),
                        ),
                        controller: _messageController,
                      ),
                    ),
                  ),
                  _sendButton(
                    "Send",
                    callback,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      drawer: DrawerTotal(),
    );
  }

  void _initGetSharedPrefs() {
    SharedPreferences.getInstance().then(
      (prefs) {
        _provider.sharedPref(prefs);
        _valueUserEmail =
            _provider.sharedGet.getString('userEmail') ?? 'guest@gmail.com';
      },
    );
  }

  void callback() async {
    if (_messageController.text.length > 0) {
      DateTime now = DateTime.now();

      await _databaseReference.collection("liveMessages").add(
        {
          'text': _messageController.text,
          'from': _valueUserEmail,
          'date': now,
        },
      ).then(
        (value) => _messageController.text = '',
      );
    }
  }

  void _readFirebase() {
    _placeSub?.cancel();
    _placeSub = _snapshots.listen(
      (QuerySnapshot snapshot) {
        final List<ResultsLiveChat> places = snapshot.documents
            .map(
              (documentSnapshot) =>
                  ResultsLiveChat.fromSqfl(documentSnapshot.data),
            )
            .toList();

        places.sort(
          (a, b) {
            return b.date.compareTo(a.date);
          },
        );

        _provider.places(places);
      },
    );
  }

  Widget _sendButton(String text, VoidCallback callback) {
    return FlatButton(
      color: Colors.greenAccent,
      textColor: Colors.blueGrey,
      onPressed: callback,
      child: Text(text),
    );
  }

  Widget _message(String from, String text, bool me) {
    return Container(
      child: Column(
        crossAxisAlignment:
            me ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            from,
            style: TextStyle(color: me ? Colors.lightGreen : Colors.lightBlue),
          ),
          Material(
            color: me ? Colors.lightGreenAccent : Colors.lightBlueAccent,
            borderRadius: BorderRadius.circular(10.0),
            elevation: 6.0,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
              child: Text(
                text,
                style: TextStyle(color: Colors.blueGrey),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
