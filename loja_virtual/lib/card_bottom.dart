import 'package:flutter/material.dart';
import 'package:lojavirtual/card_screen.dart';

class CardBottom extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
        onPressed: (){
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context)=>CardScreen()));
        },
      child: Icon(Icons.shopping_cart, color: Colors.white,),
      backgroundColor: Theme.of(context).primaryColor,
    );
  }
}
