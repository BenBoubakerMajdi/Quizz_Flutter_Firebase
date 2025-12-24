// data/repositories/quizz_repository.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/question.dart';

class QuizRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<Question>> getQuestions({String? category, int? limit}) async {
    Query query = _db.collection('questions');

    if (category != null && category != "Aléatoire") {
      query = query.where('category', isEqualTo: category);
    }

    QuerySnapshot snapshot = await query.get();

    List<Question> questions = snapshot.docs.map((doc) {
      return Question.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
    }).toList();

    if (category == "Aléatoire") {
      questions.shuffle();
    }

    // On applique la limite demandée par l'utilisateur
    if (limit != null && questions.length > limit) {
      return questions.sublist(0, limit);
    }

    return questions;
  }

  Future<void> addQuestion(Question question) async {
    await _db.collection('questions').add({
      'text': question.questionText,
      'isCorrect': question.isCorrect,
      'category': question.category,
      'imageUrl': question.imageUrl,
    });
  }
}