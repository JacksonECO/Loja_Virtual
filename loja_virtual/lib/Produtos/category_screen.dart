import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lojavirtual/Produtos/product_data.dart';
import 'package:lojavirtual/Produtos/product_tile.dart';


class CategoryScreen extends StatelessWidget {

  final DocumentSnapshot snapshot;

  CategoryScreen(this.snapshot);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text(snapshot.data()["lable"]),
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
            future: FirebaseFirestore.instance.collection("products").doc(snapshot.id).collection("itens").get(),
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
                        itemCount: snapshot.data.docs.length,
                        itemBuilder: (context, index){
                          ProductData data = ProductData.fromDocument(snapshot.data.docs[index]);
                          data.category = this.snapshot.id;

                          return ProductTile("grid", data);
                        },

                      ),


                      ListView.builder(
                          padding: EdgeInsets.all(4),
                          itemBuilder:  (context, index){
                            ProductData data = ProductData.fromDocument(snapshot.data.docs[index]);
                            data.category = this.snapshot.id;

                            return ProductTile("list", data);
                          },
                          itemCount: snapshot.data.docs.length,
                      )
                    ]
                );
            },
          ),
        )
    );
  }
}
