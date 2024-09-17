import 'package:flutter/material.dart';
import 'package:reaction_trainer/screens/home_screen.dart';

void main() {
  runApp(const ReactionTrainer());
}

class ReactionTrainer extends StatelessWidget {
  const ReactionTrainer({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reaction Trainer',
      theme: ThemeData(colorSchemeSeed: Colors.purple, useMaterial3: true),
      home: HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}