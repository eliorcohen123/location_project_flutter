import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:locationprojectflutter/presentation/utils/responsive_screen.dart';
import 'package:locationprojectflutter/presentation/widgets/appbar_totar.dart';
import 'package:locationprojectflutter/presentation/widgets/drawer_total.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LiveChat extends StatefulWidget {
  const LiveChat({Key key}) : super(key: key);

  @override
  _LiveChatState createState() => _LiveChatState();
}

class _LiveChatState extends State<LiveChat> {
  Firestore _firestore = Firestore.instance;
  SharedPreferences _sharedPrefs;
  TextEditingController _messageController = TextEditingController();
  String _valueUserEmail;

  @override
  void initState() {
    super.initState();

    _initGetSharedPrefs();
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
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection('liveMessages')
                    .orderBy('date')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData)
                    return Center(
                      child: CircularProgressIndicator(),
                    );

                  List<DocumentSnapshot> docs = snapshot.data.documents;

                  List<Widget> liveMessages = docs
                      .map(
                        (doc) => _message(
                          doc.data['from'],
                          doc.data['text'],
                          _valueUserEmail == doc.data['from'],
                        ),
                      )
                      .toList();

                  return ListView(
                    children: <Widget>[
                      ...liveMessages,
                    ],
                  );
                },
              ),
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
                          hintText: 'Enter a message',
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
        _valueUserEmail = prefs.getString('userEmail') ?? 'guest@gmail.com';
      },
    );
  }

  Future<void> callback() async {
    if (_messageController.text.length > 0) {
      await _firestore.collection('liveMessages').add({
        'text': _messageController.text,
        'from': _valueUserEmail,
        'date': DateTime.now().toIso8601String().toString(),
      });
      _messageController.clear();
    }
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
