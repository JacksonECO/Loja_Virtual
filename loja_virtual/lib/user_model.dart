import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
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
    try {
      final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
      _firebaseAuth.signOut();

      userDate = Map();
      _firebaseUser = null;
      notifyListeners();
    }
    catch(e){
      print("google");
      try{
        await FirebaseAuth.instance.signOut();
        await _auth.signOut();
        userDate = Map();
        _firebaseUser = null;
        notifyListeners();
      }
      catch(e){
        print("Erro");
      }
    }
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

  Future<void> googleSignUp({@required VoidCallback onSuccess, @required VoidCallback onFail}) async {
    try {
      isLoading=true;
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
      _firebaseUser = (await _auth.signInWithCredential(credential)).user;
      print("signed in " + _firebaseUser.displayName);

      Map<String, dynamic> userDate = {
        "name" : _firebaseUser.displayName,
        "email" : _firebaseUser.email,
        "tel": _firebaseUser.phoneNumber,
        "photo": _firebaseUser.photoUrl
      };

      await _saveUserData(userDate);
      await _loadCurrentUser();
      onSuccess();
      isLoading=false;
      return _firebaseUser;
    }catch (e) {
      onFail();
      isLoading=false;
      print(e.message);
    }
  }

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