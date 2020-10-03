import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:locationprojectflutter/core/constants/constants_images.dart';
import 'package:locationprojectflutter/presentation/state_management/provider/provider_sign_in_firebase.dart';
import 'package:locationprojectflutter/presentation/utils/shower_pages.dart';
import 'package:locationprojectflutter/presentation/utils/utils_app.dart';
import 'package:locationprojectflutter/presentation/utils/validations.dart';
import 'package:locationprojectflutter/presentation/utils/responsive_screen.dart';
import 'package:locationprojectflutter/presentation/widgets/widget_btn_firebase.dart';
import 'package:locationprojectflutter/presentation/widgets/widget_tff_firebase.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PageSignInFirebase extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ProviderSignInFirebase>(
      builder: (context, results, child) {
        return PageSignInFirebaseProv();
      },
    );
  }
}

class PageSignInFirebaseProv extends StatefulWidget {
  @override
  _PageSignInFirebaseProvState createState() => _PageSignInFirebaseProvState();
}

class _PageSignInFirebaseProvState extends State<PageSignInFirebaseProv> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _firestore = Firestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FacebookLogin _fbLogin = FacebookLogin();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  ProviderSignInFirebase _provider;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _provider = Provider.of<ProviderSignInFirebase>(context, listen: false);
      _provider.isSuccess(null);
      _provider.isLoading(false);
      _provider.textError('');
    });

    _initGetSharedPrefs();
    _checkUserLogin();
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
      backgroundColor: Colors.blueGrey,
      body: Form(
        key: _formKey,
        child: Container(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  _title(),
                  UtilsApp.dividerHeight(context, 70),
                  _textFieldsData(),
                  UtilsApp.dividerHeight(context, 20),
                  _buttonLogin(),
                  UtilsApp.dividerHeight(context, 5),
                  _showErrors(),
                  _buttonToRegister(),
                  UtilsApp.dividerHeight(context, 20),
                  _loginFacebookGmailSms(),
                  UtilsApp.dividerHeight(context, 20),
                  _loading(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _title() {
    return const Text(
      'Login',
      style: TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.greenAccent,
        fontSize: 40,
      ),
    );
  }

  Widget _textFieldsData() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(
            bottom: ResponsiveScreen().heightMediaQuery(context, 20),
          ),
          child: WidgetTFFFirebase(
            key: const Key('emailLogin'),
            icon: const Icon(Icons.email),
            hint: "Email",
            controller: _emailController,
            textInputType: TextInputType.emailAddress,
            obSecure: false,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            bottom: ResponsiveScreen().heightMediaQuery(context, 20),
          ),
          child: WidgetTFFFirebase(
            key: const Key('passwordLogin'),
            icon: const Icon(Icons.lock),
            hint: "Password",
            controller: _passwordController,
            textInputType: TextInputType.text,
            obSecure: true,
          ),
        ),
      ],
    );
  }

  Widget _buttonLogin() {
    return Padding(
      padding: EdgeInsets.only(
          left: ResponsiveScreen().widthMediaQuery(context, 20),
          right: ResponsiveScreen().widthMediaQuery(context, 20),
          bottom: MediaQuery.of(context).viewInsets.bottom),
      child: WidgetBtnFirebase(
        text: 'Login',
        onTap: () => _checkClickBtnLogin(),
      ),
    );
  }

  Widget _showErrors() {
    return Container(
      alignment: Alignment.center,
      child: Text(
        _provider.isSuccessGet == null
            ? ''
            : _provider.isSuccessGet
                ? ''
                : _provider.textErrorGet,
        style: const TextStyle(
          color: Colors.redAccent,
          fontSize: 15,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buttonToRegister() {
    return GestureDetector(
      onTap: () {
        ShowerPages.pushPageRegisterEmailFirebase(context);
      },
      child: const Text(
        'Don' + "'" + 't Have an account? click here to register',
        style: TextStyle(
          color: Colors.white,
          fontSize: 15,
        ),
      ),
    );
  }

  Widget _loginFacebookGmailSms() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: ResponsiveScreen().widthMediaQuery(context, 60),
          height: ResponsiveScreen().widthMediaQuery(context, 60),
          child: MaterialButton(
            shape: const CircleBorder(),
            child: Image.asset(ConstantsImages.FACEBOOK_ICON),
            color: Colors.white,
            onPressed: () {
              _facebookLogin();
              _provider.isLoading(true);
              _provider.textError('');
            },
          ),
        ),
        UtilsApp.dividerWidth(context, 20),
        Container(
          width: ResponsiveScreen().widthMediaQuery(context, 60),
          height: ResponsiveScreen().widthMediaQuery(context, 60),
          child: MaterialButton(
            shape: const CircleBorder(),
            child: Image.asset(ConstantsImages.GOOGLE_ICON),
            color: Colors.white,
            onPressed: () {
              _signInWithGoogle();
              _provider.isLoading(true);
              _provider.textError('');
            },
          ),
        ),
        UtilsApp.dividerWidth(context, 20),
        Container(
          width: ResponsiveScreen().widthMediaQuery(context, 60),
          height: ResponsiveScreen().widthMediaQuery(context, 60),
          child: MaterialButton(
            shape: const CircleBorder(),
            child: Image.asset(ConstantsImages.PHONE_ICON),
            color: Colors.white,
            onPressed: () {
              ShowerPages.pushPagePhoneSmsAuth(context);
            },
          ),
        ),
      ],
    );
  }

  Widget _loading() {
    return _provider.isLoadingGet == true
        ? const CircularProgressIndicator()
        : Container();
  }

  void _checkClickBtnLogin() {
    if (_formKey.currentState.validate()) {
      if (Validations().validateEmail(_emailController.text) &&
          Validations().validatePassword(_passwordController.text)) {
        _provider.isLoading(true);
        _provider.textError('');

        _loginEmailFirebase();
      } else if (!Validations().validateEmail(_emailController.text)) {
        _provider.isSuccess(false);
        _provider.textError('Invalid Email');
      } else if (!Validations().validatePassword(_passwordController.text)) {
        _provider.isSuccess(false);
        _provider.textError('Password must be at least 8 characters');
      }
    }
  }

  void _checkUserLogin() {
    _auth.currentUser().then(
          (user) => user != null
              ? ShowerPages.pushRemoveReplacementPageListMap(context)
              : null,
        );
  }

  void _loginEmailFirebase() async {
    final FirebaseUser user = (await _auth
            .signInWithEmailAndPassword(
      email: _emailController.text,
      password: _passwordController.text,
    )
            .catchError(
      (error) {
        _provider.isSuccess(false);
        _provider.isLoading(false);
        _provider.textError(error.message);
      },
    ))
        .user;

    _addToFirebase(user);
  }

  void _signInWithGoogle() async {
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
        _provider.isSuccess(false);
        _provider.isLoading(false);
        _provider.textError(error.message);
      },
    ))
            .user;
    assert(user.email != null);
    assert(user.displayName != null);
    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);

    _addToFirebase(user);
  }

  void _facebookLogin() async {
    final FacebookLoginResult facebookLoginResult =
        await _fbLogin.logIn(['email', 'public_profile']);
    FacebookAccessToken facebookAccessToken = facebookLoginResult.accessToken;
    final AuthCredential credential = FacebookAuthProvider.getCredential(
      accessToken: facebookAccessToken.token,
    );
    final FirebaseUser user =
        (await _auth.signInWithCredential(credential).catchError(
      (error) {
        _provider.isSuccess(false);
        _provider.isLoading(false);
        _provider.textError(error.message);
      },
    ))
            .user;
    assert(user.email != null);
    assert(user.displayName != null);
    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);

    _addToFirebase(user);
  }

  void _addToFirebase(FirebaseUser user) async {
    if (user != null) {
      _provider.isSuccess(true);
      _provider.isLoading(false);
      _provider.textError('');

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

        await _provider.sharedGet.setString('id', user.uid);
        await _provider.sharedGet.setString('nickname', user.displayName);
        await _provider.sharedGet.setString('photoUrl', user.photoUrl);
      } else {
        await _provider.sharedGet.setString('id', documents[0]['id']);
        await _provider.sharedGet
            .setString('nickname', documents[0]['nickname']);
        await _provider.sharedGet.setString('aboutMe', documents[0]['aboutMe']);
        await _provider.sharedGet
            .setString('photoUrl', documents[0]['photoUrl']);
      }

      print(user.email);
      _addUserEmail(user.email);
      _addIdEmail(user.uid);
      ShowerPages.pushRemoveReplacementPageListMap(context);
    } else {
      _provider.isSuccess(false);
      _provider.isLoading(false);
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
}
