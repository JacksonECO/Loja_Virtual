import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter/material.dart';

class UserModel extends Model{

  FirebaseAuth _auth = FirebaseAuth.instance;

  //FirebaseFirestore firebaseUser;
  User firebaseUser;

  Map<String, dynamic> userDate = Map();


  bool isLoading = false;

  //Para poder ter acesso em outra class de Widget sem precisar Usar um ScopedModelDescendant
  //Usando simplesmente um UserModel.of(context)."nome da funcção"
  static UserModel of(BuildContext context) => ScopedModel.of<UserModel>(context);

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
        firebaseUser = value.user;

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
      firebaseUser = value.user;

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
      final GoogleSignIn _googleSignIn = GoogleSignIn();
      await _googleSignIn.signOut();

      final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
      _firebaseAuth.signOut();

      userDate = Map();
      firebaseUser = null;
      notifyListeners();
    }
    catch(e){
        print("Erro");
    }
  }


  void recoverPass(String email){
    _auth.sendPasswordResetEmail(email: email);
  }

  Future<Null> _saveUserData(Map<String, dynamic> userData) async{
    this.userDate = userData;
    await FirebaseFirestore.instance.collection("users").doc(firebaseUser.uid).set(userData);
  }

  bool isLoggedIn(){
    return firebaseUser != null;
  }

  Future<Null> _loadCurrentUser() async{
    if(firebaseUser == null)
      firebaseUser =  _auth.currentUser;

    if(firebaseUser != null)
      if(userDate["name"] == null){
        DocumentSnapshot docUser = await FirebaseFirestore.instance.collection("users").doc(firebaseUser.uid).get();
        userDate = docUser.data();
      }
    notifyListeners();
  }

  Future<void> googleSignUp({@required VoidCallback onSuccess, @required VoidCallback onFail}) async {
    try {
      //isLoading=true;
      final GoogleSignIn _googleSignIn = GoogleSignIn();
      final FirebaseAuth _auth = FirebaseAuth.instance;
      final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      firebaseUser = (await _auth.signInWithCredential(credential)).user;
      print("signed in " + firebaseUser.displayName);

      Map<String, dynamic> userDate = {
        "name" : firebaseUser.displayName,
        "email" : firebaseUser.email,
        "tel": firebaseUser.phoneNumber,
        "photo": firebaseUser.photoURL
      };

      await _saveUserData(userDate);
      await _loadCurrentUser();
      onSuccess();
      //isLoading=false;
      return firebaseUser;
    }catch (e) {
      onFail();
      isLoading=false;
      print(e.message);
    }
  }

  Future<void> signUpWithFacebook({@required VoidCallback onSuccess, @required VoidCallback onFail}) async{
    try {
      //isLoading=true;
      var facebookLogin = new FacebookLogin();
      var result = await facebookLogin.logIn(['email']);

      if(result.status == FacebookLoginStatus.loggedIn) {
        final AuthCredential credential = FacebookAuthProvider.credential(result.accessToken.token);

        firebaseUser = (await FirebaseAuth.instance.signInWithCredential(credential)).user;
        print('signed in ' + firebaseUser.displayName);

//        Map<String, dynamic> userDate = {
//          "name" : firebaseUser.displayName,
//          "email" : firebaseUser.email,
//          "tel": firebaseUser.phoneNumber,
//          "photo": firebaseUser.photoUrl
//        };
//
//        await _saveUserData(userDate);
        await _loadCurrentUser();
        onSuccess();
        isLoading=false;
        return firebaseUser;
      }
    }catch (e) {
      onFail();
      //isLoading=false;
      print(e.message);
    }
  }

  Future<void> complement(Map<String, dynamic> userData) async {
    try{
      await _saveUserData(userDate);
      await _loadCurrentUser();
    }
    catch(e){
      print(e);
    }

  }
}