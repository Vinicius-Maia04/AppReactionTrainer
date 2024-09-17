import 'package:flutter/material.dart';
import 'package:quiver/async.dart';
import 'package:reaction_trainer/themes/app_colors.dart';


var lamp1Color = AppColors.lamp1Off;
var lamp2Color = AppColors.lamp1Off;
var lamp3Color = AppColors.lamp1Off;
var lamp4Color = AppColors.lamp1Off;
var lamp5Color = AppColors.lamp1Off;

void startTimer() {
  int _start = 5;

  CountdownTimer countDownTimer = new CountdownTimer(
    new Duration(seconds: _start),
    new Duration(seconds: 1),
  );

  var sub = countDownTimer.listen(null);
  sub.onData((duration) {
    setState(){
    _start - duration.elapsed.inSeconds;
    if (_start >= 5){
      lamp1Color = AppColors.lampOn;
    } if (_start >= 4){
      lamp2Color = AppColors.lampOn;
    } if (_start >= 3){
      lamp3Color = AppColors.lampOn;
    } if (_start >= 2){
      lamp4Color = AppColors.lampOn;
    } if (_start >= 1){
      lamp5Color = AppColors.lampOn;
    }
    }
  });

  sub.onDone(() {
    print("Done");
    sub.cancel();
  });
}

class TrainingScreen extends StatefulWidget {
  const TrainingScreen({super.key});

  @override
  State<TrainingScreen> createState() => _TrainingScreenState();
}

class _TrainingScreenState extends State<TrainingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Treinamento'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(padding: EdgeInsets.only(top: 25)),
          Center(
            child: Row(
              children: [
                Padding(padding: EdgeInsets.all(5)),
                AnimatedContainer(
                  duration: Duration(microseconds: 0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: lamp1Color,
                  ),
                  width: MediaQuery.of(context).size.width/5.5,
                  height: MediaQuery.of(context).size.width/5.5,
                ),
                Padding(padding: EdgeInsets.all(5)),  
                AnimatedContainer(
                  duration: Duration(microseconds: 0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: lamp2Color,
                  ),
                  width: MediaQuery.of(context).size.width/5.5,
                  height: MediaQuery.of(context).size.width/5.5,
                ),
                Padding(padding: EdgeInsets.all(5)),
                AnimatedContainer(
                  duration: Duration(microseconds: 0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: lamp3Color,
                  ),
                  width: MediaQuery.of(context).size.width/5.5,
                  height: MediaQuery.of(context).size.width/5.5,
                ),
                Padding(padding: EdgeInsets.all(5)),
                AnimatedContainer(
                  duration: Duration(microseconds: 0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: lamp4Color
                  ),
                  width: MediaQuery.of(context).size.width/5.5,
                  height: MediaQuery.of(context).size.width/5.5,
                ),
                Padding(padding: EdgeInsets.all(5)),
                AnimatedContainer(
                  duration: Duration(microseconds: 0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: lamp5Color
                  ),
                  width: MediaQuery.of(context).size.width/5,
                  height: MediaQuery.of(context).size.width/5,
                ),
                Padding(padding: EdgeInsets.all(5)),
              ],
            ),
          ),
          ElevatedButton(onPressed: (){
            startTimer();
          }, child: Text('Começar'))
        ],
      ),
    );
  }
}


