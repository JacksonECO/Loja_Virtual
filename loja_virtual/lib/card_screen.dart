import 'package:flutter/material.dart';
import 'package:lojavirtual/card_discount.dart';
import 'package:lojavirtual/card_model.dart';
import 'package:lojavirtual/card_price.dart';
import 'package:lojavirtual/card_ship.dart';
import 'package:lojavirtual/card_tile.dart';
import 'package:lojavirtual/login_screen.dart';
import 'package:lojavirtual/order_screen.dart';
import 'package:lojavirtual/user_model.dart';
import 'package:scoped_model/scoped_model.dart';

class CardScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Meu Carrinho"),
        centerTitle: true,
        actions: <Widget>[
          Container(
            padding: EdgeInsets.only(right: 8),
            alignment: Alignment.center,
            child: ScopedModelDescendant<CardModel>(
                builder: (context, child, model){
                  int p = model.products.length;
                  return Text(
                      ((p == 0) ? "VAZIO" : "$p " + (p==1 ? "ITEM" : "ITENS")),
                    style: TextStyle(fontSize: 15),
                  );
                }
            ),
          )
        ],
      ),
      body: ScopedModelDescendant<CardModel>(
        builder: (context, child, model){
          if(model.isLoading && UserModel.of(context).isLoggedIn())
            return Center(child: CircularProgressIndicator());
          else if(!UserModel.of(context).isLoggedIn()){
            return Container(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                      Icons.remove_shopping_cart,
                      size: 80,
                      color: Theme.of(context).primaryColor,
                  ),
                  SizedBox(height: 16,),
                  Text("Faça o login para adicionar produtos!",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16,),
                  RaisedButton(
                    child: Text("Ir para Login",
                          style: TextStyle(fontSize: 18),),
                    textColor: Colors.white,
                    color: Theme.of(context).primaryColor,
                    onPressed: (){
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context)=>LoginScreen())
                      );
                    },

                  )
                ],
              ),
            );
          }
          else if(model.products == null || model.products.length == 0){
            return Center(
              child: Text("Nenhum produto no carrinho",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
              ),
            );
          }
          else{
            return ListView(
              children: <Widget>[
                Column(
                  children: model.products.map((e){
                    return CardTile(e);
                    }).toList(),
                ),
                CardDiscount(),
                CardShip(),
                CardPrice(() async{
                  String orderID = await model.finishOrder();
                  if(orderID != null ){
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context)=>OrderScreen(orderID))
                    );
                  }
                }),
            ],
            );
          }
        },
      ),
    );
  }
}
