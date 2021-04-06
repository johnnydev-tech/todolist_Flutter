import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List _listaTarefas = [
    "Estudar Flutter",
    "Fazer Curso",
    "Ler",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("TODO List"),
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                  itemCount: _listaTarefas.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(_listaTarefas[index]),
                    );
                  }),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.purple,
        child: Icon(Icons.add),
        tooltip: "Nova Tarefa",
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text("Nova Tarefa"),
                  content: TextField(
                    decoration: InputDecoration(labelText: "Digite sua Tarefa"),
                  ),
                  actions: [
                    FlatButton(
                      child: Text("Salvar"),
                      onPressed: () {},
                    ),
                  ],
                );
              });
        },
      ),
    );
  }
}
