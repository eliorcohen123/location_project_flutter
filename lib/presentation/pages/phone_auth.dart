import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:locationprojectflutter/presentation/utils/responsive_screen.dart';
import 'package:locationprojectflutter/presentation/utils/validations.dart';
import 'package:locationprojectflutter/presentation/widgets/tff_firebase.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'list_map.dart';

class PhoneAuth extends StatefulWidget {
  @override
  _PhoneAuthState createState() => _PhoneAuthState();
}

class _PhoneAuthState extends State<PhoneAuth> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _firestore = Firestore.instance;
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _smsController = TextEditingController();
  final GlobalKey<FormState> _formKeyPhone = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeySMS = GlobalKey<FormState>();
  bool _success, _loading = false;
  String _userEmail, _textError = '', _verificationId;
  SharedPreferences _sharedPrefs;

  @override
  void initState() {
    super.initState();

    _initGetSharedPrefs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Container(
        color: Colors.blueGrey,
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Phone Auth',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.greenAccent,
                      fontSize: 40),
                ),
                SizedBox(
                  height: ResponsiveScreen().heightMediaQuery(context, 70),
                ),
                Form(
                  key: _formKeyPhone,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          bottom:
                              ResponsiveScreen().heightMediaQuery(context, 20),
                        ),
                        child: TFFFirebase(
                            icon: Icon(Icons.phone),
                            hint: "Phone",
                            controller: _phoneController,
                            obSecure: false),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left:
                                ResponsiveScreen().widthMediaQuery(context, 20),
                            right:
                                ResponsiveScreen().widthMediaQuery(context, 20),
                            bottom: MediaQuery.of(context).viewInsets.bottom),
                        child: Container(
                          child: RaisedButton(
                            highlightElevation: 0.0,
                            splashColor: Colors.greenAccent,
                            highlightColor: Colors.lightGreenAccent,
                            elevation: 0.0,
                            color: Colors.greenAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            child: Text(
                              'Send SMS',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 20),
                            ),
                            onPressed: () async {
                              if (_formKeyPhone.currentState.validate()) {
                                if (Validations()
                                    .validatePhone(_phoneController.text)) {
                                  setState(() {
                                    _loading = true;
                                    _textError = '';
                                  });
                                  Future.delayed(
                                    const Duration(milliseconds: 5000),
                                    () {
                                      setState(() {
                                        _success = false;
                                        _loading = false;
                                      });
                                    },
                                  );
                                  _verifyPhoneNumber();
                                } else if (!Validations()
                                    .validatePhone(_phoneController.text)) {
                                  setState(() {
                                    _success = false;
                                    _textError = 'Invalid Phone';
                                  });
                                }
                              }
                            },
                          ),
                          height: 50,
                          width: MediaQuery.of(context).size.width,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: ResponsiveScreen().heightMediaQuery(context, 40),
                ),
                Form(
                  key: _formKeySMS,
                  child: Padding(
                    padding: EdgeInsets.only(
                      bottom: ResponsiveScreen().heightMediaQuery(context, 20),
                    ),
                    child: TFFFirebase(
                        icon: Icon(Icons.sms),
                        hint: "SMS",
                        controller: _smsController,
                        obSecure: false),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: ResponsiveScreen().widthMediaQuery(context, 20),
                      right: ResponsiveScreen().widthMediaQuery(context, 20),
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: Container(
                    child: RaisedButton(
                      highlightElevation: 0.0,
                      splashColor: Colors.greenAccent,
                      highlightColor: Colors.lightGreenAccent,
                      elevation: 0.0,
                      color: Colors.greenAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: Text(
                        'Login after SMS',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 20),
                      ),
                      onPressed: () async {
                        if (_formKeySMS.currentState.validate()) {
                          setState(() {
                            _loading = true;
                            _textError = '';
                          });
                          Future.delayed(
                            const Duration(milliseconds: 5000),
                            () {
                              setState(() {
                                _success = false;
                                _loading = false;
                              });
                            },
                          );
                          _signInWithPhoneNumber();
                        }
                      },
                    ),
                    height: 50,
                    width: MediaQuery.of(context).size.width,
                  ),
                ),
                SizedBox(
                  height: ResponsiveScreen().heightMediaQuery(context, 5),
                ),
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    _success == null ? '' : _success ? '' : _textError,
                    style: TextStyle(color: Colors.redAccent),
                  ),
                ),
                SizedBox(
                  height: ResponsiveScreen().heightMediaQuery(context, 20),
                ),
                _loading == true ? CircularProgressIndicator() : Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _verifyPhoneNumber() async {
    setState(() {
      _textError = '';
    });
    final PhoneVerificationCompleted verificationCompleted =
        (AuthCredential phoneAuthCredential) {
      _auth.signInWithCredential(phoneAuthCredential);
      setState(() {
        _textError = 'Received phone auth credential: $phoneAuthCredential';
      });
    };

    final PhoneVerificationFailed verificationFailed =
        (AuthException authException) {
      setState(() {
        _textError =
            'Phone number verification failed. Code: ${authException.code}. Message: ${authException.message}';
      });
    };

    final PhoneCodeSent codeSent =
        (String verificationId, [int forceResendingToken]) async {
      _textError = 'Please check your phone for the verification code.';
      _verificationId = verificationId;
    };

    final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      _verificationId = verificationId;
    };

    await _auth.verifyPhoneNumber(
        phoneNumber: '+972' + _phoneController.text,
        timeout: const Duration(seconds: 5),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
  }

  void _signInWithPhoneNumber() async {
    final AuthCredential credential = PhoneAuthProvider.getCredential(
      verificationId: _verificationId,
      smsCode: _smsController.text,
    );
    final FirebaseUser user =
        (await _auth.signInWithCredential(credential)).user;
    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);

    _addToFirebase(user);
  }

  void _addToFirebase(FirebaseUser user) async {
    if (user != null) {
      setState(() {
        _success = true;
        _loading = false;
      });

      final QuerySnapshot result = await _firestore
          .collection('users')
          .where('id', isEqualTo: user.uid)
          .getDocuments();
      final List<DocumentSnapshot> documents = result.documents;
      if (documents.length == 0) {
        _firestore.collection('users').document(user.uid).setData({
          'nickname': user.displayName,
          'photoUrl': user.photoUrl,
          'id': user.uid,
          'createdAt': DateTime.now().millisecondsSinceEpoch.toString(),
          'chattingWith': null
        });

        await _sharedPrefs.setString('id', user.uid);
        await _sharedPrefs.setString('nickname', user.displayName);
        await _sharedPrefs.setString('photoUrl', user.photoUrl);
      } else {
        await _sharedPrefs.setString('id', documents[0]['id']);
        await _sharedPrefs.setString('nickname', documents[0]['nickname']);
        await _sharedPrefs.setString('photoUrl', documents[0]['photoUrl']);
        await _sharedPrefs.setString('aboutMe', documents[0]['aboutMe']);
      }

      _userEmail = user.email;
      print(_userEmail);
      _addUserEmail(_userEmail);
      _addIdEmail(user.uid);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ListMap(),
        ),
      );
    } else {
      setState(() {
        _success = false;
        _loading = false;
      });
    }
  }

  void _initGetSharedPrefs() {
    SharedPreferences.getInstance().then(
      (prefs) {
        setState(() => _sharedPrefs = prefs);
      },
    );
  }

  void _addUserEmail(String value) async {
    _sharedPrefs.setString('userEmail', value);
  }

  void _addIdEmail(String value) async {
    _sharedPrefs.setString('userIdEmail', value);
  }
}
