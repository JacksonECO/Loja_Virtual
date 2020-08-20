import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PlacesTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance.collection("places").get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        else
          return ListView(
              children: snapshot.data.docs.map((doc) => PlacesTile(doc))
                  .toList()
          );
      },
    );
  }
}



class PlacesTile extends StatelessWidget {

  final DocumentSnapshot _documentSnapshot;
  PlacesTile(this._documentSnapshot);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            height: 150,
            padding: const EdgeInsets.all(5.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
            ),
            child: Image.network(_documentSnapshot.data()["image"],
              fit: BoxFit.cover,
            ),
          ),
          Container(
            padding: EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  _documentSnapshot.data()["title"],
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17
                  ),
                ),
                Text(_documentSnapshot.data()["address"],
                )
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              FlatButton(
                textColor: Theme.of(context).primaryColor,
                padding: EdgeInsets.zero,
                child: Text("Ver no Mapa"),
                onPressed: (){
                  launch("https://www.google.com/maps/search/?api=1&query="+
                      _documentSnapshot.data()["lat"]+","+
                      _documentSnapshot.data()["long"]);
                },
              ),
              FlatButton(
                textColor: Theme.of(context).primaryColor,
                padding: EdgeInsets.zero,
                child: Text("Ligar"),
                onPressed: (){
                  launch("tel:"+_documentSnapshot.data()["phone"]);
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}

