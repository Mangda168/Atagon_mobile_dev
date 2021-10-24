import 'package:atagon_mobile_dev/model/poke.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'home.dart';
import 'dart:convert';



class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);



  @override
  _LoginState createState() => _LoginState();


}

final auth = FirebaseAuth.instance;

class _LoginState extends State<Login> {

  var url = Uri.parse('https://pokeapi.co/api/v2/pokemon/');
  late Poke poke;
  @override
  void initState(){
    super.initState();
    fetchData();
    print('2');
  }
  fetchData() async{
  var res = await http.get(url);
  print(res.body);
  var decode = jsonDecode(res.body);
  
  poke = Poke.fromJson(decode);
  }

  final List<Map> myProducts =
  List.generate(20, (index) => {"id": index, "name": "Product $index"})
      .toList();


  @override
  Widget build(BuildContext context) {
    var products;
    return Scaffold(
      appBar: AppBar(
        title: Text('รายชื่อ Pokemon'),
        actions: [
          IconButton(
              onPressed: () {
                auth.signOut().then((value) {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) {
                    return Home();
                  }));
                });
              },
              icon: const Icon(Icons.logout))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200,
                childAspectRatio: 3 / 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20),
            itemCount: myProducts.length,
            itemBuilder: (BuildContext ctx, index) {
              return Container(
                alignment: Alignment.center,
                child: Text(myProducts[index]["name"]),
                decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.circular(15)),
              );
            }),
      ),
      // body: GridView.count(crossAxisCount: 2,children: poke.pokemon.map((poke));
    );
  }


}
