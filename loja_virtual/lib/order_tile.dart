import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lojavirtual/card_model.dart';

class OrderTile extends StatelessWidget {

  String orderID;
  OrderTile(this.orderID);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: Padding(
        padding: EdgeInsets.all(8),
        child: StreamBuilder<DocumentSnapshot>(
          stream: Firestore.instance.collection("orders").document(orderID).snapshots(),
          builder: (context, snapshot){
            if(!snapshot.hasData){
              return Center(child: CircularProgressIndicator());
            }
            else{
              int status = snapshot.data["status"];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("Código do pedido: " + snapshot.data.documentID,
                    style: TextStyle(fontWeight: FontWeight.w800),
                  ),
                  SizedBox(height: 4),
                  Text(snapshot.data["data"] + " - " + snapshot.data["hora"],
                  ),
                  SizedBox(height: 6),
                  Text("Descrição:",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 2),
                  Text(_buildProductsText(snapshot.data, context)),
                  SizedBox(height: 6),
                  Text(
                    "Status do Pedido:",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4.0,),
                  _staus(status, context),
                  ],
              );
            }
          },
        ),
      )
    );
  }

  String _buildProductsText(DocumentSnapshot snapshot, var context){
    String text = "";
    for(LinkedHashMap p in snapshot.data["products"]){
      text += p["quantity"].toString() + " x " +
              p["product"]["title"].toString() + " (R\$ " +
              CardModel.of(context).toPrice(p["product"]["price"].toStringAsFixed(2)) + ")\n";
    }
    text += "Total: R\$ " + CardModel.of(context).toPrice(snapshot.data["totalPrice"].toStringAsFixed(2));
    return text;
  }

  Widget _buildCircle(String title, String subtitle, int status, int thisStatus){

    Color backColor;
    Widget child;

    if(status < thisStatus){
      backColor = Colors.grey[500];
      child = Text(title, style: TextStyle(color: Colors.white),);
    } else if (status == thisStatus){
      backColor = Colors.blue;
      child = Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Text(title, style: TextStyle(color: Colors.white),),
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          )
        ],
      );
    } else {
      backColor = Colors.green;
      child = Icon(Icons.check, color: Colors.white,);
    }

    return Column(
      children: <Widget>[
        CircleAvatar(
          radius: 19.5,
          backgroundColor: backColor,
          child: child,
        ),
        Text(subtitle)
      ],
    );
  }

  Widget _staus(int status, BuildContext context){
    if(status < 2)
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _buildCircle("1", "Preparação", status, 1),
              Container(
                height: 1.0,
                width: 40.0,
                color: Colors.grey[500],
              ),
              _buildCircle("2", "Transporte", status, 2),
              Container(
                height: 1.0,
                width: 40.0,
                color: Colors.grey[500],
              ),
              _buildCircle("3", "Entrega", status, 3),
            ],
          ),
          SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              RaisedButton(
                child: Text("Cancelar"),
                onPressed:() {
                  return showDialog(
                      context: context,
                      builder: (context){
                        return AlertDialog(
                          title: Text("Cancelar Pedido"),
                          content: Text("Tem certeza que deseja cancelar o pedido."),
                          actions: [
                            FlatButton(
                              child: Text("Sim"),
                              onPressed: () {
                                Firestore.instance.collection("orders").document(orderID).updateData({
                                  "status": 404,
                                });
                                Navigator.of(context).pop();
                              },
                            ),
                            FlatButton(
                                child: Text("Não"),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                }
                            ),
                          ],
                        );
                      }
                  );
                }
              )
            ],
          )
        ],
      );
    else if(status == 404)
      return Align(
        child: Text(
          "Pedido Cancelado",
          style: TextStyle(color: Colors.red),
        ),
    );

    else{
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _buildCircle("1", "Aceitação", status, 1),
              Container(
                height: 1.0,
                width: 40.0,
                color: Colors.grey[500],
              ),
              _buildCircle("2", "Transporte", status, 2),
              Container(
                height: 1.0,
                width: 40.0,
                color: Colors.grey[500],
              ),
              _buildCircle("3", "Entrega", status, 3),
            ],
          ),
        ],
      );
    }
  }
}
