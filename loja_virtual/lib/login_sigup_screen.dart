import 'package:flutter/material.dart';
import 'package:flutter_correios/model/resultado_cep.dart';
import 'package:lojavirtual/user_model.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_correios/flutter_correios.dart';

///Caso der erro usar um statefullWidget em vez de statelessWidget
class SigUp extends StatefulWidget {
  @override
  _SigUpState createState() => _SigUpState();
}

class _SigUpState extends State<SigUp> {


//class SigUp extends StatelessWidget {

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();


  final _nameControlle = TextEditingController();
  final _emailControlle = TextEditingController();
  final _passControlle = TextEditingController();
  final _addressControlle = TextEditingController();
  final _telControlle = TextEditingController();
  final _fotoControlle = TextEditingController();
  final _cepControlle = TextEditingController();
  final _complementControlle = TextEditingController();
  final _cityControlle = TextEditingController();
  final _neighborControlle = TextEditingController();
  final _stateControlle = TextEditingController();

  final FlutterCorreios fc = FlutterCorreios();

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
          if(model.isLoggedIn()){
            _nameControlle.text = model.userDate["name"];
            //_emailControlle.
            _addressControlle.text = model.userDate["address"];
            _telControlle.text = model.userDate["tel"];
            _fotoControlle.text = model.userDate["photo"];
          }

          return Form(
            key: _formKey,
            child: ListView(
                padding: EdgeInsets.all(16),
                children: <Widget>[
                  TextFormField(
                    controller: _nameControlle,
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                      labelText: "Nome Completo",
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
                    controller: _cepControlle,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "CEP",
                      hintText: "sem usar -"
                    ),
                    onChanged: (text) async {
                      if(text.length==8){
                        ResultadoCEP resultado = await fc.consultarCEP(cep: text);

                        if(_addressControlle.text == "")
                          _addressControlle.text = resultado.logradouro;
                        if(_neighborControlle.text == "")
                          _neighborControlle.text =resultado.bairro;
                        if(_stateControlle.text == "")
                          _stateControlle.text = resultado.estado;
                        if(_cityControlle.text == "")
                          _cityControlle.text = resultado.cidade;
                      }
                    },
                    validator: (text){
                      if(text.isEmpty)
                        if(text.length != 8)
                          return "CEP incorreto";
                        else
                          return "Campo obrigatório";
                      else
                        return null;
                    },
                  ),
                  SizedBox(height: 16,),
                  TextFormField(
                    controller: _stateControlle,
                    keyboardType: TextInputType.streetAddress,
                    decoration: InputDecoration(
                      labelText: "Estado",
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
                    controller: _cityControlle,
                    keyboardType: TextInputType.streetAddress,
                    decoration: InputDecoration(
                      labelText: "Cidade",
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
                    controller: _neighborControlle,
                    keyboardType: TextInputType.streetAddress,
                    decoration: InputDecoration(
                      labelText: "Bairro",
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
                    keyboardType: TextInputType.streetAddress,
                    decoration: InputDecoration(
                      labelText: "Endereço",
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
                    controller: _complementControlle,
                    keyboardType: TextInputType.streetAddress,
                    decoration: InputDecoration(
                      labelText: "Complemento",
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
                      labelText: "Número de telefone",
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
                      labelText: "Foto (opcional)",
                    ),
                    validator: (text){
                      if(!text.contains("https://") && !text.isEmpty)
                        return "Link da foto inválido";
                      else
                        return null;
                    },
                  ),
                  SizedBox(height: 16,),



                  (model.isLoggedIn() ? SizedBox() :
                  TextFormField(
                    controller: _emailControlle,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: "E-mail",
                    ),
                    validator: (text){
                      if(text.isEmpty || !text.contains("@"))
                        return "E-mail inválido";
                      else
                        return null;
                    },
                  )),
                  (model.isLoggedIn() ? SizedBox() : SizedBox(height: 16,)),
                  (model.isLoggedIn() ? SizedBox() :
                  TextFormField(
                    controller: _passControlle,
                    obscureText: true,
                    autocorrect: false,
                    decoration: InputDecoration(
                      labelText: "Senha",
                    ),
                    validator: (text){
                      if(text.isEmpty || text.length<0)
                        return "Senha insuficiente";
                      else
                        return null;
                    },
                  )),
                  (model.isLoggedIn() ? SizedBox() : SizedBox(height: 16,)),


                  SizedBox(//logado com o Facebook ou Google
                    height: 44,
                    child: RaisedButton(
                      textColor: Colors.white,
                      color: Theme.of(context).primaryColor,
                      onPressed: () async {
                        if(_formKey.currentState.validate()){

                          Map<String, dynamic> userDate = {
                            "name"        : _nameControlle.text,
                            "email"       : _emailControlle.text,
                            "address"     : _addressControlle.text,
                            "tel"         : _telControlle.text,
                            "photo"       : _fotoControlle.text,
                            "complement"  : _complementControlle,
                            "neighbor"    : _neighborControlle,
                            "city"        : _cityControlle,
                            "state"       : _stateControlle,
                            "ok"          : true,
                          };

                          if (model.isLoggedIn()) {
                            await model.complement(userDate);
                            _scaffoldKey.currentState.showSnackBar(
                                SnackBar(
                                  content: Text(
                                      "Bem vindo "+ model.userDate["name"]),
                                  backgroundColor: Theme
                                      .of(context)
                                      .primaryColor,
                                  duration: Duration(seconds: 2),
                                )
                            );
                            Future.delayed(Duration(milliseconds: 1500))
                                .then((_) {
                              Navigator.of(context).pop();
                            });
                          }
                          else {
                            model.signUp(
                                userDate: userDate,
                                pass: _passControlle.text,
                                onSuccess: () {
                                  _scaffoldKey.currentState.showSnackBar(
                                      SnackBar(
                                        content: Text(
                                            "Usuário criado com sucesso!"),
                                        backgroundColor: Theme
                                            .of(context)
                                            .primaryColor,
                                        duration: Duration(seconds: 2),
                                      )
                                  );
                                  Future.delayed(Duration(milliseconds: 1500))
                                      .then((_) {
                                    Navigator.of(context).pop();
                                  });
                                },
                                onFail: () {
                                  _scaffoldKey.currentState.showSnackBar(
                                      SnackBar(
                                        content: Text(
                                            "Falha ao criar usuário!"),
                                        backgroundColor: Colors.red,
                                        duration: Duration(seconds: 2),
                                      )
                                  );
                                }
                            );
                          }

                        }
                      },
                      child: Text(
                        "Criar Conta",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),

                ]
            ),
          );
        }
      )
    );
  }
}
