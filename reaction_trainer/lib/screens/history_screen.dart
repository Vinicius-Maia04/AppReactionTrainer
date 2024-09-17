import 'package:flutter/material.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Histórico'),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          ElevatedButton(onPressed: (){
          }, child: Text('Teste'))
        ],
      ),
    );
  }
}