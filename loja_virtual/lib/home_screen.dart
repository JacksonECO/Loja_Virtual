import 'package:flutter/material.dart';
import 'package:lojavirtual/card_bottom.dart';
import 'package:lojavirtual/card_screen.dart';
import 'package:lojavirtual/products_tab.dart';
import 'custom_drawer.dart';
import 'home_tab.dart';

class HomeScreen extends StatelessWidget {
  final _pagesController = PageController();
  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _pagesController,
      physics: NeverScrollableScrollPhysics(),
      children: <Widget>[
        Scaffold(
          appBar: AppBar(
            title: Text("Produtos"),
            centerTitle: true,
          ),
          drawer: CustomDrawer(_pagesController),
          body: ProductsTab(),
          floatingActionButton: CardBottom(),
        ),
        Scaffold(
          body: HomeTab(),
          drawer: CustomDrawer(_pagesController),
        ),



        Scaffold(
          body: HomeTab(),
          drawer: CustomDrawer(_pagesController),
        ),
        Scaffold(
          body: CardScreen(),
          drawer: CustomDrawer(_pagesController),
        ),
      ],
    );
  }
}
