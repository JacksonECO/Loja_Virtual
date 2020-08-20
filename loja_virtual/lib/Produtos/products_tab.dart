import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'category_tile.dart';

class ProductsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance.collection("products").get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(
              child: CircularProgressIndicator(),
            );
          else {
            return ListView(
              children: ListTile.divideTiles(
              tiles: snapshot.data.docs.map((e) {
                return CategoryTile(e);
              }).toList(),
              color: Colors.grey[350],
            ).toList());
      }
    });
  }
}
