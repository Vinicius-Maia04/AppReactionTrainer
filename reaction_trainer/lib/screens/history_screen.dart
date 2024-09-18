import 'package:flutter/material.dart';

class HistoryPage extends StatelessWidget {
  final List<String> history; // Modifiquei para armazenar também tentativas antecipadas

  HistoryPage({required this.history});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Histórico', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
        centerTitle: true,
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: history.isEmpty
            ? Text('Nenhum histórico disponível')
            : ListView.builder(
                itemCount: history.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(history[index]),
                  );
                },
              ),
      ),
    );
  }
}
