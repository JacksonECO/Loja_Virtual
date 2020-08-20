import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lojavirtual/Model/card_model.dart';

class CardDiscount extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ExpansionTile(
        title: Text("Cupom de Desconto",
          textAlign: TextAlign.start,
          style: TextStyle(fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
        leading: Icon(Icons.card_giftcard),
        trailing: Icon(Icons.add),
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(8),
            child: TextFormField(
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Digite seu Cupom"
              ),
              //initialValor inicia o campo com um texto setado
              onFieldSubmitted: (text){
                FirebaseFirestore.instance.collection("coupons").doc(text).get().then((docSnap){
                  if(docSnap.data != null){
                    int temp = docSnap.data()["percent"];
                    CardModel.of(context).setCoupon(text, temp);
                    Scaffold.of(context).showSnackBar(
                        SnackBar(content: Text("Desconto de "+ temp.toString() +"% aplicado!"),
                          backgroundColor: Theme.of(context).primaryColor)
                    );
                  }else{
                    CardModel.of(context).setCoupon(null, 0);
                    Scaffold.of(context).showSnackBar(
                        SnackBar(content: Text("Cupom não existente ou vencido"),
                          backgroundColor: Colors.red)
                    );
                  }
                });
              },
            ),
          )
        ],
      ),
    );
  }
}

