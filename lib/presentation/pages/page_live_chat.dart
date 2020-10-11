import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:locationprojectflutter/presentation/state_management/provider/provider_live_chat.dart';
import 'package:locationprojectflutter/presentation/utils/responsive_screen.dart';
import 'package:locationprojectflutter/presentation/widgets/widget_app_bar_total.dart';
import 'package:provider/provider.dart';

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
  ProviderLiveChat _provider;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _provider = Provider.of<ProviderLiveChat>(context, listen: false);
      _provider.initGetSharedPrefs();
      _provider.readFirebase();
    });
  }

  @override
  void dispose() {
    super.dispose();

    _provider.placeSubGet?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: WidgetAppBarTotal(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          _listViewData(),
          _sendMessage(),
        ],
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
            _provider.valueUserEmailGet == _provider.placesGet[index].from,
          );
        },
      ),
    );
  }

  Widget _sendMessage() {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: ResponsiveScreen().heightMediaQuery(context, 5)),
      child: Container(
        child: Row(
          children: <Widget>[
            _buildInput(),
            _sendButton("Send", _provider.callback),
          ],
        ),
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
          onSaved: (value) => _provider.callback(),
          decoration: InputDecoration(
            hintText: 'Type your message...',
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(
                color: Colors.green,
                width: ResponsiveScreen().widthMediaQuery(context, 2),
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(
                color: Colors.green,
                width: ResponsiveScreen().widthMediaQuery(context, 3),
              ),
            ),
          ),
          controller: _provider.messageControllerGet,
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
            elevation: ResponsiveScreen().widthMediaQuery(context, 6),
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
}
