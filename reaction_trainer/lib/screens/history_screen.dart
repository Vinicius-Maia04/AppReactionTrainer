import 'package:flutter/material.dart';

class HistoryPage extends StatelessWidget {
  final List<String> history;

  HistoryPage({required this.history});

  @override
  Widget build(BuildContext context) {
    // Filtra os itens de histórico para extrair os tempos de reação e convertê-los para valores numéricos.
    List<double> reactionTimes = history
        .where((entry) => entry.contains('Tempo de reação:'))
        .map((entry) {
          String timeString = entry.split(' ')[3].replaceAll('s', '');
          return double.tryParse(timeString) ?? double.infinity;
        })
        .toList();

    // Encontra o menor tempo de reação.
    double bestReactionTime = reactionTimes.isNotEmpty
        ? reactionTimes.reduce((value, element) => value < element ? value : element)
        : double.infinity;

    return Scaffold(
      appBar: AppBar(
        title: Text('Histórico', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: history.isEmpty
        ? Text('Nenhum Histórico Disponível!') 
        : Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              // Exibe o menor tempo de reação
              if (bestReactionTime != double.infinity)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Text(
                    'Melhor Tempo de Reação: ${bestReactionTime.toStringAsFixed(3)}s',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green),
                  ),
                ),
              Expanded(
                child: ListView.builder(
                  itemCount: history.length,
                  itemBuilder: (context, index) {
                    // Inverte a ordem do histórico para exibir os mais recentes primeiro
                    final item = history[history.length - 1 - index];
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text(item, style: TextStyle(fontSize: 18)),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
