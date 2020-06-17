import 'package:flutter/material.dart';
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
          body: HomeTab(),
          drawer: CustomDrawer(_pagesController),
        ),
        Scaffold(
          appBar: AppBar(
            title: Text("Produtos"),
            centerTitle: true,
          ),
          drawer: CustomDrawer(_pagesController),
          body: ProductsTab(),
        ),


        Scaffold(
          body: HomeTab(),
          drawer: CustomDrawer(_pagesController),
        ),
        Scaffold(
          body: HomeTab(),
          drawer: CustomDrawer(_pagesController),
        ),
      ],
    );
  }
}
