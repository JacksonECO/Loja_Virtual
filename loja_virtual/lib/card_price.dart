import 'package:flutter/material.dart';
import 'package:lojavirtual/card_model.dart';
import 'package:scoped_model/scoped_model.dart';

class CardPrice extends StatelessWidget {

  final VoidCallback buy;

  CardPrice(this.buy);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Container(
        padding: EdgeInsets.all(16),
        child: ScopedModelDescendant<CardModel>(
          builder: (context, child, model){
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text("Resumo do pedido",
                  textAlign: TextAlign.start,
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 12,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("Subtotal"),
                    Text("R\$ "+ model.toPrice(model.getProductsPrice().toStringAsFixed(2))),
                    //Text("R\$ "+ model.getProductsPrice().toStringAsFixed(2)),
                  ],
                ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("Desconto"),
                    Text("R\$ "+(model.getDiscount() != 0 ? "-": "") + model.toPrice(model.getDiscount().toStringAsFixed(2)),
                      style: (model.getDiscount() != 0 ? (TextStyle(color: Colors.redAccent)) : null),
                    ),
                  ],
                ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("Frete + taxas"),
                    Text("R\$ "+ model.toPrice(model.getShip().toStringAsFixed(2))),
                  ],
                ),
                Divider(),
                SizedBox(height: 12,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("Total",
                    style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    Text("R\$ "+model.toPrice((model.getProductsPrice() + model.getShip() - model.getDiscount() ).toStringAsFixed(2)),
                      style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 16),
                    ),
                  ],
                ),
                SizedBox(height: 12,),
                RaisedButton(
                  child: Text("Finalizar Pedido"),
                  color: Theme.of(context).primaryColor,
                  textColor: Colors.white,
                  onPressed: buy,
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
