import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lojavirtual/Model/card_model.dart';
import 'package:lojavirtual/Model/user_model.dart';
import 'package:lojavirtual/main_screen.dart';
import 'package:scoped_model/scoped_model.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(Ini());
}

class Ini extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
//    final FirebaseOptions firebaseOptions = const FirebaseOptions(
//      apiKey: "AIzaSyAlr-89POnxazWjQq4r8bQ9qYzAENb7z8M",
//      authDomain: "loja-virtual-f8eca.firebaseapp.com",
//      databaseURL: "https://loja-virtual-f8eca.firebaseio.com",
//      projectId: "loja-virtual-f8eca",
//      storageBucket: "loja-virtual-f8eca.appspot.com",
//      messagingSenderId: "840191066817",
//      appId: "1:840191066817:android:272cdd806c6aaab9604a40",
//    );
    return FutureBuilder(
      //future: Firebase.initializeApp(),
      builder: (context, snapshot){
        print(ConnectionState.active);
        if(snapshot.hasError){
          print("erro: ${snapshot.error}");
          return Center( child: CircularProgressIndicator());
        }
        if(snapshot.connectionState == ConnectionState.done){
          print("ok");
          return MyApp();
        }

        print("????????");
        return MyApp();
      },
    );
  }
}


class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return ScopedModel<UserModel>(
            model: UserModel(),
            child: ScopedModelDescendant<UserModel>(
              //Com esta ordem sempre que mudar de usuario carregara o carrinho novamete
              //além disso nosso carrinho terá acesso ao nosso usuario, o contrário não é valido
                builder: (context, child, model) {
                  return ScopedModel<CardModel>(
                    model: CardModel(model),
                    child: MaterialApp(
                      title: "Jackson's Store",
                      theme: ThemeData(
                        //primarySwatch: Colors.blue,
                        primaryColor: Color.fromARGB(255, 4, 125, 141),
                      ),
                      home: HomeScreen(),
                    ),
                  );
                }
            )
        );
  }
}