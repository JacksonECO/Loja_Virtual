import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lojavirtual/login_screen.dart';
import 'package:lojavirtual/order_tile.dart';
import 'package:lojavirtual/user_model.dart';

class OrderTab extends StatelessWidget {

  @override
  Widget build(BuildContext context){
    if(UserModel.of(context).isLoggedIn()){

      String uid = UserModel.of(context).firebaseUser.uid;

      return FutureBuilder<QuerySnapshot>(
        future: Firestore.instance.collection("users").document(uid).collection("orders").orderBy("time").getDocuments(),
                //orderby ordena os doucumentos dentro de um collection de acordo com um certo dado no document
        builder: (context, snapshot){
          if(!snapshot.hasData){
            return Center(child: CircularProgressIndicator());
          }
          else{
            return Stack(
              children: <Widget>[
                ListView(
                  children: snapshot.data.documents.map((doc)=>OrderTile(doc.documentID)).toList(),
                ),

                Align(
                  child: Opacity(
                    opacity: 0.3,
                    child: Container(
                      height: 200,
                      child: Image.asset("images/asimov_publi.png",
                        fit: BoxFit.cover,
                        //color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                )
              ]
            );
          }
        },
      );
    }
    else{
      return Container(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.list,
              size: 80,
              color: Theme.of(context).primaryColor,
            ),
            SizedBox(height: 16,),
            Text("Faça o login para acompanhar seus pedidos!",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16,),
            RaisedButton(
              child: Text("Ir para tela Login",
                style: TextStyle(fontSize: 18),),
              textColor: Colors.white,
              color: Theme.of(context).primaryColor,
              onPressed: (){
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context)=>LoginScreen())
                );
              },

            )
          ],
        ),
      );
    }
  }
}
