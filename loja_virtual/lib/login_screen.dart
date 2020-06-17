import 'package:flutter/material.dart';
import 'package:lojavirtual/sigup_screen.dart';
import 'package:lojavirtual/user_model.dart';
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
                  )
                ]
            ),
          );
        }
      )
    );
  }
}
