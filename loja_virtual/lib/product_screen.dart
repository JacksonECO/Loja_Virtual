import 'dart:ui';

import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:lojavirtual/product_dat.dart';

class ProductScreen extends StatefulWidget {

  final ProductData product;
  ProductScreen(this.product);

  @override
  _ProductScreenState createState() => _ProductScreenState(product);
}

class _ProductScreenState extends State<ProductScreen> {

  final ProductData product;
  _ProductScreenState(this.product);

  String modelos;

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).primaryColor;
    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.only(top: 15, bottom: 15),
        children: <Widget>[
          AspectRatio(
              aspectRatio: 0.9,
            child: Carousel(
              images: product.images.map((url){
                return Image.network(url, fit: BoxFit.fitWidth,);
                //NetworkImage(url);
              }).toList(),
              dotSize: 4,
              dotSpacing: 15,
              dotBgColor: Colors.white38,
              dotColor: primaryColor,
              autoplay: false,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  product.title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 3,
                ),
                Text(
                  "R\$ ${product.price.toStringAsFixed(2)}",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  "Tamanho:",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500
                  ),
                ),
                SizedBox(
                  height: 45,
                  child: GridView(
                    padding: EdgeInsets.symmetric(vertical: 4),
                    scrollDirection: Axis.horizontal,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 1,
                        mainAxisSpacing: 8,
                        childAspectRatio: 0.5
                    ),
                    children: product.modelos.map((s){
                      return GestureDetector(
                        onTap: (){
                          setState(() {
                            modelos=s;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                            border: Border.all(
                              color: modelos == s ? primaryColor : Colors.grey[500],
                              width: 3,
                            ),
                          ),
                          width: 50,
                          alignment: Alignment.center,
                          child: Text(
                              s,
                              textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    }
                    ).toList(),
                  ),
                ),
                SizedBox(height: 16,),
                SizedBox(
                    height: 44,
                    child: RaisedButton(
                      color: primaryColor,
                      textColor: Colors.white,
                      onPressed: modelos != null ?
                      (){

                      } : null,
                      child: Text(
                        "Adicionar ao Carrinho",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                ),
                SizedBox(height: 16,),
                Text(
                  "Descrição:",
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500
                  ),
                ),
                Text(
                  product.description,
                  textAlign: TextAlign.justify,
                  style: TextStyle(fontSize: 16,),
                ),
              ]
            )
          ),
        ],
      ),
    );
  }
}
