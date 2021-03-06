import 'package:flutter/material.dart';
import 'file:///C:/Users/maio/Documents/GitHub/Loja_Virtual/loja_virtual/lib/Login/login_screen.dart';
import 'file:///C:/Users/maio/Documents/GitHub/Loja_Virtual/loja_virtual/lib/Model/user_model.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:url_launcher/url_launcher.dart';
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
                height: 180,
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
                  ScopedModelDescendant<UserModel>(

                    builder: (context, child, model) {
                      if(model.isLoggedIn() && model.userDate["photo"] != null) {
                          return Positioned(
                            right: 15,
                            top: 30,
                            child: Container(
                              width: 70,
                              child: Image.network(
                                model.userDate["photo"]),
                          ) ,
                            );
                      }else{
                          return Positioned(
                            right: 15,
                            top: 30,
                            child: Image.asset("images/logo_empresa.png",
//                            Image.network(
//                                "https://asimovjr.com.br/wp-content/themes/byron/assets/img/logo_navbar.png"
                                scale: 2.5),
                          );
                      }

                    }
                  )
                  ],
                )
              ),
              SizedBox(height: 5),
              Divider(),
              DrawerTile(Icons.home, "Início", _pagesController, 0),
              Divider(),
              DrawerTile(Icons.new_releases, "Novidades", _pagesController, 1),
              Divider(),
              DrawerTile(Icons.location_on, "Lojas", _pagesController, 2),
              Divider(),
              DrawerTile(Icons.playlist_add_check, "Meus Pedidos", _pagesController, 3),
              Divider(),
              DrawerTile(Icons.contact_mail, "Fale Conosco", _pagesController, 4),
              Divider(),
              SizedBox(height: 50),
              //SizedBox(height: 150,child: Container(color: Colors.transparent,),),
            ],
          ),
              Positioned(
                bottom: 0,
                right: 0,
                left: 0,
                child: Container(
                  height: 55,
                  child: RaisedButton(
                    padding: EdgeInsets.only(top: 5, bottom: 3),
                    color: Colors.transparent,
                    child: Image.asset("images/asimov_publi.png",
//                    Image.network(
//                      "https://asimovjr.com.br/wp-content/themes/byron/assets/img/asimov-header.png",
                      scale: 0.4,
                    ),
                    onPressed: () async {
                      try{
                        await launch("https://asimovjr.com.br/");
                      }catch(e){

                      }
                    },
                  ),
                )

              )


        ]
      ),
    );

  }


}
