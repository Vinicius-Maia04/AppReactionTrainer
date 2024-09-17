import 'package:flutter/material.dart';
import 'package:reaction_trainer/screens/history_screen.dart';
import 'package:reaction_trainer/screens/trainer_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        centerTitle: true,
        backgroundColor: Colors.red,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: GestureDetector(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => TrainingScreen())),
              child: Container(
                width: MediaQuery.of(context).size.width/1.7,
                height: MediaQuery.of(context).size.height/3.5,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 197, 197, 197),
                  borderRadius: BorderRadius.circular(35),
                  boxShadow: const [BoxShadow(color: Colors.grey, blurRadius: 15, offset: Offset(4, 4))]
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(Icons.sports_score, size: 150, color: Colors.red,),
                    Text('Iniciar Treinamento', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),)
                  ],),
              ),
            ),
          ),
          Padding(padding: EdgeInsets.all(25)),
          Center(
            child: GestureDetector(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => HistoryScreen())),
              child: Container(
                width: MediaQuery.of(context).size.width/1.7,
                height: MediaQuery.of(context).size.height/3.5,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 197, 197, 197),
                  borderRadius: BorderRadius.circular(35),
                  boxShadow: const [BoxShadow(color: Colors.grey, blurRadius: 15, offset: Offset(4, 4))]
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(Icons.history, size: 150, color: Colors.red,),
                    Text('Ver Histórico', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),)
                  ],),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

