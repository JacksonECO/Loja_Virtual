import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'file:///C:/Users/maio/Documents/GitHub/Loja_Virtual/loja_virtual/lib/Login/login_sigup_screen.dart';
import 'file:///C:/Users/maio/Documents/GitHub/Loja_Virtual/loja_virtual/lib/Model/user_model.dart';
import 'package:scoped_model/scoped_model.dart';

class LoginScreen extends StatelessWidget {

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();


  final _emailControlle = TextEditingController();
  final _passControlle = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Entrar"),
        centerTitle: true,
        actions: <Widget>[
          FlatButton(
            textColor: Colors.white,
            onPressed: (){
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context)=>SigUp())
              );
            },
            child: Text(
                "CRIAR CONTA",
                style: TextStyle(fontSize: 15),
            ),
          ),
        ],
      ),
      body: ScopedModelDescendant<UserModel>(
        builder: (context, child, model){
          if(model.isLoading)
            return Center(child: CircularProgressIndicator());

          return Form(
            key: _formKey,
            child: ListView(
                padding: EdgeInsets.all(16),
                children: <Widget>[
                  TextFormField(
                    controller: _emailControlle,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: "E-mail",
                    ),
                    validator: (text){
                      if(text.isEmpty || !text.contains("@"))
                        return "E-mail inválido";
                      else
                        return null;
                    },
                  ),
                  SizedBox(height: 16,),
                  TextFormField(
                    controller: _passControlle,
                    obscureText: true,
                    autocorrect: false,
                    decoration: InputDecoration(
                      hintText: "Senha",
                    ),
                    validator: (text){
                      if(text.isEmpty || text.length<6)
                        return "Senha insuficiente";
                      else
                        return null;
                    },
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: FlatButton(
                      padding: EdgeInsets.zero,
                      onPressed: (){
                        if(_emailControlle.text.isEmpty)
                          _scaffoldKey.currentState.showSnackBar(
                            SnackBar(
                              content: Text("Insira o email para recuperação!"),
                              backgroundColor: Colors.red,
                              duration: Duration(seconds: 2),
                            )
                          );
                        else{
                          model.recoverPass(_emailControlle.text);
                          _scaffoldKey.currentState.showSnackBar(
                            SnackBar(
                              content: Text("Confira seu email!"),
                              backgroundColor: Theme.of(context).primaryColor,
                              duration: Duration(seconds: 2),
                            )
                          );
                        }
                      },
                      child: Text(
                        "Esqueci minha senha",
                        textAlign: TextAlign.right,
                        style: TextStyle(fontWeight: FontWeight.w400),
                      ),
                    ),
                  ),
                  SizedBox(height: 16,),
                  SizedBox(
                    height: 44,
                    child: RaisedButton(
                      textColor: Colors.white,
                      color: Theme.of(context).primaryColor,
                      onPressed: (){
                        if(_formKey.currentState.validate())
                          model.signIn(
                              email: _emailControlle.text,
                              pass: _passControlle.text,
                              onSuccess: (){
                                Navigator.of(context).pop();
                              },
                              onFail: (){
                                _scaffoldKey.currentState.showSnackBar(
                                    SnackBar(
                                      content: Text("Falha ao entrar!"),
                                      backgroundColor: Colors.red,
                                      duration: Duration(seconds: 2),
                                    )
                                );
                              }
                          );
                      },
                      child: Text(
                        "Entrar",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                      height: 44,
                    child: RaisedButton(
                      textColor: Colors.white,
                      color: Colors.blue[900],
                      padding: EdgeInsets.all(10),
                      onPressed: () {
                        model.isLoading = true;
                         model.signUpWithFacebook(
                             onSuccess: (){
                               if(model.userDate["ok"] == null)
                               Navigator.of(context).pushReplacement(
                                   MaterialPageRoute(builder: (context)=>SigUp())

                               );
                               else {
                                 _scaffoldKey.currentState.showSnackBar(
                                     SnackBar(
                                       content: Text("Bem vindo " +
                                           model.userDate["name"]),
                                       backgroundColor: Colors.red,
                                       duration: Duration(seconds: 2),
                                     )
                                 );
                                 Navigator.of(context).pop();
                               }
                             },
                             onFail: (){
                               _scaffoldKey.currentState.showSnackBar(
                                   SnackBar(
                                     content: Text("Falha ao entrar!"),
                                     backgroundColor: Colors.red,
                                     duration: Duration(seconds: 2),
                                   )
                               );
                             });
                         model.isLoading = false;
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          //Image.network("https://www.nicepng.com/png/detail/936-9365795_facebook-icone-facebook-twitter-icon-circle.png"),
                          Image.asset("images/facebook.png"),
                          SizedBox(width: 10,),
                          Text(
                            "Continuar com Facebook",
                            style: TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                    )
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    height: 44,
                    child: RaisedButton(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          //Image.network("https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcQjSBeQ8y4ZBqA36nZz1EfevLW9dDtgqrrA4McXg1u_gh_JKDZb&usqp=CAU"),
                          Image.asset("images/google.png"),
                          SizedBox(width: 10,),
                          Text(
                            'Entrar com Google',
                            style: TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                      textColor: Colors.black,
                      color: Colors.white,
                      padding: EdgeInsets.all(10),
                      onPressed: () {
                        model.isLoading = true;
                        model.googleSignUp(
                          onSuccess: (){
                            if(model.userDate["ok"] == null)
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(builder: (context)=>SigUp())

                              );
                            else {
                              _scaffoldKey.currentState.showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        "Bem vindo " + model.userDate["name"]),
                                    backgroundColor: Colors.red,
                                    duration: Duration(seconds: 2),
                                  )
                              );
                              Navigator.of(context).pop();
                            }

                          },
                          onFail: (){
                            _scaffoldKey.currentState.showSnackBar(
                                SnackBar(
                                  content: Text("Falha ao entrar!"),
                                  backgroundColor: Colors.red,
                                  duration: Duration(seconds: 2),
                                )
                            );
                        }
                        );
                        model.isLoading = false;
                      },
                    ),
                  ),
                ]
            ),
          );
        }
      )
    );
  }
}
