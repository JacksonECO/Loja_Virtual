import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lojavirtual/product_dat.dart';
import 'package:lojavirtual/product_tile.dart';

class CategoryScreen extends StatelessWidget {

  final DocumentSnapshot snapshot;

  CategoryScreen(this.snapshot);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text(snapshot.data["lable"]),
            centerTitle: true,
            bottom: TabBar(
                indicatorColor: Colors.white,
                tabs: <Widget>[
                  Tab(icon: Icon(Icons.grid_on),),
                  Tab(icon: Icon(Icons.list),),
                ]
            ),
          ),
          body: FutureBuilder<QuerySnapshot>(
            future: Firestore.instance.collection("products").document(snapshot.documentID).collection("itens").getDocuments(),
            builder: (context,snapshot){
              print(snapshot);
              if(!snapshot.hasData)
                return Center(child: CircularProgressIndicator(),);
              else
                return TabBarView(
                    physics: NeverScrollableScrollPhysics(),
                    children: <Widget>[
                      GridView.builder(
                        padding: EdgeInsets.all(4),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 4,
                            crossAxisSpacing: 4,
                            childAspectRatio: 0.65,
                        ),
                        itemCount: snapshot.data.documents.length,
                        itemBuilder: (context, index){
                          return ProductTile("grid", ProductData.fromDocument(snapshot.data.documents[index]));
                        },

                      ),


                      ListView.builder(
                          padding: EdgeInsets.all(4),
                          itemBuilder:  (context, index){
                            return ProductTile("list", ProductData.fromDocument(snapshot.data.documents[index]));
                          },
                          itemCount: snapshot.data.documents.length,
                      )
                    ]
                );
            },
          ),
        )
    );
  }
}
