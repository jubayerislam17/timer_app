import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'package:just_audio/just_audio.dart';
import 'finished_timer_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Timer _timer;

  late AudioPlayer player;


  void loadAudio(){
    player.setAsset('resource/alarm.wav');
  }

  void playAudio() {
    player.play();
  }

  void pauseAudio() {
    player.pause();
  }

  void stopAudio() {
    player.stop();
  }




  int _seconds = 6;
  bool _isRunning = false;
  int _tempseconds = 0;

  @override
  void initState() {
    super.initState();
    player = AudioPlayer();
    startTimer();
  }

  void startTimer() {
    if(!_isRunning) {
      const second = Duration(seconds: 1);
      _timer = Timer.periodic(second, (Timer timer) {
        setState(() {
            if (_seconds > 0) {
              _seconds--;
            } else {
              _timer.cancel();
              _isRunning = false;

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FinishedTimerScreen(),
                ),
              );

            }
        });
      });
    }
  }

  void pauseTimer() {
    _timer.cancel();
    setState(() {
      _tempseconds = _seconds;
      _isRunning = false;
    });
  }

  void resetTimer() {
    _timer.cancel();
    setState(() {
      _seconds = 6;
      _tempseconds = 6;
      _isRunning = false;
    });
  }

  String getTimerText() {

    if(!_isRunning){
      _seconds = _tempseconds;
    }

    int hours = (_seconds ~/ 3600);
    int minutes = (_seconds ~/ 60) % 60;
    int seconds = _seconds % 60;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  double getProgress() {
    return (_seconds) / 6;
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              height: 200,
              width: 200,
                  child : CircularProgressIndicator(
                    value: getProgress(),
                    strokeWidth: 30,
                  ),
            ),
            Center(
              child: Text(
                getTimerText(),
                style: GoogleFonts.aBeeZee(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.play_arrow),
                    onPressed: () {
                      setState(() {
                        if (!_isRunning) {
                          startTimer();
                          _isRunning = true;
                        }
                      });
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.pause),
                    onPressed: () {
                      setState(() {
                        if (_isRunning) {
                          pauseTimer();
                        }
                      });
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.restore),
                    onPressed: () {
                      setState(() {

                        loadAudio();
                        playAudio();

                        resetTimer();
                      });
                    },
                  ),
                ],
              ),
            ),
          ],

        ),
      ),
    );
  }
}
