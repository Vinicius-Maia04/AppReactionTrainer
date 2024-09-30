import 'package:flutter/material.dart';
import 'package:reaction_trainer/screens/history_screen.dart';
import 'package:reaction_trainer/screens/trainer_screen.dart';
import 'package:reaction_trainer/themes/app_colors.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage > {
  List<String> history = []; // Armazena o histórico de tempos de reação

  @override
  Widget build(BuildContext context) {
    final media_query = MediaQuery.of(context).size;
    final screen_width = media_query.width;
    final screen_height = media_query.height;

    final is_mobile = screen_width < 600;

    return Scaffold(
      appBar: AppBar(
        title: Text('Home', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
        centerTitle: true,
        backgroundColor: AppColors.nitroOrange,
        foregroundColor: Colors.white,
      ),
      body: Row(
        children: [
          Expanded(
            child: Center(
              child: Container(
                width: screen_width,
                height: screen_height,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.nitroBlue, 
                      AppColors.powerGreen,
                      AppColors.nitroBlue],
                      begin: Alignment.bottomCenter,)
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center, 
                  children: [
                    Container(
                      child:
                      is_mobile
                      ? Column(
                        children: [
                          Padding(padding: EdgeInsets.only(
                            top: 25
                          )),
                          // Primeiro Container (Treinamento)
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => TrainingPage(history: history)),
                              );
                            },
                            child: Container(
                              constraints: BoxConstraints(
                                maxWidth: 250,
                                minHeight: 186
                              ),
                              width: MediaQuery.of(context).size.width/1.7,
                              height: MediaQuery.of(context).size.height/3.5,
                              decoration: BoxDecoration(
                                color: AppColors.nitroOrange,
                                borderRadius: BorderRadius.circular(35),
                                boxShadow: const [BoxShadow(color: Colors.orangeAccent, blurRadius: 15, offset: Offset(4, 4))]
                              ),
                              child: const Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Icon(Icons.sports_score, size: 150, color: Color.fromARGB(255, 6, 0, 110)),
                                  Text('Treinamento', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 6, 0, 110)),)
                              ],),
                            ),
                          ),
                          Padding(padding: EdgeInsets.all(25)),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HistoryPage()
                                ),
                              );
                            },
                            child: Container(
                              constraints: BoxConstraints(
                                maxWidth: 250,
                                minHeight: 186
                              ),
                              width: MediaQuery.of(context).size.width/1.7,
                              height: MediaQuery.of(context).size.height/3.5,
                              decoration: BoxDecoration(
                                color: AppColors.nitroOrange,
                                borderRadius: BorderRadius.circular(35),
                                boxShadow: const [BoxShadow(color: Colors.orangeAccent, blurRadius: 15, offset: Offset(4, 4))]
                              ),
                              child: const Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Icon(Icons.history, size: 150, color: Color.fromARGB(255, 6, 0, 110)),
                                  Text('Histórico', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 6, 0, 110)),)
                              ],),
                            ),
                          ),
                        ],
                      )
                      : Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Primeiro Container (Treinamento)
                            GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => TrainingPage(history: history)),
                              );
                            },
                            child: Container(
                              constraints: BoxConstraints(
                                maxWidth: 250,
                                minHeight: 186
                              ),
                              width: MediaQuery.of(context).size.width/1.7,
                              height: MediaQuery.of(context).size.height/3.5,
                              decoration: BoxDecoration(
                                color: AppColors.nitroOrange,
                                borderRadius: BorderRadius.circular(35),
                                boxShadow: const [BoxShadow(color: Colors.orangeAccent, blurRadius: 15, offset: Offset(4, 4))]
                              ),
                              child: const Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Icon(Icons.sports_score, size: 150, color: Color.fromARGB(255, 6, 0, 110)),
                                  Text('Treinamento', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 6, 0, 110)),)
                              ],),
                            ),
                          ),
                          Padding(padding: EdgeInsets.all(25)),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HistoryPage()
                                ),
                              );
                            },
                            child: Container(
                              constraints: BoxConstraints(
                                maxWidth: 250,
                                minHeight: 186
                              ),
                              width: MediaQuery.of(context).size.width/1.7,
                              height: MediaQuery.of(context).size.height/3.5,
                              decoration: BoxDecoration(
                                color: AppColors.nitroOrange,
                                borderRadius: BorderRadius.circular(35),
                                boxShadow: const [BoxShadow(color: Colors.orangeAccent, blurRadius: 15, offset: Offset(4, 4))]
                              ),
                              child: const Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Icon(Icons.history, size: 150, color: Color.fromARGB(255, 6, 0, 110)),
                                  Text('Histórico', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 6, 0, 110)),)
                              ],),
                            ),
                          ),
                          ],
                        ),
                      )
                    )
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
