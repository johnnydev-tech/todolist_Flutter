import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController _textController = TextEditingController();
  List _listaTarefas = [];
  Map<String, dynamic> _lastTask = Map();

  Future<File> _getFile() async {
    final diretorio = await getApplicationDocumentsDirectory();
    return File('${diretorio.path}/dados.json');
  }

  _saveFile() async {
    var arquivo = await _getFile();

    String dados = json.encode(_listaTarefas);
    arquivo.writeAsString(dados);
  }

  _saveTask() {
    String text = _textController.text;

    Map<String, dynamic> tarefa = Map();
    tarefa['titulo'] = text;
    tarefa['status'] = false;
    setState(() {
      _listaTarefas.add(tarefa);
    });
    _saveFile();
    _textController.clear();
  }

  _readFile() async {
    try {
      final arquivo = await _getFile();
      return arquivo.readAsString();
    } catch (e) {
      print(e);
      return null;
    }
  }

  _removeTask(index) {
    _listaTarefas.removeAt(index);
    _saveFile();
  }

  Widget itemList(context, index) => Dismissible(
        direction: DismissDirection.endToStart,
        key: Key(
          '${_listaTarefas[index]['titulo']}-${_listaTarefas[index]}-${DateTime.now().millisecondsSinceEpoch}',
        ),
        background: Container(
          color: Colors.red,
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Icon(
                Icons.delete,
                color: Colors.white,
              )
            ],
          ),
        ),
        onDismissed: (direction) {
          _lastTask = _listaTarefas[index];
          //Remove
          _removeTask(index);

          //snackbar
          final snackbar = SnackBar(
            content: Text('Tarefa Removida!!!'),
            action: SnackBarAction(
              label: 'Desfazer',
              onPressed: () {
                setState(() {
                  _listaTarefas.insert(index, _lastTask);
                });
                _saveFile();
              },
            ),
          );
          Scaffold.of(context).showSnackBar(snackbar);
        },
        child: CheckboxListTile(
          value: _listaTarefas[index]['status'],
          title: Text(_listaTarefas[index]['titulo']),
          onChanged: (value) {
            setState(() {
              _listaTarefas[index]['status'] = value;
            });
            _saveFile();
          },
        ),
      );

  @override
  void initState() {
    super.initState();
    _readFile().then((datas) {
      setState(() {
        _listaTarefas = json.decode(datas);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    print(_listaTarefas.toString());
    return Scaffold(
      appBar: AppBar(
        title: Text("TODO"),
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _listaTarefas.length,
                itemBuilder: itemList,
              ),
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
                    controller: _textController,
                    decoration: InputDecoration(labelText: "Digite sua Tarefa"),
                    onChanged: (text) {},
                  ),
                  actions: [
                    FlatButton(
                      child: Text("Cancelar"),
                      onPressed: () => Navigator.pop(context),
                    ),
                    FlatButton(
                      child: Text("Salvar"),
                      onPressed: () async {
                        await _saveTask();
                        Navigator.pop(context);
                      },
                    ),
                  ],
                );
              });
        },
      ),
    );
  }
}
