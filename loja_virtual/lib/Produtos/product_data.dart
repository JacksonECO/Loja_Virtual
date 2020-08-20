import 'package:cloud_firestore/cloud_firestore.dart';

class ProductData{
  String id, category;

  String title, description;

  double price;

  List modelos, images;

  ProductData.fromDocument(DocumentSnapshot snapshot){
    id = snapshot.id;
    title = snapshot.data()["title"];
    description = snapshot.data()["description"];
    price = snapshot.data()["price"] + 0.0;
    images = snapshot.data()["images"];
    modelos = snapshot.data()["modelos"];
  }

  Map<String, dynamic> toResumeMap(){//enviar para o carrinho
    return {
      "title": title,
      "description": description,
      "price": price
    };
  }

}