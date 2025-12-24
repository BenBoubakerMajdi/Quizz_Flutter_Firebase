import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:audioplayers/audioplayers.dart';

class ScorePage extends StatefulWidget {
  final int score;
  final int totalQuestions;

  const ScorePage({super.key, required this.score, required this.totalQuestions});

  @override
  State<ScorePage> createState() => _ScorePageState();
}

class _ScorePageState extends State<ScorePage> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  late bool isWin;

  @override
  void initState() {
    super.initState();
    // On considère une victoire si le score est supérieur à la moitié
    isWin = widget.score >= (widget.totalQuestions / 2);
    _playFeedback();
  }

  void _playFeedback() async {
    String soundPath = isWin ? 'sounds/win.mp3' : 'sounds/loss.mp3';
    await _audioPlayer.play(AssetSource(soundPath));
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isWin ? Colors.green.shade900 : Colors.red.shade900,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ANIMATION LOTTIE
            Lottie.asset(
              isWin ? 'assets/animations/win.json' : 'assets/animations/loss.json',
              width: 500,
              height: 500,
              repeat: isWin, // Répéter l'animation si c'est une victoire
            ),

            const SizedBox(height: 20),

            Text(
              isWin ? "FÉLICITATIONS !" : "DOMMAGE...",
              style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white
              ),
            ),

            const SizedBox(height: 10),

            Text(
              "Ton score : ${widget.score} / ${widget.totalQuestions}",
              style: const TextStyle(fontSize: 24, color: Colors.white70),
            ),

            const SizedBox(height: 50),

            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
              child: const Text("RETOUR AU MENU"),
            ),
          ],
        ),
      ),
    );
  }
}