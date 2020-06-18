import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:scoped_model/scoped_model.dart';

class UserModel extends Model{

  FirebaseAuth _auth = FirebaseAuth.instance;

  FirebaseUser _firebaseUser;
  Map<String, dynamic> userDate = Map();


  bool isLoading = false;


  @override
  void addListener(VoidCallback listener){
    super.addListener(listener);
    _loadCurrentUser();
  }

  ///Criar um Login
  void signUp({@required Map<String, dynamic> userDate, @required String pass, @required VoidCallback onSuccess, @required VoidCallback onFail}){
    isLoading=true;
    notifyListeners();

    _auth.createUserWithEmailAndPassword(
        email: userDate["email"],
        password: pass
      ).then((value) async{
        _firebaseUser = value.user;

        await _saveUserData(userDate);

        onSuccess();
        isLoading=false;
        notifyListeners();
      }).catchError((e){
        onFail();
        isLoading=false;
        notifyListeners();
      }
    );
  }

  void signIn({@required String email, @required String pass, @required VoidCallback onSuccess, @required VoidCallback onFail}) async{
    isLoading=true;
    notifyListeners();
    //Atualiza todoo o ScopedMoedelDescendant() que esta no arquivo login_screen;

    _auth.signInWithEmailAndPassword(
        email: email,
        password: pass
    ).then((value)async{
      _firebaseUser = value.user;

      await _loadCurrentUser();

      onSuccess();
      isLoading=false;
      notifyListeners();
    }).catchError((onError){
      onFail();
      isLoading=false;
      notifyListeners();
    });

  }

  void signOut() async{
    await _auth.signOut();

    userDate = Map();
    _firebaseUser = null;
    notifyListeners();
  }


  void recoverPass(String email){
    _auth.sendPasswordResetEmail(email: email);
  }

  Future<Null> _saveUserData(Map<String, dynamic> userData) async{
    this.userDate = userData;
    await Firestore.instance.collection("users").document(_firebaseUser.uid).setData(userData);
  }

  bool isLoggedIn(){
    return _firebaseUser != null;
  }

  Future<Null> _loadCurrentUser() async{
    if(_firebaseUser == null)
      _firebaseUser = await _auth.currentUser();

    if(_firebaseUser != null)
      if(userDate["name"] == null){
        DocumentSnapshot docUser = await Firestore.instance.collection("users").document(_firebaseUser.uid).get();
        userDate = docUser.data;
      }
    notifyListeners();
  }
/*
  Future<void> googleSignUp() async {
    try {
      final GoogleSignIn _googleSignIn = GoogleSignIn(
        scopes: [
          'email'
        ],
      );
      final FirebaseAuth _auth = FirebaseAuth.instance;

      final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final FirebaseUser user = (await _auth.signInWithCredential(credential)).user;
      print("signed in " + user.displayName);

      return user;
    }catch (e) {
      print(e.message);
    }
  }
  */

  Future<void> signUpWithFacebook() async{
    try {
      var facebookLogin = new FacebookLogin();
      var result = await facebookLogin.logIn(['email']);

      if(result.status == FacebookLoginStatus.loggedIn) {
        final AuthCredential credential = FacebookAuthProvider.getCredential(
          accessToken: result.accessToken.token,

        );
        final FirebaseUser user = (await FirebaseAuth.instance.signInWithCredential(credential)).user;
        print('signed in ' + user.displayName);
        return user;
      }
    }catch (e) {
      print(e.message);
    }
  }


}