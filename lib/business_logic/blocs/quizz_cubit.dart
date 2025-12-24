import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tp1_quizz_app/business_logic/blocs/quizz_state.dart';
import 'package:tp1_quizz_app/data/repositories/quizz_repository.dart';
import '../../../data/models/question.dart';
import 'package:flutter/material.dart';

class QuizCubit extends Cubit<QuizState> {
  final QuizRepository _repository;
  List<Question> _questions = [];

  QuizCubit(this._repository) : super(const QuizLoading());

  Future<void> loadQuestions({String? category, int? limit}) async {
    emit(const QuizLoading());
    try {
      _questions = await _repository.getQuestions(category: category, limit: limit);

      if (_questions.isNotEmpty) {
        emit(QuizQuestionLoaded(
          currentQuestionIndex: 0,
          score: 0,
          scoreKeeper: const [],
          answerWasChosen: false,
          currentQuestion: _questions[0],
          questions: _questions,
        ));
      } else {
        emit(const QuizError("Aucune question disponible."));
      }
    } catch (e) {
      emit(QuizError(e.toString()));
    }
  }

  int get totalQuestions => _questions.length;

  void checkAnswer(bool userChoice) {
    if (state.answerWasChosen || state is! QuizQuestionLoaded) return;

    final currentState = state as QuizQuestionLoaded;
    bool correctAnswer = currentState.currentQuestion.isCorrect;

    final newScoreKeeper = List<Icon>.from(currentState.scoreKeeper);
    int newScore = currentState.score;

    if (userChoice == correctAnswer) {
      newScore++;
      newScoreKeeper.add(const Icon(Icons.check, color: Colors.green));
    } else {
      newScoreKeeper.add(const Icon(Icons.close, color: Colors.red));
    }

    emit(currentState.copyWith(
      score: newScore,
      scoreKeeper: newScoreKeeper,
      answerWasChosen: true,
    ));

    // Petit délai pour laisser l'utilisateur voir le résultat (check/close)
    // avant de passer à la suite automatiquement
    Future.delayed(const Duration(milliseconds: 800), () {
      nextQuestion();
    });
  }

  void nextQuestion() {
    if (state is! QuizQuestionLoaded) return;
    final currentState = state as QuizQuestionLoaded;

    int nextIndex = currentState.currentQuestionIndex + 1;

    if (nextIndex < _questions.length) {
      emit(QuizQuestionLoaded(
        currentQuestionIndex: nextIndex,
        score: currentState.score,
        scoreKeeper: currentState.scoreKeeper,
        answerWasChosen: false,
        currentQuestion: _questions[nextIndex],
        questions: _questions,
      ));
    } else {
      // FIN DU QUIZ : On émet l'état QuizFinished
      emit(QuizFinished(
        score: currentState.score,
        total: _questions.length,
      ));
    }
  }

  void resetQuiz() {
    if (_questions.isNotEmpty) {
      emit(QuizQuestionLoaded(
        currentQuestionIndex: 0,
        score: 0,
        scoreKeeper: const [],
        answerWasChosen: false,
        currentQuestion: _questions[0],
        questions: _questions,
      ));
    }
  }
}