import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:locationprojectflutter/presentation/state_management/provider/phone_sms_auth_provider.dart';
import 'package:locationprojectflutter/presentation/utils/responsive_screen.dart';
import 'package:locationprojectflutter/presentation/utils/validations.dart';
import 'package:locationprojectflutter/presentation/widgets/tff_firebase.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'list_map.dart';

class PhoneSMSAuth extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<PhoneSMSAuthProvider>(
      builder: (context, results, child) {
        return PhoneAuthProv();
      },
    );
  }
}

class PhoneAuthProv extends StatefulWidget {
  @override
  _PhoneAuthProvState createState() => _PhoneAuthProvState();
}

class _PhoneAuthProvState extends State<PhoneAuthProv> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _firestore = Firestore.instance;
  final GlobalKey<FormState> _formKeyPhone = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeySms = GlobalKey<FormState>();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _smsController1 = TextEditingController();
  final TextEditingController _smsController2 = TextEditingController();
  final TextEditingController _smsController3 = TextEditingController();
  final TextEditingController _smsController4 = TextEditingController();
  final TextEditingController _smsController5 = TextEditingController();
  final TextEditingController _smsController6 = TextEditingController();
  String _userEmail;
  FocusNode _focus1 = FocusNode();
  FocusNode _focus2 = FocusNode();
  FocusNode _focus3 = FocusNode();
  FocusNode _focus4 = FocusNode();
  FocusNode _focus5 = FocusNode();
  FocusNode _focus6 = FocusNode();
  var _provider;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _provider = Provider.of<PhoneSMSAuthProvider>(context, listen: false);
      _provider.success(null);
      _provider.loading(false);
      _provider.textError('');
      _provider.textOk('');
      _provider.verificationId(null);
    });

    _initGetSharedPrefs();
  }

  @override
  void dispose() {
    super.dispose();

    _focus1.dispose();
    _focus2.dispose();
    _focus3.dispose();
    _focus4.dispose();
    _focus5.dispose();
    _focus6.dispose();

    _phoneController.dispose();
    _smsController1.dispose();
    _smsController2.dispose();
    _smsController3.dispose();
    _smsController4.dispose();
    _smsController5.dispose();
    _smsController6.dispose();
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
                    fontSize: 40,
                  ),
                ),
                SizedBox(
                  height: ResponsiveScreen().heightMediaQuery(context, 70),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Form(
                      key: _formKeyPhone,
                      child: Padding(
                        padding: EdgeInsets.only(
                          bottom:
                              ResponsiveScreen().heightMediaQuery(context, 20),
                        ),
                        child: TFFFirebase(
                          icon: Icon(Icons.phone),
                          hint: "Phone",
                          controller: _phoneController,
                          textInputType: TextInputType.phone,
                          obSecure: false,
                        ),
                      ),
                    ),
                    Form(
                      key: _formKeySms,
                      child: Padding(
                        padding: EdgeInsets.only(
                          bottom:
                              ResponsiveScreen().heightMediaQuery(context, 20),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _tffSms(_smsController1, _focus1, _focus2, null),
                            SizedBox(
                              width: ResponsiveScreen()
                                  .widthMediaQuery(context, 5),
                            ),
                            _tffSms(_smsController2, _focus2, _focus3, _focus1),
                            SizedBox(
                              width: ResponsiveScreen()
                                  .widthMediaQuery(context, 5),
                            ),
                            _tffSms(_smsController3, _focus3, _focus4, _focus2),
                            SizedBox(
                              width: ResponsiveScreen()
                                  .widthMediaQuery(context, 5),
                            ),
                            _tffSms(_smsController4, _focus4, _focus5, _focus3),
                            SizedBox(
                              width: ResponsiveScreen()
                                  .widthMediaQuery(context, 5),
                            ),
                            _tffSms(_smsController5, _focus5, _focus6, _focus4),
                            SizedBox(
                              width: ResponsiveScreen()
                                  .widthMediaQuery(context, 5),
                            ),
                            _tffSms(_smsController6, _focus6, null, _focus5),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: ResponsiveScreen().heightMediaQuery(context, 20),
                ),
                Container(
                  alignment: Alignment.center,
                  child: _provider.successGet == null
                      ? null
                      : _provider.textErrorGet != ''
                          ? Text(
                              _provider.textErrorGet,
                              style: TextStyle(
                                color: Colors.redAccent,
                                fontSize: 15,
                              ),
                              textAlign: TextAlign.center,
                            )
                          : _provider.textOkGet != ''
                              ? Text(
                                  _provider.textOkGet,
                                  style: TextStyle(
                                    color: Colors.lightGreenAccent,
                                    fontSize: 15,
                                  ),
                                  textAlign: TextAlign.center,
                                )
                              : null,
                ),
                SizedBox(
                  height: ResponsiveScreen().heightMediaQuery(context, 20),
                ),
                _provider.loadingGet == true
                    ? CircularProgressIndicator()
                    : Container(),
                SizedBox(
                  height: ResponsiveScreen().heightMediaQuery(context, 20),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: ResponsiveScreen().widthMediaQuery(context, 20),
                    right: ResponsiveScreen().widthMediaQuery(context, 20),
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  child: Container(
                    height: ResponsiveScreen().heightMediaQuery(context, 50),
                    width: MediaQuery.of(context).size.width,
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
                          fontSize: 20,
                        ),
                      ),
                      onPressed: () {
                        if (_formKeyPhone.currentState.validate()) {
                          if (_phoneController.text.isNotEmpty) {
                            if (Validations()
                                .validatePhone(_phoneController.text)) {
                              _provider.loading(true);
                              _provider.textError('');
                              _provider.textOk('');

                              _verifyPhoneNumber();
                            } else if (!Validations()
                                .validatePhone(_phoneController.text)) {
                              _provider.success(false);
                              _provider.textError('Invalid Phone');
                            }
                          }
                        }
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: ResponsiveScreen().heightMediaQuery(context, 20),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: ResponsiveScreen().widthMediaQuery(context, 20),
                    right: ResponsiveScreen().widthMediaQuery(context, 20),
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  child: Container(
                    height: ResponsiveScreen().heightMediaQuery(context, 50),
                    width: MediaQuery.of(context).size.width,
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
                          fontSize: 20,
                        ),
                      ),
                      onPressed: () {
                        if (_formKeySms.currentState.validate()) {
                          if (_smsController1.text.isNotEmpty &&
                              _smsController2.text.isNotEmpty &&
                              _smsController3.text.isNotEmpty &&
                              _smsController4.text.isNotEmpty &&
                              _smsController5.text.isNotEmpty &&
                              _smsController6.text.isNotEmpty) {
                            _provider.loading(true);
                            _provider.textError('');

                            _signInWithPhoneNumber();
                          }
                        }
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: ResponsiveScreen().heightMediaQuery(context, 5),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _verifyPhoneNumber() async {
    final PhoneVerificationCompleted verificationCompleted =
        (AuthCredential phoneAuthCredential) {
      _auth.signInWithCredential(phoneAuthCredential).catchError(
        (error) {
          _provider.success(false);
          _provider.loading(false);
          _provider.textError(error.message);
        },
      );
      _provider.textOk('Received phone auth credential: $phoneAuthCredential');
      _provider.success(false);
      _provider.loading(false);
    };

    final PhoneVerificationFailed verificationFailed =
        (AuthException authException) {
      _provider.textError(
          'Phone number verification failed. Code: ${authException.code}. Message: ${authException.message}');
      _provider.success(false);
      _provider.loading(false);
    };

    final PhoneCodeSent codeSent =
        (String verificationId, [int forceResendingToken]) async {
      _provider.textOk('Please check your phone for the verification code.');
      _provider.verificationId(verificationId);
      _provider.success(false);
      _provider.loading(false);
    };

    final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      _provider.verificationId(verificationId);
      _provider.success(false);
      _provider.loading(false);
    };

    await _auth
        .verifyPhoneNumber(
      phoneNumber: '+972' + _phoneController.text,
      timeout: const Duration(seconds: 120),
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
      codeSent: codeSent,
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
    )
        .catchError(
      (error) {
        _provider.success(false);
        _provider.loading(false);
        _provider.textError(error.message);
      },
    );
  }

  void _signInWithPhoneNumber() async {
    final AuthCredential credential = PhoneAuthProvider.getCredential(
      verificationId: _provider.verificationIdGet,
      smsCode: _smsController1.text +
          _smsController2.text +
          _smsController3.text +
          _smsController4.text +
          _smsController5.text +
          _smsController6.text,
    );
    final FirebaseUser user =
        (await _auth.signInWithCredential(credential).catchError(
      (error) {
        _provider.success(false);
        _provider.loading(false);
        _provider.textError(error.message);
      },
    ))
            .user;
    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);

    _addToFirebase(user);
  }

  void _addToFirebase(FirebaseUser user) async {
    if (user != null) {
      _provider.success(true);
      _provider.loading(false);
      _provider.textError('');
      _provider.textOk('');

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

        await _provider.sharedGet.setString('id', user.uid);
        await _provider.sharedGet.setString('nickname', user.displayName);
        await _provider.sharedGet.setString('photoUrl', user.photoUrl);
      } else {
        await _provider.sharedGet.setString('id', documents[0]['id']);
        await _provider.sharedGet
            .setString('nickname', documents[0]['nickname']);
        await _provider.sharedGet
            .setString('photoUrl', documents[0]['photoUrl']);
        await _provider.sharedGet.setString('aboutMe', documents[0]['aboutMe']);
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
      _provider.success(false);
      _provider.loading(false);
    }
  }

  void _initGetSharedPrefs() {
    SharedPreferences.getInstance().then(
      (prefs) {
        _provider.sharedPref(prefs);
      },
    );
  }

  void _addUserEmail(String value) async {
    _provider.sharedGet.setString('userEmail', value);
  }

  void _addIdEmail(String value) async {
    _provider.sharedGet.setString('userIdEmail', value);
  }

  Widget _tffSms(TextEditingController num, FocusNode thisFocusNode,
      FocusNode nextFocusNode, FocusNode previousFocusNode) {
    return Container(
      width: 48,
      height: 48,
      alignment: Alignment.center,
      child: TextFormField(
        focusNode: thisFocusNode,
        inputFormatters: [
          LengthLimitingTextInputFormatter(1),
        ],
        keyboardType: TextInputType.number,
        onChanged: (v) {
          if (num.text.length == 1) {
            FocusScope.of(context).requestFocus(nextFocusNode);
          } else if (num.text.length == 0) {
            FocusScope.of(context).requestFocus(previousFocusNode);
          }
        },
        decoration: InputDecoration(
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
        textAlign: TextAlign.center,
        controller: num,
        validator: (String value) {
          if (value.isEmpty) {
            return '';
          }
          return null;
        },
        style: TextStyle(
          fontFamily: 'Avenir',
          color: Colors.greenAccent,
          fontSize: 17,
          fontWeight: FontWeight.w500,
          fontStyle: FontStyle.normal,
        ),
      ),
    );
  }
}
