import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:minhas_viagens_flutter_udemy/telas/mapa.dart';

class Home extends StatefulWidget {

  const Home({super.key});

  @override
  State<Home> createState() => _Home();
}

class _Home extends State<Home> {

  final StreamController _streamController = StreamController<QuerySnapshot>.broadcast();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final List<String> lista = [
    "Teste 1",
    "Teste 2",
    "Teste 3",
    "Teste 4",
    "Teste 5",
  ];

  _excluirViagem(String idViagem) {
    _firestore.collection("viagens")
      .doc(idViagem)
      .delete();
  }

  _abrirMapa(String idViagem){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Mapa(idViagem: idViagem)
      )
    );
  }

  _abrirLocal(){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const Mapa()
      )
    );
  }

  _addListenerViagens(){
    _firestore.collection("viagens")
      .snapshots()
      .listen((event) {
        _streamController.add(event);
      });
  }

  @override
  void initState() {
    super.initState();
    _addListenerViagens();
  }

  @override
  Widget build (BuildContext context ) {

    final StreamBuilder streamBuilder = StreamBuilder(
      stream: _streamController.stream, 
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return const Center(
              child: Column(
                children: [
                  Text("Carregando marcações"),
                  CircularProgressIndicator()
                ],
              ),
            );
          case ConnectionState.active:
          case ConnectionState.done:

            final QuerySnapshot querySnapshot = snapshot.data;

            if(!snapshot.hasData) return const Center(child: Text("Nemhum marcador adicionado"));

            return Expanded(
              child: ListView.builder(
                itemCount: querySnapshot.docs.length,
                itemBuilder: (context, index) {

                  List<DocumentSnapshot> viagens = querySnapshot.docs.toList();

                  final titulo = viagens[index]["titulo"];

                  final idViagem = viagens[index].id;

                  return Card(
                    child: ListTile(
                      onTap: () => _abrirMapa(idViagem),
                      title: Text(titulo),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GestureDetector(
                            onTap: () => _excluirViagem(idViagem),
                            child: const Padding(
                              padding: EdgeInsets.all(8),
                              child: Icon(
                              Icons.remove_circle,
                              color: Colors.red,
                            ),
                            ) 
                          )
                        ],
                      ),
                    ),
                  );
                },
              )
            );
        }
      },
    );

    return Scaffold(
      appBar: AppBar( 
        title: const Text("Minhas Viagens"),
      ),

      body: Column(
        children: [
          streamBuilder
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: _abrirLocal,
        child: const Icon(Icons.add),
      ),
    );
  }
}