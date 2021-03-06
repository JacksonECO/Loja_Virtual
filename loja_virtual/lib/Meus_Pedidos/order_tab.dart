import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'file:///C:/Users/maio/Documents/GitHub/Loja_Virtual/loja_virtual/lib/Login/login_screen.dart';
import 'file:///C:/Users/maio/Documents/GitHub/Loja_Virtual/loja_virtual/lib/Model/user_model.dart';
import 'order_tile.dart';

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
            return ListView(
                  children: snapshot.data.documents.map((doc)=>OrderTile(doc.documentID)).toList(), );
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
