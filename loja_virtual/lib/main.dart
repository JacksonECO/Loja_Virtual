import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lojavirtual/Model/card_model.dart';
import 'package:lojavirtual/Model/user_model.dart';
import 'package:lojavirtual/main_screen.dart';
import 'package:scoped_model/scoped_model.dart';

void main(){
  WidgetsFlutterBinding.ensureInitialized();
  //await Firebase.initializeApp();
  runApp(Ini());
}

class Ini extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final FirebaseOptions firebaseOptions = const FirebaseOptions(
      appId: '1:448618578101:ios:0b650370bb29e29cac3efc',
      apiKey: 'AIzaSyAgUhHU8wSJgO5MVNy95tMT07NEjzMOfz0',
      projectId: 'react-native-firebase-testing',
      messagingSenderId: '448618578101',
    );
    return FutureBuilder(
      future: Firebase.initializeApp(name: "oi", options: firebaseOptions),
      builder: (context, snapshot){
        print(ConnectionState.active);
        Future.delayed(Duration(seconds: 4));
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