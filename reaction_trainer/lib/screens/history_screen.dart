import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<String> history = [];
  String bestUser = '';
  double bestReactionTime = double.infinity;

  @override
  void initState() {
    super.initState();
    loadHistory().then((loadedHistory) {
      if (loadedHistory.isNotEmpty) {
        setState(() {
          history = loadedHistory;
          findBestReaction();
        });
      }
    });
  }

  Future<List<String>> loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('history') ?? [];
  }

  void findBestReaction() {
    for (var entry in history) {
      if (entry.contains('Tempo de reação:')) {
        // Extraindo o tempo de reação usando uma expressão regular
        RegExp regex = RegExp(r'Tempo de reação: (\d+\.\d+)s');
        Match? match = regex.firstMatch(entry);
        if (match != null) {
          double reactionTime = double.parse(match.group(1)!);

          // Extraindo o nome do usuário
          String userName = entry.split(' - ')[0];

          // Verifica se o tempo atual é o menor ou se é o primeiro tempo registrado
          if (reactionTime < bestReactionTime || bestReactionTime == double.infinity) {
            bestReactionTime = reactionTime;
            bestUser = userName;
          }
        }
      }
    }
  }

  Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('history');
    setState(() {
      history.clear();
      bestReactionTime = double.infinity;
      bestUser = '';
    });
  }

  void showClearHistoryDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Limpar Histórico'),
          content: Text('Você realmente deseja limpar todo o histórico?'),
          actions: [
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Limpar'),
              onPressed: () {
                clearHistory();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Histórico', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: history.isEmpty
            ? Text('Nenhum Histórico disponível')
            : Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    // Exibe o nome do usuário com o menor tempo de reação
                    if (bestReactionTime != double.infinity)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: Text(
                          'Melhor Tempo: ${bestReactionTime.toStringAsFixed(3)}s por $bestUser',
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
                            color: const Color.fromARGB(255, 191, 191, 191),
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Text(item, style: TextStyle(fontSize: 18)),
                            ),
                          );
                        },
                      ),
                    ),
                    // Botão para limpar o histórico
                    GestureDetector(
                      onTap: () {
                        showClearHistoryDialog();
                      },
                      child: Container(
                        constraints: BoxConstraints(
                          minWidth: 180,
                          maxWidth: 200,
                          maxHeight: 50,
                        ),
                        height: MediaQuery.of(context).size.height / 8,
                        width: MediaQuery.of(context).size.width / 4,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Limpar Histórico',
                              style: TextStyle(fontSize: 18, color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
