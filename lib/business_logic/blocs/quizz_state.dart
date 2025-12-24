import 'package:flutter/material.dart';
import '../../../data/models/question.dart';

abstract class QuizState {
  final int currentQuestionIndex;
  final int score;
  final List<Icon> scoreKeeper;
  final bool answerWasChosen;

  const QuizState({
    required this.currentQuestionIndex,
    required this.score,
    required this.scoreKeeper,
    required this.answerWasChosen,
  });
}

class QuizLoading extends QuizState {
  const QuizLoading() : super(
      currentQuestionIndex: 0,
      score: 0,
      scoreKeeper: const [],
      answerWasChosen: false
  );
}

class QuizQuestionLoaded extends QuizState {
  final Question currentQuestion;
  final List<Question> questions; // <-- Le champ manquant

  const QuizQuestionLoaded({
    required int currentQuestionIndex,
    required int score,
    required List<Icon> scoreKeeper,
    required bool answerWasChosen,
    required this.currentQuestion,
    required this.questions, // <-- Ajouté ici
  }) : super(
    currentQuestionIndex: currentQuestionIndex,
    score: score,
    scoreKeeper: scoreKeeper,
    answerWasChosen: answerWasChosen,
  );

  // Méthode CopyWith mise à jour
  QuizQuestionLoaded copyWith({
    int? currentQuestionIndex,
    int? score,
    List<Icon>? scoreKeeper,
    bool? answerWasChosen,
    Question? currentQuestion,
    List<Question>? questions,
  }) {
    return QuizQuestionLoaded(
      currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
      score: score ?? this.score,
      scoreKeeper: scoreKeeper ?? this.scoreKeeper,
      answerWasChosen: answerWasChosen ?? this.answerWasChosen,
      currentQuestion: currentQuestion ?? this.currentQuestion,
      questions: questions ?? this.questions,
    );
  }
}

// État pour la navigation vers la page de score
class QuizFinished extends QuizState {
  final int total;

  const QuizFinished({
    required int score,
    required this.total,
  }) : super(
    currentQuestionIndex: 0,
    score: score,
    scoreKeeper: const [],
    answerWasChosen: true,
  );
}

class QuizError extends QuizState {
  final String message;
  const QuizError(this.message) : super(
      currentQuestionIndex: 0,
      score: 0,
      scoreKeeper: const [],
      answerWasChosen: false
  );
}