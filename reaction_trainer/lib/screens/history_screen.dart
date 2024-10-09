import 'package:flutter/material.dart';
import 'package:reaction_trainer/themes/app_colors.dart';
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
          backgroundColor: Colors.white,
          title: Text('Limpar Histórico', style: TextStyle(color: AppColors.powerGreen, fontWeight: FontWeight.bold),),
          content: Text('Você realmente deseja limpar todo o histórico?', style: TextStyle(color: Colors.black),),
          actions: [
            TextButton(
              child: Text('Cancelar', style: TextStyle(color: Colors.white),),
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(AppColors.powerGreen)),
            ),
            TextButton(
              child: Text('Limpar', style: TextStyle(color: Colors.white),),
              onPressed: () {
                clearHistory();
                Navigator.of(context).pop();
              },
              style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(AppColors.nitroOrange)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final media_query = MediaQuery.of(context).size;
    final screen_width = media_query.width;
    final screen_height = media_query.height;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text('Histórico', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          width: screen_width,
          height: screen_height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.nitroBlue, 
              AppColors.nitroOrange],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight)
            ),
          child: history.isEmpty
              ? Center(child: Text('Nenhum Histórico disponível', style: TextStyle(color: Colors.white, fontSize: 25),))
              : Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      Padding(padding: EdgeInsets.only(top: screen_height/8)),
                      // Exibe o nome do usuário com o menor tempo de reação
                      if (bestReactionTime != double.infinity)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: Text(
                            'Melhor Tempo: ${bestReactionTime.toStringAsFixed(3)}s por $bestUser',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.powerGreen,
                                    shadows: <Shadow>[Shadow(offset: Offset(0, 0), blurRadius: 1.5, color: Colors.black,)]),
                          ),
                        ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: history.length,
                          itemBuilder: (context, index) {
                            // Inverte a ordem do histórico para exibir os mais recentes primeiro
                            final item = history[history.length - 1 - index];
                            final parts = item.split(' em ');
                            final dataParte = parts.length > 1 ? parts[1] : ''; // Parte que contém a data
                            final informacaoParte = parts[0]; // Parte que contém o nome e o tempo de reação

                            final nameAndReaction = informacaoParte.split(' - ');
                            final userName = nameAndReaction[0]; // Nome do usuário
                            final reactionInfo = nameAndReaction.length > 1 ? nameAndReaction[1] : ''; // Tempo de reação ou outra informação

                            return Card(
                              color: Colors.white,
                              shadowColor: Colors.black,
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      userName,
                                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.nitroOrange),
                                    ),
                                    SizedBox(height: 5),
                                    if (reactionInfo.isNotEmpty)
                                      Text(
                                        reactionInfo,
                                        style: TextStyle(fontSize: 18, color: Colors.black),
                                      ),
                                    SizedBox(height: 5),
                                    if (dataParte.isNotEmpty)
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            dataParte,
                                            style: TextStyle(fontSize: 16, color: AppColors.powerGreen),
                                          ),
                                        ],
                                      ),
                                  ],
                                ),
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
                            color: AppColors.lampOff,
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
      ),
    );
  }
}
