import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:locationprojectflutter/presentation/utils/shower_pages.dart';
import 'package:locationprojectflutter/presentation/utils/validations.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProviderSignInFirebase extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _firestore = Firestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FacebookLogin _fbLogin = FacebookLogin();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  SharedPreferences _sharedPrefs;
  bool _isSuccess, _isLoading = false;
  String _textError = '';

  GlobalKey<FormState> get formKeyGet => _formKey;

  TextEditingController get emailControllerGet => _emailController;

  TextEditingController get passwordControllerGet => _passwordController;

  SharedPreferences get sharedGet => _sharedPrefs;

  bool get isSuccessGet => _isSuccess;

  bool get isLoadingGet => _isLoading;

  String get textErrorGet => _textError;

  void sharedPref(SharedPreferences sharedPrefs) {
    _sharedPrefs = sharedPrefs;
    notifyListeners();
  }

  void isSuccess(bool isSuccess) {
    _isSuccess = isSuccess;
    notifyListeners();
  }

  void isLoading(bool isLoading) {
    _isLoading = isLoading;
    notifyListeners();
  }

  void textError(String textError) {
    _textError = textError;
    notifyListeners();
  }

  void checkClickBtnLogin(BuildContext context) {
    if (_formKey.currentState.validate()) {
      if (Validations().validateEmail(_emailController.text) &&
          Validations().validatePassword(_passwordController.text)) {
        isLoading(true);
        textError('');

        _loginEmailFirebase(context);
      } else if (!Validations().validateEmail(_emailController.text)) {
        isSuccess(false);
        textError('Invalid Email');
      } else if (!Validations().validatePassword(_passwordController.text)) {
        isSuccess(false);
        textError('Password must be at least 8 characters');
      }
    }
  }

  void checkUserLogin(BuildContext context) {
    _auth.currentUser().then(
          (user) => user != null
              ? ShowerPages.pushRemoveReplacementPageListMap(context)
              : null,
        );
  }

  void _loginEmailFirebase(BuildContext context) async {
    final FirebaseUser user = (await _auth
            .signInWithEmailAndPassword(
      email: _emailController.text,
      password: _passwordController.text,
    )
            .catchError(
      (error) {
        isSuccess(false);
        isLoading(false);
        textError(error.message);
      },
    ))
        .user;

    _addToFirebase(user, context);
  }

  void signInWithGoogle(BuildContext context) async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final FirebaseUser user =
        (await _auth.signInWithCredential(credential).catchError(
      (error) {
        isSuccess(false);
        isLoading(false);
        textError(error.message);
      },
    ))
            .user;
    assert(user.email != null);
    assert(user.displayName != null);
    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);

    _addToFirebase(user, context);
  }

  void facebookLogin(BuildContext context) async {
    final FacebookLoginResult facebookLoginResult =
        await _fbLogin.logIn(['email', 'public_profile']);
    FacebookAccessToken facebookAccessToken = facebookLoginResult.accessToken;
    final AuthCredential credential = FacebookAuthProvider.getCredential(
      accessToken: facebookAccessToken.token,
    );
    final FirebaseUser user =
        (await _auth.signInWithCredential(credential).catchError(
      (error) {
        isSuccess(false);
        isLoading(false);
        textError(error.message);
      },
    ))
            .user;
    assert(user.email != null);
    assert(user.displayName != null);
    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);

    _addToFirebase(user, context);
  }

  void _addToFirebase(FirebaseUser user, BuildContext context) async {
    if (user != null) {
      isSuccess(true);
      isLoading(false);
      textError('');

      final QuerySnapshot result = await _firestore
          .collection('users')
          .where('id', isEqualTo: user.uid)
          .getDocuments();
      final List<DocumentSnapshot> documents = result.documents;
      if (documents.length == 0) {
        _firestore.collection('users').document(user.uid).setData(
          {
            'nickname': user.displayName,
            'photoUrl': user.photoUrl,
            'id': user.uid,
            'createdAt': DateTime.now().millisecondsSinceEpoch.toString(),
            'chattingWith': null
          },
        );

        await sharedGet.setString('id', user.uid);
        await sharedGet.setString('nickname', user.displayName);
        await sharedGet.setString('photoUrl', user.photoUrl);
      } else {
        await sharedGet.setString('id', documents[0]['id']);
        await sharedGet.setString('nickname', documents[0]['nickname']);
        await sharedGet.setString('aboutMe', documents[0]['aboutMe']);
        await sharedGet.setString('photoUrl', documents[0]['photoUrl']);
      }

      print(user.email);
      _addUserEmail(user.email);
      _addIdEmail(user.uid);
      ShowerPages.pushRemoveReplacementPageListMap(context);
    } else {
      isSuccess(false);
      isLoading(false);
    }
  }

  void initGetSharedPrefs() {
    SharedPreferences.getInstance().then(
      (prefs) {
        sharedPref(prefs);
      },
    );
  }

  void _addUserEmail(String value) async {
    sharedGet.setString('userEmail', value);
  }

  void _addIdEmail(String value) async {
    sharedGet.setString('userIdEmail', value);
  }
}
