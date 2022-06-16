import 'package:flutter/material.dart';
import 'User.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<User>> usuarios;

  @override
  void initState() {
    super.initState();
    usuarios = getUsuario();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Users'),
        ),
        body: Center(
          child: FutureBuilder<List<User>>(
              future: usuarios,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        User usuario = snapshot.data![index];
                        return ListTile(title: Text(usuario.name!), subtitle: Text(usuario.website!));
                      });
                } else if (snapshot.hasError) {
                  return Text(snapshot.error.toString());
                }
                return const CircularProgressIndicator();
              }),
        ));
  }

  Future<List<User>> getUsuario() async {
    var url = Uri.parse('https://jsonplaceholder.typicode.com/users');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      List listaUsuario = json.decode(response.body);
      return listaUsuario.map((json) => User.fromJson(json)).toList();
    } else {
      throw Exception('Não foi possivel carregar dados');
    }
  }
}
