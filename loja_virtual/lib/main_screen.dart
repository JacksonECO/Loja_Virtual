import 'package:flutter/material.dart';
import 'package:lojavirtual/card_bottom.dart';
import 'package:lojavirtual/contact_us_screen.dart';
import 'package:lojavirtual/order_tab.dart';
import 'package:lojavirtual/places_tab.dart';
import 'package:lojavirtual/products_tab.dart';
import 'drawer_custom.dart';
import 'main_tab.dart';

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
          floatingActionButton: CardBottom(),
        ),



        Scaffold(
          appBar: AppBar(
            title: Text("Lojas"),
            centerTitle: true,
            elevation: 5,
          ),
          body: PlacesTab(),
          drawer: CustomDrawer(_pagesController),
          floatingActionButton: CardBottom(),
        ),
        Scaffold(
          appBar: AppBar(
            title: Text("Meus Pedidos"),
            centerTitle: true,
          ),
          body: OrderTab(),
          drawer: CustomDrawer(_pagesController),
          floatingActionButton: CardBottom(),
        ),

        Scaffold(
          appBar: AppBar(title: Text("Fale conosco"), centerTitle: true),
          body: ContactUsScreen(),
          drawer: CustomDrawer(_pagesController),
          floatingActionButton: CardBottom(),
        ),
      ],
    );
  }
}
