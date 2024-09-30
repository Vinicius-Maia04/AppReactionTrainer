import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:reaction_trainer/themes/app_colors.dart';

class TrainingPage extends StatefulWidget {
  final List<String> history;

  TrainingPage({required this.history});

  @override
  _TrainingPageState createState() => _TrainingPageState();
}

class _TrainingPageState extends State<TrainingPage> {
  List<Color> lampColors = List.filled(5, AppColors.lampOff);
  bool reactionStarted = false;
  bool trainingStarted = false;
  double reactionTime = 0;
  Timer? _timer;
  Stopwatch _stopwatch = Stopwatch();
  String errorMessage = '';
  TextEditingController nameController = TextEditingController(); // Controlador para o campo de nome

  @override
  void initState() {
    super.initState();
    loadHistory().then((loadedHistory) {
      setState(() {
        widget.history.clear();
        widget.history.addAll(loadedHistory);
      });
    });
  }

  void startTraining() {
    if (nameController.text.isEmpty) {
      setState(() {
        errorMessage = 'Por favor, insira seu nome antes de começar.';
      });
      return;
    }

    setState(() {
      errorMessage = '';
      reactionTime = 0;
      reactionStarted = false;
      trainingStarted = true;
      lampColors = List.filled(5, AppColors.lampOff);
    });

    int index = 0;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (index < 5) {
        setState(() {
          lampColors[index] = AppColors.lampOn;
        });
        index++;
      } else {
        int randomSeconds = Random().nextInt(8) + 1;
        Future.delayed(Duration(seconds: randomSeconds), () {
          setState(() {
            lampColors = List.filled(5, AppColors.lampOff);
            reactionStarted = true;
            _stopwatch.start();
          });
        });
        timer.cancel();
      }
    });
  }

  void stopReaction() {
    if (!reactionStarted) {
      _timer?.cancel();
      setState(() {
        String formattedDate = DateFormat('dd-MM-yyyy – kk:mm:ss').format(DateTime.now());
        errorMessage = 'Tentativa antecipada! Treinamento interrompido.';
        widget.history.add('${nameController.text} - Tentativa antecipada - Treinamento interrompido em $formattedDate');
        saveHistory(widget.history);
        trainingStarted = false;
        lampColors = List.filled(5, AppColors.lampOff);
      });
    } else {
      _stopwatch.stop();
      setState(() {
        double reactionTimeInSeconds = _stopwatch.elapsedMilliseconds / 1000.0;
        reactionTime = reactionTimeInSeconds;

        String formattedDate = DateFormat('dd-MM-yyyy – kk:mm:ss').format(DateTime.now());
        widget.history.add('${nameController.text} - Tempo de reação: ${reactionTimeInSeconds.toStringAsFixed(3)}s em $formattedDate');
        saveHistory(widget.history);
        reactionStarted = false;
        trainingStarted = false;
        lampColors = List.filled(5, AppColors.lampOff);
      });
      _stopwatch.reset();
    }
  }

  Future<void> saveHistory(List<String> history) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('history', history);
  }

  Future<List<String>> loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('history') ?? [];
  }

  @override
  void dispose() {
    _timer?.cancel();
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final media_query = MediaQuery.of(context).size;
    final screen_width = media_query.width;
    final screen_height = media_query.height;

    final is_mobile = screen_width < 600;

    return Scaffold(
      appBar: AppBar(
        title: Text('Treinamento', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: AppColors.nitroOrange,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
          width: screen_width,
          height: screen_height,
          color: AppColors.nitroBlue,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Container(
                    height: is_mobile ? 100 : 50,
                    child: Column(
                      children: [
                        if (reactionTime > 0)
                          Text('Tempo de reação: ${reactionTime.toStringAsFixed(3)}s', style: TextStyle(fontSize: 20, color: Colors.white)),
                        if (errorMessage.isNotEmpty)
                          Text(errorMessage, style: TextStyle(color: Colors.red, fontSize: 20), textAlign: TextAlign.center),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: lampColors.map((color) {
                      return Container(
                        width: screen_width / (is_mobile ? 6 : 8),
                        height: screen_width / (is_mobile ? 6 : 8),
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                        ),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 10,),
                  Container(
                    constraints: BoxConstraints(
                      maxWidth: 250
                    ),
                    child: trainingStarted ?
                    Text(nameController.text, style: TextStyle(fontSize: 25, color: Colors.white),)
                    : TextField(
                      controller: nameController,
                      style: TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        hintText: 'Insira seu nome aqui',
                        hintStyle: TextStyle(color: Colors.white),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        labelText: 'Seu Nome',
                        labelStyle: TextStyle(color: Colors.white),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color.fromARGB(255, 255, 81, 0), width: 4)
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white, width: 2)
                        )
                      ),
                    )
                  ),
                ],
              ),
              GestureDetector(
                onTapDown: (_) {
                  if (!trainingStarted) {
                    startTraining();
                  } else {
                    stopReaction();
                  }
                },
                child: Container(
                  width: screen_width / (is_mobile ? 4 : 6),
                  height: is_mobile ? (screen_width / 4) : screen_height / 8,
                  decoration: BoxDecoration(
                    color: trainingStarted ? Colors.red : Colors.green,
                    shape: is_mobile ? BoxShape.circle : BoxShape.rectangle,
                    borderRadius: is_mobile ? null : BorderRadius.circular(25),
                  ),
                  child: is_mobile
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              trainingStarted ? Icons.stop : Icons.play_arrow,
                              size: 40,
                              color: Colors.white,
                            ),
                            Text(
                              trainingStarted ? 'Parar' : 'Iniciar',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              trainingStarted ? Icons.stop : Icons.play_arrow,
                              size: 40,
                              color: Colors.white,
                            ),
                            Text(
                              trainingStarted ? 'Parar' : 'Iniciar',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
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
