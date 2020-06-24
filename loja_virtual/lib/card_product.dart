import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lojavirtual/product_data.dart';

class CardProduct {
  //Será usado no nosso carrinho de compras
  //Devemos que salvar os id,
  // pois se salvar os dados, e acontecer uma mudança de preços
  // o usuario continuará com os dados antigos

  String cid; //categoria id
  String category;
  String pid; //produto id
  String observacao;//Asimov

  int quantity;
  String modelo;

  ProductData productData; //Salvará os dados do produto sempre que carregar

  CardProduct();

  DocumentSnapshot salve;

  CardProduct.fromDocument(DocumentSnapshot document){
    cid = document.documentID;
    category = document.data["category"];
    pid = document.data["pid"];
    modelo = document.data["modelo"];
    quantity = document.data["quantity"];
    observacao = document.data["observacao"];
    salve = document;
  }

  Map<String, dynamic> toMap(){
    return {
      "category":category,
      "pid": pid,
      "quantity": quantity,
      "modelo": modelo,
      "observacao": observacao,
      //"product": productData.toResumeMap()
    };
  }

}