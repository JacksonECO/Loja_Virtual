import 'package:flutter/material.dart';

import 'drawer_tile.dart';

class CustomDrawer extends StatelessWidget {

  final PageController _pagesController;

  CustomDrawer(this._pagesController);

  @override
  Widget build(BuildContext context) {
    Widget _buildBodyBack() => Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.white,
              Colors.lightBlueAccent,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomCenter,
          )
      ),
    );
    return Drawer(
      child: Stack(
        children: <Widget>[
          _buildBodyBack(),
          ListView(
            padding: EdgeInsets.only(left: 32, top: 5),
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(bottom: 8),
                padding: EdgeInsets.fromLTRB(0, 20, 16, 8),
                height: 170,
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      top: 8,
                      left: 0,
                      child: Text("Jackson's\nStore",
                        style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Positioned(
                      left: 0,
                      bottom: 0,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text("Olá, ",
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            GestureDetector(
                              onTap: (){},
                              child: Text("Entre ou Cadastre-se ->",
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  )
                              ),
                            ),
                          ],
                        ),
                    ),
                  ],
                )
              ),
              Divider(),
              DrawerTile(Icons.home, "Início", _pagesController, 0),
              DrawerTile(Icons.list, "Produtos", _pagesController, 1),
              DrawerTile(Icons.location_on, "Lojas", _pagesController, 2),
              DrawerTile(Icons.playlist_add_check, "Meus Pedidos", _pagesController, 3),
            ],
          )
        ]
      ),
    );
  }
}
