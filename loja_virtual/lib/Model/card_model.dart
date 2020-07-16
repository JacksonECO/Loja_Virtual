import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lojavirtual/Carrinho/card_product.dart';
import 'file:///C:/Users/maio/Documents/GitHub/Loja_Virtual/loja_virtual/lib/Model/user_model.dart';
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

  double getProductsPrice(){
    double price = 0.0;
    for(CardProduct c in products){
      if(c.productData != null){
        price += c.quantity * c.productData.price;
      }
    }
    return price;
  }

  double getDiscount(){
    return getProductsPrice()*discountPercentage/100;
  }

  double getShip(){
    return 2.99;
  }

  String toPrice(String price) {
    List<String> s1 = List();
    int tam = price.length;

    for(int i = 0; i<tam; i++){
      s1.add(price[i]);
    }

    s1.removeAt(tam-3);
    s1.insert(tam-3, ",");

    if(tam > 6)
      s1.insert(tam-6, '.');

    if(tam > 9)
      s1.insert(tam-9, '.');

    String a = "";
    for(int q = 0; q<s1.length; q++){
      a+= s1[q];
    }
    return a;
  }

  Future<String> finishOrder() async{
    if(products.length == 0) return null;

    var time = DateTime.now();

    isLoading = true;
    notifyListeners();
    
    double productsPrice = getProductsPrice();
    double ship = getShip();
    double discount = getDiscount();
    
    DocumentReference refOrder = await Firestore.instance.collection("orders").add({
      "data": time.day.toString() + "/" + (time.month > 9 ? "" : "0") + time.month.toString() + "/" + time.year.toString(),
      "hora": (time.hour < 10 ? "0" : "") + time.hour.toString() + ":" + (time.minute < 10 ? "0" : "") + time.minute.toString(),
      "clientID": user.firebaseUser.uid,
      "products": products.map((cartProduct)=> cartProduct.toMap()).toList(),
      "ship": ship,
      "productsPrice": productsPrice,
      "discount": discount,
      "totalPrice": productsPrice + ship - discount,
      "status": 1,
    });
    
    Firestore.instance.collection("users").document(user.firebaseUser.uid).collection("orders")
        .document(refOrder.documentID).setData({
      "orderID": refOrder.documentID,
      "time": (time.hour   < 10 ? "0" : "") + time.hour.  toString() +" - "+
              (time.minute < 10 ? "0" : "") + time.minute.toString() + ":" +
              (time.second < 10 ? "0" : "") + time.second.toString() + ":" +
              (time.day    < 10 ? "0" : "") + time.day.   toString() + "/" +
              (time.month  < 10 ? "0" : "") + time.month. toString() + "/" +
                                              time.year.  toString()
              //Para poder ordenar em função do tempo na aba meus pedidos
              //Por isso a ordem invertida
    });
    
    QuerySnapshot querySnapshot = await Firestore.instance.collection("users")
        .document(user.firebaseUser.uid).collection("card").getDocuments();

    for(DocumentSnapshot doc in querySnapshot.documents){
      doc.reference.delete();
    }

    products.clear();
    couponCode = null;
    discountPercentage = 0;

    isLoading = false;
    notifyListeners();
    return refOrder.documentID;
  }

}




