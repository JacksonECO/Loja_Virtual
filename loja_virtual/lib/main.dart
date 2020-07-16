import 'package:flutter/material.dart';
import 'Model/card_model.dart';
import 'file:///C:/Users/maio/Documents/GitHub/Loja_Virtual/loja_virtual/lib/Model/user_model.dart';
import 'package:scoped_model/scoped_model.dart';
import 'main_screen.dart';

void main() {
  runApp(MyApp());
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