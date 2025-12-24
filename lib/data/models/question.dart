import 'package:flutter/material.dart';

class Question {
  final String id; // Ajout de l'ID pour faciliter la gestion
  final String questionText;
  final bool isCorrect;
  final String imageUrl;
  final String category;

  const Question({
    required this.id,
    required this.questionText,
    required this.isCorrect,
    required this.imageUrl,
    this.category = "Général",
  });

  // Convertit un document Firestore en objet Question
  factory Question.fromFirestore(Map<String, dynamic> data, String id) {
    return Question(
      id: id,
      questionText: data['text'] ?? '',
      isCorrect: data['isCorrect'] ?? false,
      imageUrl: data['imageUrl'] ?? '',
      category: data['category'] ?? 'Général',
    );
  }

  // Convertit un objet Question en Map pour Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'text': questionText,
      'isCorrect': isCorrect,
      'imageUrl': imageUrl,
      'category': category,
    };
  }
}