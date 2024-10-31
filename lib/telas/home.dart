import 'package:flutter/material.dart';

class Home extends StatefulWidget {

  const Home({super.key});

  @override
  State<Home> createState() => _Home();
}

class _Home extends State<Home> {

  final List<String> lista = [
    "Teste 1",
    "Teste 2",
    "Teste 3",
    "Teste 4",
    "Teste 5",
  ];

  _excluirViagem(){

  }

  _abrirMapa(){

  }

  _abrirLocal(){
    
  }

  @override
  Widget build (BuildContext context ) {
    return Scaffold(
      appBar: AppBar( 
        title: const Text("Minhas Viagens"),
      ),

      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: lista.length,
              itemBuilder: (context, index) {
                final titulo = lista[index];

                return Card(
                  child: ListTile(
                    onTap: () => _abrirMapa(),
                    title: Text(titulo),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                          onTap: () => _excluirViagem(),
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
          )
        ],
      ),

      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _abrirLocal(),
      ),
    );
  }
}