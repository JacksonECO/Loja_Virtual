import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lojavirtual/main_screen.dart';
import 'package:lojavirtual/user_model.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUsScreen extends StatelessWidget {
  final _nameControlle = TextEditingController();
  final _emailControlle = TextEditingController();
  final _menControlle = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Card(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    children: [
                      Text(
                        "Nossos Contatos",
                        style: TextStyle(fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: Theme.of(context).primaryColor
                        ),
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: <Widget>[
                          Icon(Icons.web),
                          InkWell(
                            child: Text("   Nosso Site"),
                            onTap: ()async {
                              try{
                                await launch("https://asimovjr.com.br/");
                              }catch(e){

                              }
                            },
                          )
                        ],
                      ),
                      SizedBox(height: 5,),
                      Row(
                        children: <Widget>[
                          Container(
                            width: 25,
                            child: Image.asset("images/facebook.png", fit: BoxFit.cover),
                          ),
                          InkWell(
                            child: Text("   Facebook"),
                            onTap: ()async {
                              try{
                                await launch("https://www.facebook.com/jrasimov/?ref=br_rs");
                              }catch(e){

                              }
                            },
                          )
                        ],
                      ),
                    ],
                  )
              ),
            ),
            Card(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Center(
                      child: Text(
                        "Envia-nos uma mensagem",
                        style: TextStyle(fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: Theme.of(context).primaryColor
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Seu nome: ",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    TextField(
                      controller: _nameControlle,
                      decoration: InputDecoration(
                        hintText: (UserModel.of(context).firebaseUser != null
                            ? UserModel.of(context).firebaseUser.displayName
                            : "Digite seu nome"),
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      "Seu email: ",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    TextField(
                      controller: _emailControlle,
                      decoration: InputDecoration(
                          hintText: (UserModel.of(context).firebaseUser != null
                              ? UserModel.of(context).firebaseUser.email
                              : "Digite seu e-mail")),
                    ),
                    SizedBox(height: 20),
                    Text(
                      "Mensagem: ",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    TextField(
                      controller: _menControlle,
                      decoration: InputDecoration(
                        hintText: "Digite aqui sua mensagem",
                      ),
                    ),
                    SizedBox(height: 20),
                    Center(
                      child: RaisedButton(
                        color: Theme.of(context).primaryColor,
                        textColor: Colors.white,
                        child: Text("Enviar"),
                        onPressed: () async {
                          SendMens men = SendMens(
                              (_nameControlle.text == "" && UserModel.of(context).firebaseUser != null
                                  ? UserModel.of(context).firebaseUser.displayName
                                  : _nameControlle.text),
                              (_emailControlle.text == "" && UserModel.of(context).firebaseUser != null
                                  ? UserModel.of(context).firebaseUser.email
                                  : _emailControlle.text),
                              (UserModel.of(context).firebaseUser == null ? "" : UserModel.of(context).firebaseUser.uid),
                              _menControlle.text);

                          await Firestore.instance
                              .collection("message")
                              .add(men.toMap());

                          Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => SendedMen()));
                          ///Futuramnete caso precise pegar o ID da mensagem usar:
                          ////.then((doc){cardProduct.cid = doc.documentID;
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SendMens {
  String name, email, userId, message;

  SendMens(this.name, this.email, this.userId, this.message);

  Map<String, dynamic> toMap() {
    return {
      "nome": name,
      "email": email,
      "userID": userId,
      "message": message,
    };
  }
}

class SendedMen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 3), () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    });
    return Scaffold(
        appBar: AppBar(
          title: Text("Fale conosco"),
          centerTitle: true,
        ),
        body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.check,
                  color: Theme.of(context).primaryColor,
                  size: 80,
                ),
                Text(
                  "Mensagem enviada com sucesso!",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ]),
        ));
  }
}
