import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tp1_quizz_app/business_logic/blocs/quizz_cubit.dart';
import 'package:tp1_quizz_app/business_logic/blocs/quizz_state.dart';
import 'package:tp1_quizz_app/presentation/pages/score_page.dart'; // Import de ta nouvelle page

class QuizzPage extends StatelessWidget {
  const QuizzPage({Key? key, required this.title}) : super(key: key);
  final String title;

  Widget _buildQuestionImage(String imageUrl) {
    bool isLocal = imageUrl.startsWith('/data/') || imageUrl.startsWith('/cache/');
    return Container(
      height: 250,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        color: Colors.black26,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15.0),
        child: isLocal
            ? Image.file(File(imageUrl), fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => const Icon(Icons.broken_image, size: 50, color: Colors.white24))
            : Image.network(imageUrl.trim(), fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => const Icon(Icons.image_not_supported, size: 50, color: Colors.white24)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final quizCubit = context.read<QuizCubit>();

    return BlocListener<QuizCubit, QuizState>(
      listener: (context, state) {
        // Redirection automatique vers la ScorePage avec sons et animations
        if (state is QuizFinished) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ScorePage(
                score: state.score,
                totalQuestions: state.total,
              ),
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: Colors.blueGrey.shade900,
        appBar: AppBar(
          title: Text(title),
          backgroundColor: Colors.blueGrey,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              quizCubit.resetQuiz();
              Navigator.of(context).pop();
            },
          ),
        ),
        body: BlocBuilder<QuizCubit, QuizState>(
          builder: (context, state) {
            if (state is QuizLoading) {
              return const Center(child: CircularProgressIndicator(color: Colors.blue));
            }

            if (state is QuizError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    state.message, // CORRIGÉ : On utilise .message au lieu de .errorMessage
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.redAccent, fontSize: 18),
                  ),
                ),
              );
            }

            if (state is QuizQuestionLoaded) {
              final currentQuestion = state.currentQuestion;

              return Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    _buildQuestionImage(currentQuestion.imageUrl),
                    Expanded(
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Text(
                            currentQuestion.questionText,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 24.0, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: ElevatedButton(
                            onPressed: state.answerWasChosen ? null : () => quizCubit.checkAnswer(true),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              padding: const EdgeInsets.all(18.0),
                            ),
                            child: const Text('VRAI', style: TextStyle(fontSize: 20.0, color: Colors.white)),
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: state.answerWasChosen ? null : () => quizCubit.checkAnswer(false),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              padding: const EdgeInsets.all(18.0),
                            ),
                            child: const Text('FAUX', style: TextStyle(fontSize: 20.0, color: Colors.white)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Indicateurs de score en bas
                    SizedBox(
                      height: 30,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(children: state.scoreKeeper),
                      ),
                    ),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}