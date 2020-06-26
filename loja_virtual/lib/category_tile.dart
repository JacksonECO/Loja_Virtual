import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lojavirtual/category_screen.dart';

class CategoryTile extends StatelessWidget {

  final DocumentSnapshot snapshot;
  CategoryTile(this.snapshot);



  @override
  Widget build(BuildContext context){
    final Map<String, Widget> icon= {
      "tv": Icon(Icons.tv, size: 40, color: Theme.of(context).primaryColor),
      "smartphone": Icon(Icons.smartphone, size: 40, color: Theme.of(context).primaryColor)
    };
    return ListTile(
      contentPadding: EdgeInsets.only(top: 7, left: 10, bottom: 7,right: 7),
      leading: icon[snapshot.data["lable"].toString().toLowerCase()],
      title: Text(snapshot.data["lable"]),
      trailing: Icon(Icons.keyboard_arrow_right),
      onTap: (){
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context)=>CategoryScreen(snapshot))
        );
      },
    );
  }
}
