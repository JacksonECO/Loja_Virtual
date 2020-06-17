import 'package:flutter/material.dart';
import 'package:lojavirtual/login_screen.dart';
import 'package:lojavirtual/user_model.dart';
import 'package:scoped_model/scoped_model.dart';

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
                      child: ScopedModelDescendant<UserModel>(
                          builder: (context, child, model){
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "Olá, ${!model.isLoggedIn() ? "" : model.userDate["name"] }",
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                                GestureDetector(
                                  child: Text(
                                      !model.isLoggedIn() ?
                                      "Entre ou Cadastre-se ->" : "Sair",
                                      style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      )
                                  ),
                                  onTap: (){
                                    if(!model.isLoggedIn())
                                      Navigator.of(context).push(
                                          MaterialPageRoute(builder: (context)=>LoginScreen())
                                      );
                                    else
                                      model.signOut();
                                  },
                                ),
                              ],
                            );
                          }
                      )
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
