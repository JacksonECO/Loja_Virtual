import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lojavirtual/card_model.dart';
import 'package:lojavirtual/card_product.dart';
import 'package:lojavirtual/product_data.dart';

class CardTile extends StatelessWidget {
  
  final CardProduct cardProduct;
  
  CardTile(this.cardProduct);




  @override
  Widget build(BuildContext context) {

    Widget _buildContent(){
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(8),
            width: 120,
            child: Image.network(
              cardProduct.productData.images[0],
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    cardProduct.productData.title,
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 17),
                  ),
                  Text(
                    "Modelo: " + cardProduct.modelo,
                    style: TextStyle(fontWeight: FontWeight.w300),
                  ),
                  Text(
                    "" + ( cardProduct.observacao == null ? "" : "Obs.: " +cardProduct.observacao),
                    style: TextStyle(fontWeight: FontWeight.w300),
                    maxLines: 3,
                  ),
                  //SizedBox(height: 2,),
                  Text(
                    "R\$ " + cardProduct.productData.price.toStringAsFixed(2),
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Theme.of(context).primaryColor),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.remove),
                        color: Theme.of(context).primaryColor,
                        onPressed: cardProduct.quantity >1 ? (){
                            CardModel.of(context).decProducts(cardProduct);
                          } : null,
                      ),
                      Text(cardProduct.quantity.toString()),
                      IconButton(
                        icon: Icon(Icons.add),
                        color: Theme.of(context).primaryColor,
                        onPressed: cardProduct.quantity < 99 ? (){
                          CardModel.of(context).incProducts(cardProduct);
                        } : null,
                      ),
                      FlatButton(
                        child: Text("Remove"),
                        textColor: Colors.grey[500],
                        onPressed: (){
                          CardModel.of(context).removeCardItem(cardProduct);
                        },
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      );
    }

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),

      ///Deste modo garantimos que enquanto o aplicativo estiver aberto o preço não irar mudar uma vez que
      ///não não vai ficar pegando dados doda hora do servidor
      ///Caso esteja utilizando estoques, isso poderár ser um problema se não tratado futuramente

      child: cardProduct.productData == null ?
      FutureBuilder<DocumentSnapshot>(
        future: Firestore.instance.collection("products").document(cardProduct.category)
          .collection("itens").document(cardProduct.pid).get(),
        builder: (context, snapshot){
          if(snapshot.hasData){
            cardProduct.productData = ProductData.fromDocument(snapshot.data);
            return _buildContent();
          }
          else{
            return Container(
              height: 70,
              child: Center(child: CircularProgressIndicator()),
              alignment: Alignment.center,
            );
          }
        },
      ) :
      _buildContent(),
    );
  }
}
