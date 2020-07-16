import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lojavirtual/Model/card_model.dart';
import 'file:///C:/Users/maio/Documents/GitHub/Loja_Virtual/loja_virtual/lib/Produtos/product_screen.dart';
import 'package:lojavirtual/Produtos/product_data.dart';

class ProductTile extends StatelessWidget {

  final String type;
  final ProductData product;

  ProductTile(this.type, this.product);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context)=>ProductScreen(product))
        );
      },
      child: Card(
        child: type == "grid" ?
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              AspectRatio(
                aspectRatio: 0.88,
                child: Image.network(
                  product.images[0],
                  //fit:BoxFit.cover,
                ),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(8),
                  child: Column(
                    children: <Widget>[
                      Text(
                        "${product.title}\n",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 2,
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        "R\$ "+ CardModel.of(context).toPrice(product.price.toStringAsFixed(2)),
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 17,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
      )


          :Row(
          children: <Widget>[
            Flexible(
                flex:1,
                child: Image.network(
                  product.images[0],
                 // fit:BoxFit.cover,
                  height: 250,
                ),
            ),
            Flexible(
                flex: 1,
                child: Container(
                  padding: EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        product.title,
                        style: TextStyle(
                            fontWeight: FontWeight.w500
                        ),
                      ),
                      Text(
                        "R\$ "+ CardModel.of(context).toPrice(product.price.toStringAsFixed(2)),
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 17,
                            fontWeight: FontWeight.bold
                        ),
                      ),
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
