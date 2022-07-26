import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/widgets.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {


  _recuperarBancoDeDados() async{

    final caminhoBancoDeDados = await getDatabasesPath();
    //tive um erro com o nome do banco, parece que se vc tentar criar
    //o banco varias vezes ele da erro, esse codigo precisa ser otimizado
    final localBancoDeDados = join(caminhoBancoDeDados, "banco1.db");
    
    var db = await openDatabase(
      localBancoDeDados,
      version: 1,
      onCreate: (db, dbVersaoRecente){
        String sql = "CREATE TABLE tb_usuarios("
                        "id_usuario INTEGER PRIMARY KEY AUTOINCREMENT,"
                        "nome VARCHAR,"
                        "idade INTEGER"
                        ")";
        db.execute(sql);
      }
    );
    //print("aberto: " + db.isOpen.toString());
    return db;
  }

  _salvar() async {

    Database bd = await _recuperarBancoDeDados();

    Map<String, dynamic> dadosusuario ={
      "nome" : "Alexander",
      "idade" : 26
    };
    int id = await bd.insert("tb_usuarios", dadosusuario);
    print("Salvo: $id ");
  }

  _listarUsusarios() async{

    Database bd = await _recuperarBancoDeDados();

    String sql = "SELECT * FROM tb_usuarios";
    List usuarios = await bd.rawQuery(sql);

    for(var usuario in usuarios){
      print(
          "item id: " + usuario['id_usuario'].toString() +
          " nome: " + usuario['nome'] +
          " idade: "+ usuario['idade'].toString()
      );
    }
    //print("usuarios: " + usuarios.toString());
  }




  @override
  Widget build(BuildContext context) {
    //_salvar();
    _listarUsusarios();
    return Container();
  }
}
