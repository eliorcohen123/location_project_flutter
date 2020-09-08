import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:locationprojectflutter/data/models/model_live_chat/results_live_chat.dart';
import 'package:locationprojectflutter/presentation/state_management/provider/provider_live_chat.dart';
import 'package:locationprojectflutter/presentation/utils/responsive_screen.dart';
import 'package:locationprojectflutter/presentation/widgets/app_bar_total.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PageLiveChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ProviderLiveChat>(
      builder: (context, results, child) {
        return PageLiveChatProv();
      },
    );
  }
}

class PageLiveChatProv extends StatefulWidget {
  @override
  _PageLiveChatProvState createState() => _PageLiveChatProvState();
}

class _PageLiveChatProvState extends State<PageLiveChatProv> {
  final Stream<QuerySnapshot> _snapshots = Firestore.instance
      .collection('liveMessages')
      .orderBy('date', descending: true)
      .limit(50)
      .snapshots();
  final TextEditingController _messageController = TextEditingController();
  final _databaseReference = Firestore.instance;
  StreamSubscription<QuerySnapshot> _placeSub;
  String _valueUserEmail;
  ProviderLiveChat _provider;

  @override
  void initState() {
    super.initState();

    _provider = Provider.of<ProviderLiveChat>(context, listen: false);

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
            _listViewData(),
            _sendMessage(),
          ],
        ),
      ),
    );
  }

  Widget _listViewData() {
    return Expanded(
      child: ListView.builder(
        reverse: true,
        itemCount: _provider.placesGet.length,
        itemBuilder: (BuildContext ctx, int index) {
          return _message(
            _provider.placesGet[index].from,
            _provider.placesGet[index].text,
            _valueUserEmail == _provider.placesGet[index].from,
          );
        },
      ),
    );
  }

  Widget _sendMessage() {
    return Container(
      child: Row(
        children: <Widget>[
          _buildInput(),
          _sendButton(
            "Send",
            callback,
          ),
        ],
      ),
    );
  }

  Widget _buildInput() {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: Colors.white,
        ),
        child: TextFormField(
          style: const TextStyle(color: Colors.blueGrey),
          onSaved: (value) => callback(),
          decoration: InputDecoration(
            hintText: 'Type your message...',
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: const BorderSide(
                color: Colors.green,
                width: 2,
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: const BorderSide(
                color: Colors.green,
                width: 3,
              ),
            ),
          ),
          controller: _messageController,
        ),
      ),
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
              padding: EdgeInsets.symmetric(
                vertical: ResponsiveScreen().heightMediaQuery(context, 10),
                horizontal: ResponsiveScreen().widthMediaQuery(context, 15),
              ),
              child: Text(
                text,
                style: const TextStyle(color: Colors.blueGrey),
              ),
            ),
          ),
        ],
      ),
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

        _provider.places(places);
      },
    );
  }
}
