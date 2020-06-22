import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:locationprojectflutter/data/models/model_live_chat/results_live_chat.dart';
import 'package:locationprojectflutter/presentation/widgets/appbar_totar.dart';
import 'package:locationprojectflutter/presentation/widgets/drawer_total.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LiveChat extends StatefulWidget {
  const LiveChat({Key key}) : super(key: key);

  @override
  _LiveChatState createState() => _LiveChatState();
}

class _LiveChatState extends State<LiveChat> {
  StreamSubscription<QuerySnapshot> _placeSub;
  Stream<QuerySnapshot> _snapshots =
      Firestore.instance.collection('liveMessages').limit(50).snapshots();
  List<ResultsLiveChat> _places = List();
  SharedPreferences _sharedPrefs;
  TextEditingController _messageController = TextEditingController();
  final _databaseReference = Firestore.instance;
  String _valueUserEmail;

  @override
  void initState() {
    super.initState();

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
    _places.sort(
      (a, b) {
        return b.date.compareTo(a.date);
      },
    );
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
                  itemCount: _places.length,
                  itemBuilder: (BuildContext ctx, int index) {
                    return _message(
                      _places[index].from,
                      _places[index].text,
                      _valueUserEmail == _places[index].from,
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
        setState(() => _sharedPrefs = prefs);
        _valueUserEmail =
            _sharedPrefs.getString('userEmail') ?? 'guest@gmail.com';
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

        setState(() {
          this._places = places;
        });
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
