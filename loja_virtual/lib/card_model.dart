import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lojavirtual/card_product.dart';
import 'package:lojavirtual/user_model.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter/material.dart';

class CardModel extends Model{
  UserModel user;
  List<CardProduct> products = [];
  static CardModel of(BuildContext context) => ScopedModel.of<CardModel>(context);
  bool isLoading = false;
  String couponCode;
  int discountPercentage = 0;

  CardModel(this.user){
    if(user.isLoggedIn())
      _loadCardItems();
  }

  void addCartItem(CardProduct cardProduct){
    products.add(cardProduct);

    Firestore.instance.collection("users").document(user.firebaseUser.uid)
        .collection("card").add(cardProduct.toMap()).then((doc){
          cardProduct.cid = doc.documentID;
    });
    notifyListeners();
  }

  void removeCardItem(CardProduct cardProduct){
    Firestore.instance.collection("users").document(user.firebaseUser.uid)
        .collection("card").document(cardProduct.cid).delete();

    products.remove(cardProduct);
    notifyListeners();
  }

  void decProducts(CardProduct cardProduct){
    cardProduct.quantity--;

    Firestore.instance.collection("users").document(user.firebaseUser.uid).collection("card")
      .document(cardProduct.cid).updateData(cardProduct.toMap());

    notifyListeners();
  }

  void incProducts(CardProduct cardProduct){
    cardProduct.quantity++;

    Firestore.instance.collection("users").document(user.firebaseUser.uid).collection("card")
        .document(cardProduct.cid).updateData(cardProduct.toMap());

    notifyListeners();
  }

  void _loadCardItems() async{
    //é usado QuerySnapshot para amarzenar mais de 1 documento
    QuerySnapshot query = await Firestore.instance.collection("users")
        .document(user.firebaseUser.uid).collection("card").getDocuments();

    products = query.documents.map((e) => CardProduct.fromDocument(e)).toList();
    notifyListeners();
  }

  void setCoupon(String couponCode, int discountPercent){
    this.couponCode = couponCode;
    this.discountPercentage = discountPercent;
  }
}




