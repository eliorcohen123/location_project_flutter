import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:locationprojectflutter/presentation/utils/validations.dart';
import 'package:locationprojectflutter/presentation/pages/signin_firebase.dart';
import 'package:locationprojectflutter/presentation/utils/responsive_screen.dart';
import 'package:locationprojectflutter/presentation/widgets/tff_firebase.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'list_map.dart';

class RegisterEmailFirebase extends StatefulWidget {
  @override
  RegisterEmailFirebaseState createState() => RegisterEmailFirebaseState();
}

class RegisterEmailFirebaseState extends State<RegisterEmailFirebase> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _firestore = Firestore.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _success, _loading = false;
  String _userEmail, _textError = '';
  SharedPreferences _sharedPrefs;

  @override
  void initState() {
    super.initState();

    _initGetSharedPrefs();
  }

  @override
  void dispose() {
    super.dispose();

    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Form(
        key: _formKey,
        child: Container(
          color: Colors.blueGrey,
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Register',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.greenAccent,
                        fontSize: 40),
                  ),
                  SizedBox(
                    height: ResponsiveScreen().heightMediaQuery(context, 70),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      bottom: ResponsiveScreen().heightMediaQuery(context, 20),
                    ),
                    child: TFFFirebase(
                        icon: Icon(Icons.email),
                        hint: "Email",
                        controller: _emailController,
                        obSecure: false),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      bottom: ResponsiveScreen().heightMediaQuery(context, 20),
                    ),
                    child: TFFFirebase(
                        icon: Icon(Icons.lock),
                        hint: "Password",
                        controller: _passwordController,
                        obSecure: true),
                  ),
                  SizedBox(
                    height: ResponsiveScreen().heightMediaQuery(context, 20),
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
                          'Register',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 20),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            if (Validations()
                                    .validateEmail(_emailController.text) &&
                                Validations().validatePassword(
                                    _passwordController.text)) {
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
                                    _textError =
                                        'Something wrong with connection';
                                  });
                                },
                              );
                              _registerEmailFirebase();
                            } else if (!Validations()
                                .validateEmail(_emailController.text)) {
                              setState(() {
                                _success = false;
                                _textError = 'Invalid Email';
                              });
                            } else if (!Validations()
                                .validatePassword(_passwordController.text)) {
                              setState(() {
                                _success = false;
                                _textError =
                                    'Password must be at least 8 characters';
                              });
                            }
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
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SigninFirebase(),
                        ),
                      );
                    },
                    child: Text(
                      'Have an account? click here to login',
                      style: TextStyle(color: Colors.white, fontSize: 15),
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
      ),
    );
  }

  void _registerEmailFirebase() async {
    final FirebaseUser user = (await _auth.createUserWithEmailAndPassword(
      email: _emailController.text,
      password: _passwordController.text,
    ))
        .user;
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
