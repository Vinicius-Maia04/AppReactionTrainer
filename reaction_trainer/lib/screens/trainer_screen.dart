import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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

  void startTraining() {
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
        widget.history.add('Tentativa antecipada - Treinamento interrompido em $formattedDate');
        trainingStarted = false;
        lampColors = List.filled(5, AppColors.lampOff);
      });
    } else {
      _stopwatch.stop();
      setState(() {
        double reactionTimeInSeconds = _stopwatch.elapsedMilliseconds / 1000.0;
        reactionTime = reactionTimeInSeconds;

        // Adiciona data e hora ao histórico
        String formattedDate = DateFormat('dd-MM-yyyy – kk:mm:ss').format(DateTime.now());
        widget.history.add('Tempo de reação: ${reactionTimeInSeconds.toStringAsFixed(3)}s em $formattedDate');

        reactionStarted = false;
        trainingStarted = false;
        lampColors = List.filled(5, AppColors.lampOff);
      });
      _stopwatch.reset();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Treinamento', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          Positioned(
            top: 100,
            left: 10,
            right: 10,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: lampColors.map((color) {
                    return Container(
                      width: MediaQuery.of(context).size.width / 6,
                      height: MediaQuery.of(context).size.width / 6,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                      ),
                    );
                  }).toList(),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
          Positioned(
            top: 10,
            left: 10,
            right: 10,
            child: Column(
              children: [
                if (reactionTime > 0)
                  Text('Tempo de reação: ${reactionTime.toStringAsFixed(3)}s', style: TextStyle(fontSize: 25)),
                if (errorMessage.isNotEmpty)
                  Text(errorMessage, style: TextStyle(color: Colors.red, fontSize: 25), textAlign: TextAlign.center),
              ],
            ),
          ),
          Positioned(
            bottom: 30,
            left: 10,
            right: 10,
            child: GestureDetector(
              onTapDown: (_) {
                if (!trainingStarted) {
                  startTraining();
                } else {
                  stopReaction();
                }
              },
              child: Container(
                constraints: BoxConstraints(
                  maxHeight: 150,
                  maxWidth: 150
                ),
                width: MediaQuery.of(context).size.width / 5,
                height: MediaQuery.of(context).size.width / 5,
                decoration: BoxDecoration(
                  color: trainingStarted ? Colors.red : Colors.green,
                  shape: BoxShape.circle,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      trainingStarted ? Icons.stop : Icons.play_arrow,
                      size: 50,
                      color: Colors.white,
                    ),
                    Text(
                      trainingStarted ? 'Parar' : 'Iniciar',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}








// import 'package:flutter/material.dart';
// import 'package:reaction_trainer/themes/app_colors.dart';
// import 'dart:async';
// import 'dart:math';

// class TrainingScreen extends StatefulWidget {
//   const TrainingScreen({super.key});

//   @override
//   State<TrainingScreen> createState() => _TrainingScreenState();
// }

// Duration _getRandomDelay() {
//     final random = Random();
//     double seconds = 1 + random.nextDouble() * 7; // Gera um número aleatório entre 1 e 8 segundos, incluindo frações de segundos
//     return Duration(seconds: seconds.toInt(), milliseconds: ((seconds - seconds.toInt()) * 1000).toInt());
//   }

// class _TrainingScreenState extends State<TrainingScreen> {

//   List<Color> _lampColors = List.generate(5, (index) => AppColors.lampOff);
//   Timer? _timer;
//   int _currentIndex = 0;
  
//   // Armazena o tempo aleatório gerado
//   String _randomDelayText = "";
//  Duration _delayedTime = _getRandomDelay();
//   void _startColorChange() {

//     _timer?.cancel(); // Cancela o timer se já estiver rodando
//     _timer = Timer.periodic(Duration(seconds: 1), (timer) {
//       setState(() {
//         // Alterna a cor da lâmpada atual
//         _lampColors[_currentIndex] = _lampColors[_currentIndex] = AppColors.lampOn;
//         _randomDelayText = "Tempo aleatório: ${_delayedTime.inSeconds} segundos e ${_delayedTime.inMilliseconds % 1000} milissegundos";
        
//         // Move para a próxima lâmpada
//         _currentIndex = (_currentIndex + 1) % _lampColors.length;
//       });
//     });

//     // Verifica se todas as lâmpadas passaram pela mudança
//     if (_currentIndex == _lampColors.length) {
//       // Se todas as lâmpadas foram alteradas, define um novo Timer para voltar a vermelho após um tempo aleatório
//       _timer?.cancel();
      

//       setState(() {
//             // Atualiza o texto com o tempo aleatório gerado
//             _randomDelayText = "Tempo aleatório: ${_delayedTime.inSeconds} segundos e ${_delayedTime.inMilliseconds % 1000} milissegundos";
//             Future.delayed(_delayedTime, (){});
//           });

//       Future.delayed(_delayedTime, () {
//         setState(() {
//           _lampColors = List.generate(5, (index) => AppColors.lampOff);
//         });
//       });
//     }
//   }
  

//   @override
//   void dispose() {
//     _timer?.cancel();
//     super.dispose();
//   }
  
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Treinamento'),
//         centerTitle: true,
//       ),
//       body: Column(
//         children: [
//           Padding(padding: EdgeInsets.only(top: 25)),
//           Center(
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: _lampColors.map((color) => Lamp(color: color)).toList(),
//             ),
//           ),
//           ElevatedButton(onPressed: (){
//             _startColorChange();
//           }, child: Text('Começar')),
//           Text('$_randomDelayText')
//         ],
//       ),
//     );
//   }
// }

// class Lamp extends StatelessWidget {
//   final Color color;

//   Lamp({required this.color});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: MediaQuery.of(context).size.width/6,
//       height: MediaQuery.of(context).size.width/6,
//       decoration: BoxDecoration(
//         color: color,
//         shape: BoxShape.circle,
//       ),
//     );
//   }
// }


