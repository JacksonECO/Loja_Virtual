import 'package:flutter/material.dart';
import 'package:lojavirtual/user_model.dart';
import 'package:scoped_model/scoped_model.dart';

///Caso der erro usar um statefullWidget em vez de statelessWidget
//class SigUp extends StatefulWidget {
//  @override
//  _SigUpState createState() => _SigUpState();
//}
//
//class _SigUpState extends State<SigUp> {
//  @override
//  Widget build(BuildContext context) {
//    return Container();
//  }
//}




class SigUp extends StatelessWidget {

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();


  final _nameControlle = TextEditingController();
  final _emailControlle = TextEditingController();
  final _passControlle = TextEditingController();
  final _addressControlle = TextEditingController();
  final _telControlle = TextEditingController();
  final _fotoControlle = TextEditingController();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Criar Conta"),
        centerTitle: true,
      ),
      body: ScopedModelDescendant<UserModel>(
        builder: (context, child, model){
          return Form(
            key: _formKey,
            child: ListView(
                padding: EdgeInsets.all(16),
                children: <Widget>[
                  TextFormField(
                    controller: _nameControlle,
                    decoration: InputDecoration(
                      hintText: "Nome Completo",
                    ),
                    validator: (text){
                      if(text.isEmpty)
                        return "Campo obrigatório";
                      else
                        return null;
                    },
                  ),
                  SizedBox(height: 16,),
                  TextFormField(
                    controller: _addressControlle,
                    decoration: InputDecoration(
                      hintText: "Endereço",
                    ),
                    validator: (text){
                      if(text.isEmpty)
                        return "Campo obrigatório";
                      else
                        return null;
                    },
                  ),
                  SizedBox(height: 16,),
                  TextFormField(
                    controller: _telControlle,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      hintText: "Número de telefone",
                    ),
                    validator: (text){
                      if(text.isEmpty || text.length != 11)
                        return "Telefone inválido, não esqueça do DDD";
                      else
                        return null;
                    },
                  ),
                  SizedBox(height: 16,),
                  TextFormField(
                    controller: _fotoControlle,
                    autocorrect: false,
                    decoration: InputDecoration(
                      hintText: "Foto (opcional)",
                    ),
                    validator: (text){
                      if(!text.contains("https://") && !text.isEmpty)
                        return "Link da foto inválido";
                      else
                        return null;
                    },
                  ),
                  SizedBox(height: 16,),
                  TextFormField(
                    controller: _emailControlle,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: "E-mail",
                    ),
                    validator: (text){
                      if(text.isEmpty || !text.contains("@"))
                        return "E-mail inválido";
                      else
                        return null;
                    },
                  ),
                  SizedBox(height: 16,),
                  TextFormField(
                    controller: _passControlle,
                    obscureText: true,
                    autocorrect: false,
                    decoration: InputDecoration(
                      hintText: "Senha",
                    ),
                    validator: (text){
                      if(text.isEmpty || text.length<0)
                        return "Senha insuficiente";
                      else
                        return null;
                    },
                  ),
                  SizedBox(height: 16,),
                  SizedBox(
                    height: 44,
                    child: RaisedButton(
                      textColor: Colors.white,
                      color: Theme.of(context).primaryColor,
                      onPressed: (){
                        if(_formKey.currentState.validate()){

                          Map<String, dynamic> userDate = {
                            "name" : _nameControlle.text,
                            "email" : _emailControlle.text,
                            "address" : _addressControlle.text,
                            "tel": _telControlle.text,
                            "photo": _fotoControlle.text
                          };
                          model.signUp(
                                userDate: userDate,
                                pass: _passControlle.text,
                                onSuccess: (){
                                  _scaffoldKey.currentState.showSnackBar(
                                      SnackBar(
                                        content: Text("Usuário criado com sucesso!"),
                                        backgroundColor: Theme.of(context).primaryColor,
                                        duration: Duration(seconds: 2),
                                      )
                                  );
                                  Future.delayed(Duration(milliseconds: 1500)).then((_){
                                    Navigator.of(context).pop();
                                  });
                                },
                                onFail: (){
                                  _scaffoldKey.currentState.showSnackBar(
                                      SnackBar(
                                        content: Text("Falha ao criar usuário!"),
                                        backgroundColor: Colors.red,
                                        duration: Duration(seconds: 2),
                                      )
                                  );
                                }
                            );
                          }
                      },
                      child: Text(
                        "Criar Conta",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  )
                ]
            ),
          );
        }
      )
    );
  }
}
