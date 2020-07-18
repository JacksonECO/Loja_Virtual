import 'package:flutter/material.dart';
import 'package:lojavirtual/contact_us_screen.dart';
import 'package:lojavirtual/places_tab.dart';
import 'Carrinho/card_bottom.dart';
import 'Meus_Pedidos/order_tab.dart';
import 'file:///C:/Users/maio/Documents/GitHub/Loja_Virtual/loja_virtual/lib/Produtos/products_tab.dart';
import 'Drawer/drawer_custom.dart';
import 'novidades.dart';

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
